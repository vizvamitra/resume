class SzsController < ApplicationController
  before_action :set_sz, only: [:show, :edit, :update]

  def index
    @szs = Sz.all.includes(:sz_type, :user)
  end

  def new
    @sz = Sz.new
    @users = User.all.select(:id, :fio)
    @sz_types = SzType.all
    @employees = Employee.all
  end

  def show
    @types = Type.all
  end

  def edit
    @users = User.all.select(:id, :fio)
    @sz_types = SzType.all
    @employees = Employee.all
  end

  def create
    @sz = Sz.new(sz_params)
    if @sz.save
      redirect_to @sz
    else
      @sz_types = SzType.all
      @employees = Employee.all
      render 'new'
    end
  end

  def update
    pars = sz_params
    @sz.scan = pars.delete(:scan) if pars[:scan]
    if @sz.update(pars)
      redirect_to szs_url
    else
      @sz_types = SzType.all
      @employees = Employee.all
      @users = User.all.select(:id, :fio)
      render action: 'edit'
    end
  end

  def not_done
    render json: Sz.not_done
  end

  private

  def set_sz
    @sz = Sz.find(params[:id])
  end

  def sz_params
    params.require(:sz).permit(:ovks_num, :date, :sz_type_id, :employee_id, :user_id, :note, :scan, :done)
  end
end
