class InventoriesController < ApplicationController
  before_action :set_inventory, only: [:edit, :update, :destroy]
  before_action :authenticate_account!, except: [:index]

  def index
    @inventories = Inventory.includes(:model).search(search_params).order(:id).page(params[:page])
  end

  def new
    @inventory = Inventory.new
  end

  def create
    @inventory = Inventory.new(inventory_params)
    
    if @inventory.save
      redirect_to edit_inventory_path(@inventory)
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit
  end

  def update
    if @inventory.update(inventory_params)
      redirect_to edit_inventory_path(@inventory)
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @inventory.destroy
    redirect_to inventories_path
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
