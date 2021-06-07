class ChildSerializer
  include JSONAPI::Serializer
  attributes :id, :name
end
