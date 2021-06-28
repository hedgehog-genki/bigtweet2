class CreatePosts < ActiveRecord::Migration[6.0]
  def change
    create_table :posts do |t|
      t.text :power
      t.string :picture
      t.string :kind
      t.string :random

      t.timestamps
    end
  end
end
