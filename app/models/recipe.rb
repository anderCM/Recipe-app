class Recipe < ApplicationRecord
  validates :name, presence: true 
  attribute :public, default: true
  
  belongs_to :users
  has_many :recipe_foods, dependent: :destroy
end
