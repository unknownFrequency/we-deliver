module ApplicationCable
  class Connection < ActionCable::Connection::Base
    identified_by :current_user

    def connect
      self.current_user = find_verified_user
      logger.add_tags "ActionCable", "User #{current_user.id}, +45 #{current_user.phone}" if current_user
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
      current_user = env['warden'].user ? current_user : reject_unauthorized_connection
    end

  end
end
