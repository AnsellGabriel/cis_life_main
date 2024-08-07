class Transmittal < ApplicationRecord
  attr_accessor :group_remit_ids
  has_many :transmittal_ors, dependent: :destroy
  has_many :transmittables, through: :transmittal_ors
  belongs_to :user

  validates_presence_of :code, :transmittal_type

  accepts_nested_attributes_for :transmittal_ors, reject_if: :all_blank, allow_destroy: true

  enum transmittal_type: { mis: 0, und: 1 }

  def save_items(items=nil, group_remit_ids=nil)
    unless items.nil?
      items.each do |key, value|
        obj = GlobalID::Locator.locate value[:transmittable]
        self.transmittal_ors.build(transmittable: obj)
      end
    else

      ids = group_remit_ids.split(" ")
      group_remits = GroupRemit.where(id: ids)
      group_remits.each do |gr|
        self.transmittal_ors.build(transmittable: gr)
      end
      self.save!
    end
  end

  def set_code_and_type(current_user)
    self.code = case self.transmittal_type
    when "mis"
      count = Transmittal.where(transmittal_type: :mis).count
      "MIS-TRANMISTTAL-" + sprintf("%05d", count + 1)
    else
      count = Transmittal.where(transmittal_type: :und).count
      "UND-TRANMISTTAL-" + sprintf("%05d", count + 1)
    end

    self.transmittal_type = case current_user.is_mis?
    when true
      :mis
    else
      :und
    end
  end

  def transmittable_collection(current_user)
    if current_user.is_mis?
      Treasury::CashierEntry::ORS
    elsif current_user.is_und?
      ProcessCoverage::PCS
    else
      Treasury::CashierEntry::ORS + ProcessCoverage::PCS
    end
  end
end
