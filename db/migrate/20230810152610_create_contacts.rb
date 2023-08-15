class CreateContacts < ActiveRecord::Migration[7.0]
  def change
    unless table_exists?(:contacts)
      create_table :contacts do |t|
        t.string :first_name
        t.string :last_name
        t.string :email
        t.string :phone_number

        t.timestamps
      end
    end
  end
end