# frozen_string_literal: true

# Controller for Inventories views
class InventoriesController < ApplicationController
  before_action :set_inventory, only: %i[edit update destroy]
  before_action :authenticate_account!, except: [:index]

  def index
    inventories = Inventory.includes(:model).search(search_params).order(:id)
    @num_records = inventories.count
    @inventories = inventories.page(params[:page])
  end

  def new
    @inventory = Inventory.new
  end

  def create
    @inventory = Inventory.new(inventory_params)

    respond_to do |format|
      if @inventory.save
        format.html { redirect_to edit_inventory_path(@inventory), notice: 'New inventory created successfully.' }
        format.json { render :edit, status: :ok, location: @inventory }
      else
        format.html { render :new, alert: @inventory.errors.full_messages, status: :unprocessable_entity }
        format.json { render json: @inventory.errors, status: :unprocessable_entity }
      end
    end
  end

  def edit; end

  def update
    respond_to do |format|
      if @inventory.update(inventory_params)
        format.html { redirect_to edit_inventory_path(@inventory), notice: 'New inventory updated successfully.' }
        format.json { render :edit, status: :ok, location: @inventory }
      else
        format.html { render :edit, alert: @inventory.errors.full_messages, status: :unprocessable_entity }
        format.json { render json: @inventory.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    respond_to do |format|
      if @inventory.destroy
        format.html { redirect_to inventories_path, notice: 'Inventory deleted successfully.' }
        format.json { render json: {}, status: :ok }
      else
        format.html { render :index, alert: @inventory.errors.full_messages, status: :unprocessable_entity }
        format.json { render json: @inventory.errors, status: :unprocessable_entity }
      end
    end
  end

  private

  def set_inventory
    @inventory = Inventory.find(params[:id])
  end

  def inventory_params
    params.require(:inventory).permit(
      :model_id, :memory_size, :manufactoring_year,
      :os_version, :color, :price, :original_price,
      :source, :status, :description, images: []
    )
  end

  def search_params
    params.permit(
      :id, :brand_id, :model_id, :memory_size, :manufactoring_year_lower,
      :manufactoring_year_upper, :price, :os_version, :color, :status
    )
  end
end
