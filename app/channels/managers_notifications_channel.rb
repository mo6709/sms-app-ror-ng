class ManagersNotificationsChannle < ApplicationCable::Channel
    def subscrib
        start_from "manager notifications_"
    end
end