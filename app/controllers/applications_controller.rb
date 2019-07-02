class ApplicationsController < ApplicationController
  before_action :set_application, only: [:show, :update, :destroy]

  # GET /applications
  def index
    @applications = Application.all

    render json: @applications
  end

  # GET /applications/1
  def show
    render json: @application
  end

  # GET /applications/1
  def chats
    application = Application.find_by(token: params[:id])
    if (application)
      render json: application.chats
    else
      render json: {errors: 'ERROR: Invalid application token'}, status: :unprocessable_entity
    end
  end

  def chatMessages
    application = Application.find_by(token: params[:id])
    if (application)
      chat = Chat.find_by(application: application, number: params[:chat_number])
      if (chat)
        render json: chat.messages
      else
        render json: {errors: 'Error: Invalid chat number or application token'}, status: :unprocessable_entity
      end
    else
      render json: {errors: 'Error: Invalid application token'}, status: :unprocessable_entity
    end 
  end

  # POST /applications
  def create
    @application = Application.new(application_params)

    if @application.save
      render json: @application, status: :created, location: @application
    else
      render json: @application.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /applications/1
  def update
    if @application.update(application_params)
      render json: @application
    else
      render json: @application.errors, status: :unprocessable_entity
    end
  end

  # DELETE /applications/1
  def destroy
    @application.destroy
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_application
      @application = Application.find(params[:id])
    end

    # Only allow a trusted parameter "white list" through.
    def application_params
      params.require(:application).permit(:name)
    end
end
