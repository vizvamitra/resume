class BillsController < ApplicationController

  before_action :set_bill, only: [:show, :edit, :update]

  def index
    @sort = Hash.new('')
    order = params[:order] || 'ovks_num'
    @sort[order] = 'sorted_by'

    @bills = Bill.order(order.to_sym).load

    @hide_empty = true if params[:filter]
    @filter = {}
    
    @bps = {}
    BillPosition.filter(params[:filter]).load.each do |bp|
      @bps[bp.bill_id] ||= { bps: [], size: 0 }
      @bps[bp.bill_id][:bps] << bp
      @bps[bp.bill_id][:size] += 1
    end
  end

  def show
    @bill_pos = BillPosition.new
    @types = Type.all
  end

  def new
    @bill = Bill.new
    @vendors = Vendor.all
  end

  def edit
    @vendors = Vendor.all
  end

  def create
    @bill = Bill.new(bill_params)

    if @bill.save
      redirect_to @bill
    else
      @vendors = Vendor.all
      render 'new'
    end
  end

  def update
    pars = bill_params
    @bill.skan = pars.delete(:skan) if pars[:skan]
    if @bill.update(pars)
      redirect_to bills_url
    else
      render action: 'edit'
    end
  end

  private

  def bill_params
    params.require(:bill).permit(:ovks_num, :bill_num, :bill_date, :vendor_id, :total_sum, :payment_date, :closing_date, :skan, :closing_skan)
  end

  def set_bill
    @bill = Bill.find(params[:id])
  end

end
