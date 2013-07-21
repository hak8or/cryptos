class CreateMessages < ActiveRecord::Migration
  def change
    create_table :messages do |t|
      t.string :target
      t.text :body
      t.text :misc
      t.string :from

      t.timestamps
    end
  end
end
