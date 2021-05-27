class TopsController < ApplicationController
  # GET /tops or /tops.json
  def index
    @parents_json = ParentSerializer.new(Parent.all).serializable_hash.to_json
  end
end
