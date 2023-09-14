class AddAttributesToTweets < ActiveRecord::Migration[6.1]
  def change
    add_column :tweets, :message, :string
    add_belongs_to :tweets, :user, index: true
    add_column :tweets, :timestamps, :datetime
  end
end
