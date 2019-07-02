class MessagesCountWorker
  include Sidekiq::Worker

  def perform(chat_id)
    @chat = Chat.find(chat_id)

    count_messages = Message.where('chat' => @chat).count()
    @chat.update_column('messagesCount', count_messages)
  end
end
