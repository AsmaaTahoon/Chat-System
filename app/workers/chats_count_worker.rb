class ChatsCountWorker
  include Sidekiq::Worker

  def perform(application_id)
    @application = Application.find(application_id)

    count_chats = Chat.where('application' => @application).count()
    @application.update_column('chatsCount', count_chats)
  end
end
