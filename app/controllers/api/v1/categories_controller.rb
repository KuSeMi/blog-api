# frozen_string_literal: true

module Api
  module V1
    class CategoriesController < ApplicationController
      before_action :logged_in?, except: %i[index show]
      before_action :set_category, only: %i[show update destroy]

      def index
        @categories = Category.all
        render json: @categories
      end

      def show
        render json: @category
      end

      def create
        return unless logged_in?

        @category = Category.new(category_params)

        if @category.save
          render json: @category, status: :created
        else
          render json: @category.errors, status: :unprocessable_entity
        end
      end

      def update
        if logged_in? && @category.update(category_params)
          render json: @category, status: :ok
        else
          render json: @category.errors, status: :unprocessable_entity
        end
      end

      def destroy
        if logged_in?
          @category.destroy
          head :no_content
        else
          render json: { message: 'Access denied!' }, status: :unprocessable_entity
        end
      end

      private

      def set_category
        @category ||= Category.find(params[:id])
      end

      def category_params
        params.require(:category).permit(:name)
      end
    end
  end
end
