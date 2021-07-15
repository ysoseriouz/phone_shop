class BrandModelsController < ApplicationController
  def index
    @brands = Brand.all
  end

  def create_brand
    @brand = Brand.new(name: params[:name])
    if @brand.save
      redirect_to brand_models_index_path
    end
  end

  def create_model
    @model = Model.new(name: params[:name], brand_id: params[:brand_id])
    if @model.save
      redirect_to brand_models_index_path
    end
  end

  def update_brand
    @brand = Brand.find(params[:id])
    if @brand.update(name: params[:new_name])
      redirect_to brand_models_index_path
    end
  end

  def update_model
    @model = Model.find(params[:id])
    if @model.update(name: params[:new_name])
      redirect_to brand_models_index_path
    end
  end

  def destroy_brand
    @brand = Brand.find(params[:id])
    @brand.destroy
    redirect_to brand_models_index_path
  end

  def destroy_model
    @model = Model.find(params[:id])
    @model.destroy
    redirect_to brand_models_index_path
  end
end
