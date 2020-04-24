# frozen_string_literal: true

module Error
  # error handler module
  module ErrorHandler
    def self.included(clazz)
      clazz.class_eval do
        rescue_from ActiveRecord::RecordInvalid do |e|
          respond(422, e.record.errors)
        end
        rescue_from ActiveRecord::RecordNotFound do |e|
          respond(:not_found, e.to_s)
        end
      end
    end

    private

    def respond(status, messages)
      json = Helpers::Render.json(messages)
      render json: json, status: status
    end
  end
end