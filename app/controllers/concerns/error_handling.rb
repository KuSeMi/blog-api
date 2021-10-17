# frozen_string_literal: true

module ErrorHandling
  extend ActiveSupport::Concern

  included do
    rescue_from ActiveRecord::RecordNotFound, with: :render_not_found
    rescue_from ActionController::ParameterMissing, with: :render_parameter_missing
    rescue_from ActiveRecord::RecordNotUnique, with: :render_not_unique

    private

    def render_not_found(exception)
      render json: { error: exception.message }, status: :not_found
    end

    def render_parameter_missing(exception)
      render json: { error: exception.message }, status: :expectation_failed
    end

    def render_not_unique(exception)
      render json: { error: exception.message }, status: :expectation_failed
    end
  end
end
