class Recipe < ApplicationRecord
  validates :name, presence: true
  attribute :public, default: true

  belongs_to :user
  has_many :recipe_foods, dependent: :destroy
end
