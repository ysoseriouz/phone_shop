class BrandModelsController < ApplicationController

  def index
    @brands = Brand.all
  end

  def create_brand
    @brand = Brand.new(name: params[:name])
    if @brand.save
      redirect_to brand_models_index_path, notice: "New brand created successfully"
    else
      redirect_to brand_models_index_path, alert: @brand.errors.full_messages
    end
  end

  def create_model
    @model = Model.new(name: params[:name], brand_id: params[:brand_id])
    if @model.save
      redirect_to brand_models_index_path, notice: "New model created successfully"
    else
      redirect_to brand_models_index_path, alert: @model.errors.full_messages
    end
  end

  def update_brand
    @brand = Brand.find(params[:id])
    if @brand.update(name: params[:new_name])
      redirect_to brand_models_index_path , notice: "Brand name updated successfully"
    else
      redirect_to brand_models_index_path, alert: @brand.errors.full_messages
    end
  end

  def update_model
    @model = Model.find(params[:id])
    if @model.update(name: params[:new_name])
      redirect_to brand_models_index_path, notice: "Model name updated successfully"
    else
      redirect_to brand_models_index_path, alert: @model.errors.full_messages
    end
  end

  def destroy_brand
    @brand = Brand.find(params[:id])
    if @brand.destroy
      redirect_to brand_models_index_path, notice: "Model name updated successfully"
    else
      redirect_to brand_models_index_path, alert: @brand.errors.full_messages
    end
  end

  def destroy_model
    @model = Model.find(params[:id])
    if @model.destroy
      redirect_to brand_models_index_path, notice: "Model deleted successfully"
    else
      redirect_to brand_models_index_path, alert: @model.errors.full_messages
    end
  end
end
