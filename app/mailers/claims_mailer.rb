class ClaimsMailer < ApplicationMailer

  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.claims_mailer.new_claim_email.subject
  #
  def new_claim_email
    @process_claim = params[:process_claim]
    @name = @process_claim.claimable.get_fullname

    attachments.inline['cis_logo.png'] = File.read('app/assets/images/50email.png')
    mail(
          from: "1cispga@gmail.com",
          to:"ansellgabriel@gmail.com", 
          cc: "1cispga@gmail.com", 
          subject: "CIS Claims for process "
    )
    # @greeting = "Hi"

    # mail to: "to@example.org"
  end
end
