class Parent < ApplicationRecord
  include FullTextSearchable
  attr_indexer :name, :email
  
  has_many :children
  
  validates :name, presence: true
end
