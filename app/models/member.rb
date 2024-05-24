class Member < ApplicationRecord
  before_validation :uppercase_fields
  before_validation :validate_phone_format

  # VALID_PH_MOBILE_NUMBER_REGEX = /\A(09|\+639)\d{9}\z/
  # VALID_PH_LANDLINE_NUMBER_REGEX = /\A(02|03[2-9]|042|043|044|045|046|047|048|049|052|053|054|055|056|057|058|072|074|075|076|077|078)\d{7}\z/

  # validates :mobile_number, presence: true
  # format: {
  #   # with: VALID_PH_MOBILE_NUMBER_REGEX,
  #   message: "must be a valid Philippine mobile number"
  # }
  # validates :work_phone_number, allow_blank: true, format: {
  #   with: /\A#{VALID_PH_MOBILE_NUMBER_REGEX}|#{VALID_PH_LANDLINE_NUMBER_REGEX}\z/,
  #   message: "must be a valid Philippine mobile or landline number"
  # }
  belongs_to :geo_region, optional: true
  belongs_to :geo_province, optional: true
  belongs_to :geo_municipality, optional: true
  belongs_to :geo_barangay, optional: true

  validates_presence_of :last_name, :first_name, :birth_date
  validates_presence_of :gender, if: :new_record?

  # validates :email, format: { with: URI::MailTo::EMAIL_REGEXP }
  # belongs_to :coop_branch

  has_many :coop_members, dependent: :destroy
  has_many :cooperatives, through: :coop_members

  has_many :member_dependents, dependent: :destroy
  accepts_nested_attributes_for :coop_members

  def unselected_dependents(selected_dependent_ids)
    member_dependents.where.not(id: selected_dependent_ids)
  end

  def to_s
    full_name
  end

  def validate_phone_format
    # Regular expression to match the valid phone number formats
    # The phone number must start with either '09' or '+639' followed by 9 digits.
    /^(09|\+639)\d{9}$/.match?(self.mobile_number)
  end

  def age(effectivity_date = nil)
    if effectivity_date.nil?
      Date.today.year - self.birth_date.year - ((Date.today.month > self.birth_date.month || (Date.today.month == self.birth_date.month && Date.today.day >= self.birth_date.day)) ? 0 : 1)
    else
      ((effectivity_date - self.birth_date) / 365).round
    end
  end

  def coop_member_id(coop)
    coop_members.find_by(cooperative_id: coop.id).id
  end

  def full_address
    # "#{self&.address}, #{geo_barangay&.name}, #{geo_municipality&.name}, #{geo_province&.name}, #{geo_region&.name}"

    [self&.address, geo_barangay&.name, geo_municipality&.name, geo_province&.name].compact.join(", ")
  end

  def full_name
    "#{last_name}, #{first_name} #{middle_name} #{suffix if suffix.present?}"
  end

  def self.get_ri(date_from, date_to)
    # where(for_reinsurance: true)
    joins(coop_members: :loan_batches)
    .where(for_reinsurance: true)
    .where("(loan_insurance_batches.effectivity_date <= ? and loan_insurance_batches.expiry_date >= ?) OR (loan_insurance_batches.effectivity_date <= ? and loan_insurance_batches.expiry_date >= ?)", date_from, date_from, date_to, date_to)
  end

  def get_for_ri_sum(ri, retention)
    ri_start = ri.reinsurance.date_from
    ri_end = ri.reinsurance.date_to

    total_loan_amount = self.coop_members.joins(:loan_batches).where("(loan_insurance_batches.effectivity_date <= ? and loan_insurance_batches.expiry_date >= ?) OR (loan_insurance_batches.effectivity_date <= ? and loan_insurance_batches.expiry_date >= ?)", ri_start, ri_start, ri_end, ri_end).sum(:loan_amount)

    if total_loan_amount >= retention
      self.coop_members.each do |cm|
        cm.loan_batches.where("(loan_insurance_batches.effectivity_date <= ? and loan_insurance_batches.expiry_date >= ?) OR (loan_insurance_batches.effectivity_date <= ? and loan_insurance_batches.expiry_date >= ?)", ri_start, ri_start, ri_end, ri_end).each do |batch|
          ri_date = batch.reinsurance_batches.find_by(batch: batch).nil? ? ri.reinsurance.date_from : batch.reinsurance_batches.find_by(batch: batch).ri_date

          # ri.batches << batch
          ri_batch = ReinsuranceBatch.find_or_initialize_by(reinsurance_member: ri, batch: batch)
          ri_batch.ri_date = ri_date

          if ri.reinsurance.date_from < ri_batch.batch.effectivity_date
            ri_batch.ri_effectivity = ri_batch.batch.effectivity_date.beginning_of_month
          else
            ri_batch.ri_effectivity = ri_start
          end
          if ri_batch.batch.expiry_date < ri.reinsurance.date_to
            ri_batch.ri_expiry = ri_batch.batch.expiry_date
          else
            ri_batch.ri_expiry = ri_end
          end

          # ri_batch.ri_terms = ((ri_batch.ri_expiry - ri_batch.ri_effectivity) / 30).to_i
          ri_batch.ri_terms = ((ri_batch.ri_expiry - ri_batch.ri_effectivity) / 30).round
          ri_batch.save!

        end
      end
    end



    # self.coop_members.each do |cm|

    #   # self.joins(:coop_member).each do |cm|
    #   total = cm.loan_batches.where("(loan_insurance_batches.effectivity_date <= ? and loan_insurance_batches.expiry_date >= ?) OR (loan_insurance_batches.effectivity_date <= ? and loan_insurance_batches.expiry_date >= ?)", ri_start, ri_start, ri_end, ri_end).sum(:loan_amount)
    #   # total += cm.loan_batches.where("(effectivity_date <= ? and expiry_date >= ?) OR (effectivity_date <= ? and expiry_date >= ?)", ri_start, ri_start, ri_end, ri_end).sum(:loan_amount)
    #   if total >= retention
    #     cm.loan_batches.where("(effectivity_date <= ? and expiry_date >= ?) OR (effectivity_date <= ? and expiry_date >= ?)", ri_start, ri_start, ri_end, ri_end).each do |batch|
    #     # cm.loan_batches.joins(:member).where("(effectivity_date <= ? and expiry_date >= ?) OR (effectivity_date <= ? and expiry_date >= ?)", ri_start, ri_start, ri_end, ri_end).where(member: self).each do |batch|
    #       ri_date = batch.reinsurance_batches.find_by(batch: batch).nil? ? ri.reinsurance.date_from : batch.reinsurance_batches.find_by(batch: batch).ri_date

    #       # ri.batches << batch
    #       ri_batch = ReinsuranceBatch.find_or_initialize_by(reinsurance_member: ri, batch: batch)
    #       ri_batch.ri_date = ri_date
    #       if ri.reinsurance.date_from < ri_batch.batch.effectivity_date
    #         ri_batch.ri_effectivity = ri_batch.batch.effectivity_date.beginning_of_month
    #       else
    #         ri_batch.ri_effectivity = ri_start
    #       end
    #       ri_batch.ri_expiry = ri_end
    #       ri_batch.ri_terms = ((ri_batch.ri_expiry - ri_batch.ri_effectivity) / 30).to_i
    #       ri_batch.save!
    #     end
    #   end
    # end

  end

  private

  def format_phone_numbers
    self.mobile_number = format_phone_number(self.mobile_number)
    self.work_phone_number = format_phone_number(self.work_phone_number)
  end

  def format_phone_number(number)
    combined_regex = /#{VALID_PH_LANDLINE_NUMBER_REGEX}|#{VALID_PH_MOBILE_NUMBER_REGEX}/

    if !number.nil? && number.match(combined_regex)
      return number
    end

    number = number.to_s.gsub(/[^0-9]/, "") # remove all non-digit characters

    if number.length == 10 && number.start_with?("9") # mobile number
      number = "+63#{number}"
    elsif number.length == 7 && ["02", "03", "032", "033", "034", "035", "036", "037", "038", "039", "042", "043", "044", "045", "046", "047", "048", "049", "052", "053", "054", "055", "056", "057", "058", "072", "074", "075", "076", "077", "078"].include?(number[0..2]) # landline number
      number = "+63#{number}"
    else
      number = nil
    end
    number
  end

  def uppercase_fields
    self.last_name = self.last_name ? self.last_name.squish.upcase : ''
    self.first_name = self.first_name ? self.first_name.squish.upcase : ''
    self.middle_name = self.middle_name ? self.middle_name.squish.upcase : ''
    self.suffix = self.suffix ? self.suffix.squish.upcase : ''
    self.civil_status = self.civil_status ? self.civil_status.squish.upcase : ''
    self.gender = self.gender ? self.gender.squish.upcase : ''
  end

  def self.coop_member_details(coop_members)
    includes(coop_members: :coop_branch).where(coop_members: { id: coop_members&.ids }).order(:last_name)
  end

  def self.filter_by_coop_member_id(id)
    where(coop_members: { id: id })
  end

  def self.filter_by_name(last_name_filter, first_name_filter)
    where("last_name LIKE ? AND first_name LIKE ?", "%#{last_name_filter}%", "%#{first_name_filter}%")
  end

  # Ransack custom search
  def self.ransackable_attributes(auth_object = nil)
    ["email", "first_name", "last_name", "middle_name", "mobile_number"]
  end

  def self.ransackable_associations(auth_object = nil)
    []
  end

end
