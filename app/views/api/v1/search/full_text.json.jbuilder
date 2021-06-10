json.hits do
  json.merge! @hit_records
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
