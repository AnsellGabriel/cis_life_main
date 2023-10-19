class Cooperative < ApplicationRecord
    has_many :coop_users
    has_many :coop_branches

    has_many :coop_members, dependent: :destroy
    has_many :members, through: :coop_members

    has_many :agreements
    has_many :group_remits
    has_many :denied_enrollees
    has_many :notifications, as: :notifiable, dependent: :destroy

    has_many :check_vouchers, as: :payable, class_name: 'Accounting::CheckVoucher', dependent: :destroy

    belongs_to :coop_type, optional: true
    belongs_to :geo_region, optional: true
    belongs_to :geo_province, optional: true
    belongs_to :geo_municipality, optional: true
    belongs_to :geo_barangay, optional: true

    def to_s
      name
    end

    def get_address
      # unless geo_province_id.nil? && geo_municipality_id.nil? && geo_barangay_id.nil?
      #   "#{street}, #{geo_municipality.name}, #{geo_province.name}, #{geo_region.name}"
      # end
      street = self.street if !self.street.blank?

      [street, geo_barangay&.name, geo_municipality&.name, geo_province&.name].compact.join(', ')
    end

    def unselected_coop_members(ids)
      coop_members.where.not(id: ids)
    end

    def get_fulladdress
      "#{street}, #{municipality}, #{province}, #{region}"
    end

    def coop_member_details
		  coop_members.includes(:member).order('members.last_name')
    end

    def filtered_agreements(filter)
    	agreements.with_moa_like(filter).includes({anniversaries: :group_remits}, :agent, :group_remits).order(updated_at: :desc)
    end
end
