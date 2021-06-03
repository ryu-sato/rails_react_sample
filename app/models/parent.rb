class Parent < ApplicationRecord
  include Searchable
  attr_indexer :name, :age
end
