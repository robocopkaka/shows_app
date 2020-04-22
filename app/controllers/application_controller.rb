class ApplicationController < ActionController::API
  include Response
  include Error::ErrorHandler
end
