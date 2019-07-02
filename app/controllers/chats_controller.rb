class ChatsController < ApplicationController
  before_action :set_chat, only: [:show, :update, :destroy]

  # GET /chats
  def index
    @chats = Chat.all

    render json: @chats
  end

  # GET /chats/1
  def show
    render json: @chat
  end

  # POST /chats
  def create
    @application = Application.find_by(token: params[:application_token])

    if (@application)
      @chat = Chat.new(application: @application)
      if @chat.save
        ChatsCountWorker.perform_in(5.minutes, @application.id)
        render json: @chat, status: :created, location: @chat
      else
        render json: @chat.errors, status: :unprocessable_entity
      end
    else
      render json: {errors: 'Error: Invalid application token'}, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /chats/1
  def update
    application = Application.find_by(token: params[:application_token])
    if (application)
      @chat = Chat.find_by(application: application, number: params[:id])
      if @chat.update(chat_params)
        render json: @chat
      else
        render json: @chat.errors, status: :unprocessable_entity
      end
    else
      render json: {errors: 'Error: Invalid application token'}, status: :unprocessable_entity
    end
  end

  # DELETE /chats/1
  def destroy
    @chat.destroy
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_chat
      @chat = Chat.find(params[:id])
    end

    # Only allow a trusted parameter "white list" through.
    def chat_params
      params.require(:chat).permit(:name)
    end
end
