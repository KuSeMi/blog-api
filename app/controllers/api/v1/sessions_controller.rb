# frozen_string_literal: true

module Api
  module V1
    class SessionsController < ApplicationController
      def create
        @user = User.find_by(email: params[:email].downcase)

        if @user && @user&.authenticate(params[:password])
          login!
          render json: { status: :ok, user: @user }
        else
          render json: {
            status: :unprocessable_entity,
            errors: ['no such user, please try again']
          }
        end
      end

      def destroy
        logout!
        render json: { status: :ok }
      end

      def login!
        session[:user_id] = @user.id
      end

      def logout!
        session.clear
      end
    end
  end
end
