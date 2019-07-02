class ChatsCreationWorker
  include Sidekiq::Worker

  def perform(application_id)
    @application = Application.find(application_id)

    @chat = Chat.new(application: @application)
    @chat.save
  end
end
