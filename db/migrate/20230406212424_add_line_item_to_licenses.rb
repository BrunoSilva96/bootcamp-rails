class AddLineItemToLicenses < ActiveRecord::Migration[6.0]
  def change
    add_reference :licenses, :line_item, null: false, foreign_key: true
  end
end
