# frozen_string_literal: true

# Controller for Models views
class ModelsController < ApplicationController
  before_action :authenticate_account!
  before_action :authorize_account?
  before_action :set_model, only: %i[update destroy]

  def create
    @model = Model.new(name: params[:name], brand_id: params[:brand_id])
    if @model.save
      redirect_to brands_path, notice: 'New model created successfully.'
    else
      redirect_to brands_path, alert: @model.errors.full_messages
    end
  end

  def update
    if @model.update(name: params[:new_name])
      redirect_to brands_path, notice: 'Model name updated successfully.'
    else
      redirect_to brands_path, alert: @model.errors.full_messages
    end
  end

  def destroy
    if @model.destroy
      redirect_to brands_path, notice: 'Model deleted successfully.'
    else
      redirect_to brands_path, alert: @model.errors.full_messages
    end
  end

  private

  def authorize_account?
    redirect_to brands_path, alert: 'You are not authorized.' unless current_account.manager?
  end

  def set_model
    @model = Model.find(params[:id])
  end
end
