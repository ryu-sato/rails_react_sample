class Parent < ApplicationRecord
  include FullTextSearchable
  attr_indexer :name, :email
end
