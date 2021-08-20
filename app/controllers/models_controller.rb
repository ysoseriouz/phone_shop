# frozen_string_literal: true

# Controller for Models views
class ModelsController < ApplicationController
  before_action :authenticate_account!
  before_action :authorize_account?
  before_action :set_model, only: %i[update destroy]

  def create # rubocop:disable Metrics/AbcSize
    @model = Model.new(name: params[:name], brand_id: params[:brand_id])

    respond_to do |format|
      if @model.save
        format.html { redirect_to brands_path, notice: 'New model created successfully.' }
        format.json { render json: @model, status: :ok }
      else
        format.html { redirect_to brands_path, alert: @model.errors.full_messages }
        format.json { render json: @model.errors, status: :unprocessable_entity }
      end
    end
  end

  def update # rubocop:disable Metrics/AbcSize
    respond_to do |format|
      if @model.update(name: params[:new_name])
        format.html { redirect_to brands_path, notice: 'Model name updated successfully.' }
        format.json { render json: @model, status: :ok }
      else
        format.html { redirect_to brands_path, alert: @model.errors.full_messages }
        format.json { render json: @model.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    respond_to do |format|
      if @model.destroy
        format.html { redirect_to brands_path, notice: 'Model deleted successfully.' }
        format.json { render json: {}, status: :ok }
      else
        format.html { redirect_to brands_path, alert: @model.errors.full_messages }
        format.json { render json: @model.errors, status: :unprocessable_entity }
      end
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
