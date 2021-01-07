class AddDeleteToMicroposts < ActiveRecord::Migration[5.2]
  def change
    add_column :microposts, :delete_frag, :integer
  end
end
