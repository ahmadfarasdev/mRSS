class AddLogoToSetting < ActiveRecord::Migration[5.0]
  def change
    add_column :settings, :logo, :string
  end
end
