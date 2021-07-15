class ModelsController < ApplicationController
  before_action :authenticate_account!
  before_action :authorize_account?

  def create
    @model = Model.new(name: params[:name], brand_id: params[:brand_id])
    if @model.save
      redirect_to brands_path, notice: "New model created successfully."
    else
      redirect_to brands_path, alert: @model.errors.full_messages
    end
  end

  def update
    @model = Model.find(params[:id])
    if @model.update(name: params[:new_name])
      redirect_to brands_path, notice: "Model name updated successfully."
    else
      redirect_to brands_path, alert: @model.errors.full_messages
    end
  end

  def destroy
    @model = Model.find(params[:id])
    if @model.destroy
      redirect_to brands_path, notice: "Model deleted successfully."
    else
      redirect_to brands_path, alert: @model.errors.full_messages
    end
  end

  private

  def authorize_account?
    unless current_account.manager?
      redirect_to brands_path, alert: "You are not authorized."
    end
  end
end
