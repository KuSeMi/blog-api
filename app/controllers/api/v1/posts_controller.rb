# frozen_string_literal: true

module Api
  module V1
    class PostsController < ApplicationController
      before_action :logged_in?, except: %i[index show]
      before_action :set_post, only: %i[show update destroy]
      before_action :set_authorhip, only: %i[authorship]
      before_action :set_category, only: %i[create update destroy category]

      def index
        @posts = Post.order(created_at: :desc)
        render_with_truncate(@posts)
      end

      def create
        @post = current_user.posts.build post_params
        @post[:category_id] = @category.id

        if @post.save
          render json: PostBlueprint.render(@post, view: :normal), status: :ok
        else
          render json: @post.errors, status: :unprocessable_entity
        end
      end

      def show
        render json: PostBlueprint.render(@post, view: :normal), status: :ok
      end

      def update
        if is_post_owner?
          if @post.update(post_params)
            render json: PostBlueprint.render(@post), status: :ok
          else
            render json: @post.errors, status: :unprocessable_entity
          end
        else
          render json: { message: 'Access denied!' }, status: :unprocessable_entity
        end
      end

      def destroy
        if is_post_owner?
          @post.destroy
          render json: { message: 'Post deleted!' }, status: :ok
        else
          render json: { message: 'Access denied!' }, status: :unprocessable_entity
        end
      end

      def authorship
        if logged_in?
          render_posts(@authorship)
        else
          render json: { message: 'Access denied!' }, status: :unprocessable_entity
        end
      end

      def category
        @by_category = Post.where(category_id: @category).order(created_at: :desc)
        render_with_truncate(@by_category)
      end

      private

      def post_params
        params.require(:post).permit(:title, :body)
      end

      def set_post
        @post ||= Post.find(params[:id])
      end

      def set_category
        @category ||= Category.find(params[:category_id])
      end

      def set_authorhip
        @authorship ||= Post.where(user_id: params[:id]).order(created_at: :desc)
      end

      def render_with_truncate(obj)
        render json: PostBlueprint
                       .render(obj,
                               omission: '...',
                               do_truncate: true,
                               view: :extended), status: :ok
      end
    end
  end
end
