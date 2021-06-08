class Child < ApplicationRecord
  include FullTextSearchable
  attr_indexer :name

  belongs_to :parent
  
  validates :name, presence: true
end
