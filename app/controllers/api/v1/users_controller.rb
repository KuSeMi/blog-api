# frozen_string_literal: true

module Api
  module V1
    class UsersController < ApplicationController
      before_action :set_user, only: %i[show update destroy]
      before_action :authorize_user, except: %i[create show]

      def index
        @users = User.all
        if @users
          render json: { users: @users, status: :ok }
        else
          render json: @user.errors, status: :unprocessable_entity
        end
      end

      def show
        if @user
          render json: { user: @user, status: :ok }
        else
          render json: @user.errors, status: :unprocessable_entity
        end
      end

      def create
        @user = User.new(user_params)

        if @user.save
          session[:user_id] = @user.id
          render json: { user: @user, status: :created }
        else
          render json: @user.errors, status: :unprocessable_entity
        end
      end

      def update
        if is_account_owner? && @user.update(user_params)
          render json: { user: @user, status: :upradetd }
        else
          render json: @user.errors, status: :unprocessable_entity
        end
      end

      def destroy
        return unless is_account_owner?

        User.find(current_user.id).destroy
        render(nothing: true, status: :ok)
      end

      private

      def authorize_user
        require_user unless @user == current_user
      end

      def set_user
        @user ||= User.find(params[:id])
      end

      def user_params
        params.require(:user).permit(:name, :email, :password, :password_confirmation)
      end
    end
  end
end
