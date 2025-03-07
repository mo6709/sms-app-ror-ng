module Api
  module V1
    class DeviseController < ApplicationController
      skip_before_action :authenticate_user!
    end
  end
end 