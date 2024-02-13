class Remittance < GroupRemit

  # converts the official_receipt to a string for ransack to be able to search it using 'contains' or 'like'
  ransacker :official_receipt do
    Arel.sql("CONVERT(`group_remits`.`official_receipt`, CHAR(8))")
  end

  def self.ransackable_attributes(auth_object = nil)
    ["name", "official_receipt"]
  end

  def self.ransackable_associations(auth_object = nil)
    []
  end
end
