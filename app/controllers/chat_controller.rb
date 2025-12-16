class ChatController < ApplicationController
  before_action :require_login

  def index
    @messages = current_user.messages.order(:created_at)
  end

  def send_message
    @message = current_user.messages.create!(body: params[:body])
    ai_reply = AiEngine.process(user: current_user, message: @message)

    @message.update!(ai_response: ai_reply)

    redirect_to chat_path
  end
end
