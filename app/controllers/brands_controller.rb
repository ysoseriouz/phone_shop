# frozen_string_literal: true

# Controller for Brands views
class BrandsController < ApplicationController
  before_action :authenticate_account!
  before_action :authorize_account?, except: [:index]
  before_action :set_brand, only: %i[update destroy]

  def index
    @brands = Brand.order(:name)
  end

  def create # rubocop:disable Metrics/AbcSize
    @brand = Brand.new(name: params[:name])

    respond_to do |format|
      if @brand.save
        format.html { redirect_to brands_path, notice: 'New brand created successfully.' }
        format.json { render json: @brand, status: :ok }
      else
        format.html { redirect_to brands_path, alert: @brand.errors.full_messages }
        format.json { render json: @brand.errors, status: :unprocessable_entity }
      end
    end
  end

  def update # rubocop:disable Metrics/AbcSize
    respond_to do |format|
      if @brand.update(name: params[:new_name])
        format.html { redirect_to brands_path, notice: 'Brand name updated successfully.' }
        format.json { render json: @brand, status: :ok }
      else
        format.html { redirect_to brands_path, alert: @brand.errors.full_messages }
        format.json { render json: @brand.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    respond_to do |format|
      if @brand.destroy
        format.html { redirect_to brands_path, notice: 'Brand deleted successfully.' }
        format.json { render json: {}, status: :ok }
      else
        format.html { redirect_to brands_path, alert: @brand.errors.full_messages }
        format.json { render json: @brand.errors, status: :unprocessable_entity }
      end
    end
  end

  private

  def authorize_account?
    redirect_to brands_path, alert: 'You are not authorized.' unless current_account.manager?
  end

  def set_brand
    @brand = Brand.find(params[:id])
  end
end
