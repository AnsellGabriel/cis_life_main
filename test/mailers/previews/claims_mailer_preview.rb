# Preview all emails at http://localhost:3000/rails/mailers/claims_mailer
class ClaimsMailerPreview < ActionMailer::Preview

  # Preview this email at http://localhost:3000/rails/mailers/claims_mailer/new_claim_email
  def new_claim_email
    ClaimsMailer.new_claim_email
  end

end
