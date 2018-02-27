module ApplicationCable
  class Connection < ActionCable::Connection::Base
    identified_by :current_user

    def connect
      self.current_user = find_verified_user
    end

    def disconnect

    end

    protected

    def find_current_user
      # if user_signed_in? 
      #   current_user
      # else
      #   reject_unauthorized_connection
      # end
    end

    def find_verified_user # this checks whether a user is authenticated with devise
      verified_user = env['warden'].user
      if verified_user
        verified_user
      else
        reject_unauthorized_connection
      end
    end

  end
end
