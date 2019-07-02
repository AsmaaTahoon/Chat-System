class MessagesController < ApplicationController
  before_action :set_message, only: [:show, :update, :destroy]

  # GET /messages
  def index
    @messages = Message.all

    render json: @messages
  end

  def search
    application = Application.find_by(token: params[:application_token])
    if (application)
      chat = Chat.find_by(application: application, number: params[:chat_number])
      if (chat)
        @messages = params[:q].nil? ? [] : chat.messages.search(params[:q]).records
        render json: @messages
      else
        render json: {errors: 'Error: Invalid chat number or application token'}, status: :unprocessable_entity
      end
    else
      render json: {errors: 'Error: Invalid application token'}, status: :unprocessable_entity
    end

     # @messages = params[:q].nil? ? [] : Message.search(params[:q]).records
     #
     # render json: @messages
  end

  # GET /messages/1
  def show
    render json: @message
  end

  # POST /messages
  def create
    application = Application.find_by(token: params[:application_token]);

    if (!application)
      render json: {errors: 'Error: Invalid application token'}, status: :unprocessable_entity
    else
      chat = Chat.find_by(number: params[:chat_number], application: application)

      if (!chat)
        render json: {errors: 'Error: Invalid chat number or application token'}, status: :unprocessable_entity
      else
        @message = Message.new(chat: chat, body: params[:body])

        if @message.save
          MessagesCountWorker.perform_in(15.minutes, chat.id)
          render json: @message, status: :created, location: @message
        else
          render json: @message.errors, status: :unprocessable_entity
        end

      end
    end
  end

  # PATCH/PUT /messages/1
  def update
    if @message.update(message_params)
      render json: @message
    else
      render json: @message.errors, status: :unprocessable_entity
    end
  end

  # DELETE /messages/1
  def destroy
    @message.destroy
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_message
      @message = Message.find(params[:id])
    end

    # Only allow a trusted parameter "white list" through.
    def message_params
      params.require(:message).permit(:number, :body, :chat_id)
    end
end
