# frozen_string_literal: true

module Api
  module V1
    class CommentsController < ApplicationController
      before_action :set_post, only: %i[index create]
      before_action :set_comment, only: %i[show update destroy]
      before_action :logged_in?, except: %i[index show]

      def index
        @comments = @post.comments.order(created_at: :desc)
        render json: @comments, status: :ok
      end

      def show
        render json: @comment
      end

      def create
        @comment = @post.comments.build(comment_create_params)

        if @comment.save
          render json: @comment, status: :created
        else
          render json: @comment.errors, status: :unprocessable_entity
        end
      end

      def update
        if is_comment_owner?
          if @comment.update(comment_update_params)
            render json: @comment, status: :ok
          else
            render json: @comment.errors, status: :unprocessable_entity
          end
        else
          render json: { message: 'Access denied!' }, status: :unprocessable_entity
        end
      end

      def destroy
        if is_comment_owner?
          @comment.destroy
          head :no_content
        else
          render json: { message: 'Access denied!' }, status: :unprocessable_entity
        end
      end

      private

      def comment_create_params
        params.require(:comment).permit(:body).merge(user: current_user)
      end

      def comment_update_params
        params.require(:comment).permit(:body)
      end

      def set_post
        @post ||= Post.find(params[:post_id])
      end

      def set_comment
        @comment ||= Comment.find(params[:id])
      end
    end
  end
end
