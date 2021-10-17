# frozen_string_literal: true

class PostBlueprint < Blueprinter::Base
  extend ActionView::Helpers::TextHelper

  identifier :id

  fields :title, :user_id, :created_at, :body

  view :normal do
    fields :title, :user_id, :created_at
    association :comments, blueprint: CommentBlueprint, view: :normal
    association :category, blueprint: CategoryBlueprint, view: :normal
  end

  view :extended do
    include_view :normal
    field :body do |post, options|
      if options[:do_truncate]
        truncate post.body, length: 500, omission: options[:omission]
      else
        post.body
      end
    end
  end
end
