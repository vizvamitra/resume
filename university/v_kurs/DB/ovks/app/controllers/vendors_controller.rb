class VendorsController < ApplicationController
  before_action :set_vendor, only: [:edit, :update, :destroy]

  # GET /vendors
  def index
    @vendors = Vendor.all
  end

  # GET /vendors/new
  def new
    @vendor = Vendor.new
  end

  # GET /vendors/1/edit
  def edit
  end

  # POST /vendors
  def create
    @vendor = Vendor.new(vendor_params)

    respond_to do |format|
      if @vendor.save
        format.html { redirect_to vendors_url, notice: 'Поставщик успешно добавлен.' }
      else
        format.html { render action: 'new' }
      end
    end
  end

  # PATCH/PUT /vendors/1
  def update
    respond_to do |format|
      if @vendor.update(vendor_params)
        format.html { redirect_to vendors_url, notice: 'Поставщик успешно изменён.' }
      else
        format.html { render action: 'edit' }
      end
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_vendor
      @vendor = Vendor.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def vendor_params
      params.require(:vendor).permit(:title, :address, :phone, :note)
    end
end
