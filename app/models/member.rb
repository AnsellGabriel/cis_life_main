class Member < ApplicationRecord
  before_validation :uppercase_fields
  before_validation :format_phone_numbers
  before_save :capitalize_status

  VALID_PH_MOBILE_NUMBER_REGEX = /\A(09|\+639)\d{9}\z/
  VALID_PH_LANDLINE_NUMBER_REGEX = /\A(02|03[2-9]|042|043|044|045|046|047|048|049|052|053|054|055|056|057|058|072|074|075|076|077|078)\d{7}\z/

  validates :mobile_number, presence: true, format: { 
    with: VALID_PH_MOBILE_NUMBER_REGEX, 
    message: "must be a valid Philippine mobile number" 
  }
  validates :work_phone_number, allow_blank: true, format: { 
    with: /\A#{VALID_PH_MOBILE_NUMBER_REGEX}|#{VALID_PH_LANDLINE_NUMBER_REGEX}\z/, 
    message: "must be a valid Philippine mobile or landline number" 
  }

  validates_presence_of :last_name, :first_name, :middle_name, :birth_date, :address, :civil_status, :gender
  validates :email, format: { with: URI::MailTo::EMAIL_REGEXP }

  # belongs_to :coop_branch

  has_many :coop_members, dependent: :destroy
  has_many :cooperatives, through: :coop_members

  has_many :member_dependents, dependent: :destroy
  accepts_nested_attributes_for :coop_members

  def unselected_dependents(selected_dependent_ids)
    member_dependents.where.not(id: selected_dependent_ids)
  end

  def to_s
    full_name.titleize
  end

  def age
    Date.today.year - self.birth_date.year - ((Date.today.month > self.birth_date.month || (Date.today.month == self.birth_date.month && Date.today.day >= self.birth_date.day)) ? 0 : 1)
  end

  def coop_member_id(coop)
    coop_members.find_by(cooperative_id: coop.id).id
  end

  def full_name
    "#{last_name}, #{first_name} #{middle_name} #{suffix}"
  end

  private
  def capitalize_status
    self.civil_status = self.civil_status.titleize
  end

  
  def format_phone_numbers
    self.mobile_number = format_phone_number(self.mobile_number)
    self.work_phone_number = format_phone_number(self.work_phone_number)
  end

  def format_phone_number(number)
    combined_regex = /#{VALID_PH_LANDLINE_NUMBER_REGEX}|#{VALID_PH_MOBILE_NUMBER_REGEX}/

    if number.match(combined_regex)
      return number
    end

    number = number.to_s.gsub(/[^0-9]/, '') # remove all non-digit characters
    if number.length == 10 && number.start_with?('9') # mobile number
      number = "+63#{number}"
    elsif number.length == 7 && ['02', '03', '032', '033', '034', '035', '036', '037', '038', '039', '042', '043', '044', '045', '046', '047', '048', '049', '052', '053', '054', '055', '056', '057', '058', '072', '074', '075', '076', '077', '078'].include?(number[0..2]) # landline number
      number = "+63#{number}"
    else
      number = nil
    end
    number
  end
  

  def uppercase_fields
    self.last_name = self.last_name.upcase
    self.first_name = self.first_name.upcase
    self.middle_name = self.middle_name.upcase
    self.suffix = self.suffix == nil ? '' : self.suffix.upcase
    # repeat the above line for each field you want to make all caps
  end

  

  def self.coop_member_details(coop_members)
    includes(coop_members: :coop_branch).where(coop_members: { id: coop_members.ids }).order(:last_name)
  end

  def self.filter_by_name(last_name_filter, first_name_filter)
    where("last_name LIKE ? AND first_name LIKE ?", "%#{last_name_filter}%", "%#{first_name_filter}%")
  end
end
