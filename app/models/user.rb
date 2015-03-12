# == Schema Information
#
# Table name: users
#
#  id              :integer          not null, primary key
#  user_name       :string           not null
#  password_digest :string           not null
#  session_token   :string           not null
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#

class User < ActiveRecord::Base
  attr_reader :password

  validates :user_name, presence: true
  validates :password_digest, presence: { message: "Password can't be blank" }
  validates :password, length: { minimum: 6, allow_nil: true }

  has_many :cats
  has_many :requests, dependent: :destroy
  has_many :sessions, dependent: :destroy

  def self.find_by_credentials(user_name, password)
    user = User.find_by_user_name(user_name)
    return nil if user.nil?
    user.is_password?(password) ? user : nil
  end

  def self.find_by_session_token(token)
    User.find_by_sql([<<-SQL, token])
      SELECT
        users.*
      FROM
        users
      JOIN
        sessions ON users.id = sessions.user_id
      WHERE
        sessions.token = ?
    SQL
  end

  def password=(password)
    @password = password
    self.password_digest = BCrypt::Password.create(password)
  end

  def is_password?(password)
    BCrypt::Password.new(self.password_digest).is_password?(password)
  end

end
