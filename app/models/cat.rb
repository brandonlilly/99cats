# == Schema Information
#
# Table name: cats
#
#  id          :integer          not null, primary key
#  birth_date  :datetime         not null
#  color       :string           not null
#  name        :string           not null
#  sex         :string           not null
#  description :text
#  created_at  :datetime
#  updated_at  :datetime
#  user_id     :integer
#

class Cat < ActiveRecord::Base
  COLORS = %w(yellow brown black red white grey orange)

  validates :name, :color, :birth_date, :sex, presence: true
  validates :color, inclusion: { in: self::COLORS }
  validates :sex, inclusion: { in: ['M', 'F'] }

  has_many :rental_requests,
    foreign_key: :cat_id,
    primary_key: :id,
    class_name:  :CatRentalRequest,
    dependent: :destroy

  belongs_to(
    :owner,
    foreign_key: :user_id,
    class_name: :User
  )

  def age
    Time.now - birth_date
  end
end
