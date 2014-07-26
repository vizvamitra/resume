class ReceiptsController < ApplicationController
  before_action :set_receipt, only: [:show, :edit, :update, :delete]

  def index
    @sort = Hash.new('')
    order = params[:order] || 'ovks_num'
    @sort[order] = 'sorted_by'

    @receipts = Receipt.order(order.to_sym).load
  end

  def new
    @receipt = Receipt.new
    @ids = params[:ids]
    @items = BillPosition.where(id: @ids)
    @users = User.all.select(:id, :fio)
    @employees = Employee.all.select(:id, :fio)
  end

  def show
  end

  def edit
    @ids = @receipt.bill_positions.map(&:id)
    @users = User.all.select(:id, :fio)
    @employees = Employee.all.select(:id, :fio)
  end

  def create
    @receipt = Receipt.new(receipt_params)
    @items = BillPosition.where(id: params[:receipt][:ids])

    if @receipt.save
      @items.each do |item|
        @receipt.bill_positions << item
      end
      redirect_to @receipt
    else
      @ids = params[:receipt][:ids]
      @items = BillPosition.where(id: @ids)
      @users = User.all.select(:id, :fio)
      @employees = Employee.all.select(:id, :fio)
      render 'new'
    end
  end

  def update
    pars = receipt_params
    @receipt.scan = pars.delete(:scan) if pars[:scan]
    if @receipt.update(pars)
      redirect_to receipts_url
    else
      @ids = @receipt.bill_positions.map(&:id)
      @users = User.all.select(:id, :fio)
      @employees = Employee.all.select(:id, :fio)
      render action: 'edit'
    end
  end

  private

  def set_receipt
    @receipt = Receipt.find(params[:id])
  end

  def receipt_params
    params.require(:receipt).permit(:ovks_num, :date, :employee_id, :user_id, :note, :scan)
  end
end
