class NotificationService
  def initialize(receiver, message)
    @receiver = receiver
    @message = message
  end

  def notify
    # send email to user
    Notification.create(notifiable: @receiver, message: @message)
  end
end
