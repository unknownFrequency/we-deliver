class UserMailer < ApplicationMailer
  default from: 'Ruben Thuesen <faktura@wedeliver.dk>'

  def invoice_email(user, order)
    Rails.logger.debug(user)
    @order, @user = order, user
    mail(to: @user.email, subject: 'weDELIVER faktura')
  end
end
