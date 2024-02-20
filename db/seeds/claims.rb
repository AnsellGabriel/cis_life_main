# claims
analyst = Employee.create!(first_name: 'Rulian', middle_name: 'P.', last_name: 'Rong', birthdate: '1996-09-03', department_id: 19)
User.create!(email: "claim_analyst@gmail.com",  password: 'Password123!', userable: analyst, approved: 1)

puts 'Claim analyst created'

[
  "Certified True Copy of Death Certificate",
  "Attending Physician's Statement",
  "Claimant's Statement",
  "Police Report or Incident Report or Barangay Certification",
  "Loan Ledger",
  "Certified True Copy of Monthly Amortization Schedule",
  "Certified True Copy of Share Capital",
  "Certified True Copy of Savings Passbook",
  "Affidavit of two (2) disinterested persons or Certification from Cooperative",
  "Waiver of Rights of the declared beneficiary",
  "Affidavit of Guardianship",
  "Death Certificate - authenticated by the Phil. Statistics Authority",
  "Certified True Photocopy of Passport",
  "Barangay Certification",
  "Certificate of No Marriage (CENOMAR)",
  "Notarized Affidavit of Late Filing",
  "Proof that will support  the Notarized Affidavit of Late Filing",
  "Official Receipt or Billing Statement",
  "Medical Certificate",
  "Operative / Surgical Report",
  "Original Official Receipts paid to the hospital or doctor/s",
  "Statement of Account (SOA) / Hospital Billing and corresponding Charge Slips from the Hospital",
  "Other Medical Records"
].each do |doc|
  document = Document.new(name: doc)
  puts "Document: #{doc} added" if document.save!
end

["Life", "Accidental Death & Dismemberment", "Burial"].each do |benefit|
  claim_type = ClaimType.create!(name: benefit)
end

puts 'Claim types created'
