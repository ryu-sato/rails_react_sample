class Child < ApplicationRecord
  belongs_to :parent
  
  validates :name, presence: true
end
