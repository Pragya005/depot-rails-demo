module ApplicationCable
  class Connection < ActionCable::Connection::Base
    identified_by :current_session

    def connect
      self.current_session = find_session  # may be nil for anonymous visitors
    end

    private
      def find_session
        if (session_id = cookies.signed[:session_id])
          Session.find_by(id: session_id)
        end
      end
  end
end
