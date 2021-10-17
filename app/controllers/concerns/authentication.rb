# frozen_string_literal: true

module Authentication
  extend ActiveSupport::Concern

  included do
    private

    include AbstractController::Helpers

    helper_method :current_user, :logged_in?

    def current_user
      @current_user ||= User.find(session[:user_id]) if session[:user_id]
    end

    def logged_in?
      !!current_user
    end

    def require_user
      render json: { errors: ['You must be logged in to perform that action.'] } unless logged_in?
    end

    def is_comment_owner?
      @comment.user_id == current_user.id
    end

    def is_post_owner?
      @post.user_id == current_user.id
    end

    def is_account_owner?
      @user.id == current_user.id
    end
  end
end
