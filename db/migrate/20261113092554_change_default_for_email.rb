# This is an example of irreversible migration.
class ChangeDefaultForEmail < ActiveRecord::Migration[8.1]
  def change
    change_column_default :orders, :email, "support@gmail.com"
  end
end

# To make this reversible
# class ChangeDefaultForEmail < ActiveRecord::Migration[8.1]
#   def change
#     change_column_default :orders, :email, from: nil, to: "support@gmail.com"
#   end
# end

# Or define up and down methods
