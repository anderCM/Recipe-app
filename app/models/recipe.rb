class Recipe < ApplicationRecord
  validates :name, presence: true
  attribute :public, default: false

  belongs_to :user
  has_many :recipe_foods, dependent: :destroy
end
