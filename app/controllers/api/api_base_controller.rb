module API
  module Errors
    class InvalidRequest < StandardError
    end
  end

  class APIBaseController < ActionController::API
  end
end
