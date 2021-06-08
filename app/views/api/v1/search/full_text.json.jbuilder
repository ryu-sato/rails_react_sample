json.hits do
  json.array! @hit_records do |record|
    json.merge! record.attributes
  end
end
json.highlights do
  json.array! @highlights do |highlight|
    json.array! highlight do |highlights|
      json.set! highlights[0] do
        json.merge! highlights[1]
      end
    end
  end
end
