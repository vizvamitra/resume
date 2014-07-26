class BillPositionsController < ApplicationController
  before_action :set_bill
  before_action :set_bp, only: [:edit, :update, :destroy]

  def create
    bill_pos = BillPosition.new(bill_pos_params)
    @bill.bill_positions << bill_pos
    bill_pos.save
    respond_to do |format|
      format.js { @bill_pos = bill_pos } 
      format.html { redirect_to @bill }
    end
  end

  def edit
    @types = Type.all

    @sz_or_nz = @bp.sz_or_nz ? :sz_id : :nz_id
    @selected = @bp.reason

    if @bp.sz_or_nz.nil?
      @szs_nzs = []
    else
      @szs_nzs = @bp.sz_or_nz ? Sz.not_done : Nz.not_done
    end
  end

  def update
    if @bp.update(bill_pos_params)
      redirect_to @bill
    else
      render action: 'edit'
    end
  end

  def destroy
    @bp.delete
    redirect_to @bill
  end

  private

  def set_bill
    @bill = Bill.find(params[:bill_id])
  end

  def set_bp
    @bp = BillPosition.find(params[:id])
  end

  def bill_pos_params
    params.require(:bill_position).permit(:type_id, :model, :count, :sn, :sz_or_nz, :sz_id, :nz_id)
  end
end
