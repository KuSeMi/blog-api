# frozen_string_literal: true

class CommentBlueprint < Blueprinter::Base
  identifier :id

  view :normal do
    field :body
  end
end
