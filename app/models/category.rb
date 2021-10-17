# frozen_string_literal: true

# == Schema Information
#
# Table name: categories
#
#  id         :bigint           not null, primary key
#  name       :string           not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
# Indexes
#
#  index_categories_on_name  (name) UNIQUE
#
class Category < ApplicationRecord
  has_many :posts, dependent: :destroy
  before_save :downcase_name

  validates :name, presence: true, uniqueness: true, length: { minimum: 2 }

  private

  def downcase_name
    self.name = name.downcase
  end
end
