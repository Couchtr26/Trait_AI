class User < ApplicationRecord
  has_secure_password
  has_many :messages
  has_many :user_memories

  def on_cooldown?
    cooldown_until.present? && cooldown_until > Time.current
  end

  def start_cooldown!(minutes)
    update!(cooldown_until: minutes.minutes.from_now)
  end
end
