class BrandModelsController < ApplicationController
  def index
    @brands = Brand.all
    @brand = Brand.new
    @model = Model.new
  end

  def create_model
    @model = Model.new(model_params)
    @model.save

    redirect_to brand_models_index_path
  end

  def create_brand
    @brand = Brand.new(brand_params)
    @brand.save

    redirect_to brand_models_index_path
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

  private

  def model_params
    params.require(:model).permit(:brand_id, :name)
  end

  def brand_params
    params.require(:brand).permit(:name)
  end
end
