class AddDetailsToUsers < ActiveRecord::Migration[5.2]
  def change
    add_column :users, :content2, :string
    add_column :users, :content3, :string
    add_column :users, :content4, :string
    add_column :users, :address, :string
    add_column :users, :sex, :integer
  end
end
