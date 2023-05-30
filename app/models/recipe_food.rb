class RecipeFood < ApplicationRecord
  validates :quantity, presence: true, numericality: { only_integer: true, greater_than_or_equal_to: 1 }

  belongs_to :recipe
  belongs_to :food
end
