# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

if Parent.count.zero?
  10.times do |n|
    parent = Parent.create!(name: "example_#{n}", age: 30+n, email: "mail_#{n}@example.com")
    10.times do |m|
      Child.create!(name: "example_#{n * 10 + m}", parent: parent)
    end
  end
end
