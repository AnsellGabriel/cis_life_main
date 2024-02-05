class Remittance < GroupRemit
  def self.ransackable_attributes(auth_object = nil)
    ["name", "or_number"]
  end

  def self.ransackable_associations(auth_object = nil)
    []
  end
end
