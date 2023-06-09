class Food < ApplicationRecord
  validates :name, presence: true
  validates :quantity, presence: true, numericality: { only_integer: true, greater_than_or_equal_to: 1 }
  validates :price, presence: true, numericality: { only_integer: true, greater_than_or_equal_to: 1 }
  validates :measurement_unit, presence: true

  attribute :quantity, default: 1

  belongs_to :user
  has_many :recipe_foods, dependent: :destroy
end
