class CreateChildren < ActiveRecord::Migration[6.1]
  def change
    create_table :children do |t|
      t.string :name

      t.timestamps
      t.integer :lock_version
      
      t.belongs_to :parent
    end
  end
end
