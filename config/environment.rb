# Load the Rails application.
require_relative 'application'

Rails.application.initialize!

WeDeliver::Application.configure do
  config.action_mailer.delivery_method = :smtp
  config.action_mailer.smtp_settings = {
    address:  "smtp.gmail.com",
    user_name: "flamingomedia.dk@gmail.com",
    password:  "jQ0*reQ9OHUIvEb5#r#*", #todo!!
    port:     587,
    domain:   "wedeliver.dk",
    authentication: "plain",
    enable_starttls_auto: true
  }
end
