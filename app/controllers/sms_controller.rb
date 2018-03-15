class SmsController < ApplicationController
  # rescue_from StandardError do |exception|
  #   trigger_sms_alerts(exception)
  # end

  # def trigger_sms_alerts(e)
  #   @alert_message = "
  #     [This is a test] ALERT!
  #     It appears the server is having issues.
  #     Exception: #{e}."

  #     @admin_list = YAML.load_file('config/administrators.yml')
  #     @admin_list.each do |admin|
  #       begin
  #         phone_number = admin['phone_number']
  #         send_message(phone_number, @alert_message)
  #         flash[:success] = 'Exception: #{e}. Administrators will be notified.'
  #       rescue
  #         flash[:alert] = 'Something went wrong.'
  #       end
  #   end

  #   redirect_to root_path
  # end

  # def server_error
  #   raise 'A test exception'
  # end

  def send_message(phone_number, alert_message)
    # render plain: ENV['TWILIO_ACCOUNT_SID'].inspect
    @twilio_number = "4153600414"
    @client = Twilio::REST::Client.new Rails.configuration.account_sid, Rails.configuration.auth_token
    # @client = Twilio::REST::Client.new ENV['TWILIO_ACCOUNT_SID'], ENV['TWILIO_AUTH_TOKEN']

    message = @client.api.account.messages.create(
      :from => @twilio_number,
      :to => "4520131262",
      :body => alert_message,
    )

    redirect_to sms_new_path, flash: {notice: "Beskeden blev sendt"}
  end

  def create
    if params[:phone_number] && params[:message]
      phone = "+45#{params[:phone_number].strip}"
      send_message(phone, params[:message])
    else
      redirect_to sms_new_path, flash: {error: "Beskeden blev ikke sendt"}
    end
  end

  def new
  end

end
