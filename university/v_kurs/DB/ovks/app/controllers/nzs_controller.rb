class NzsController < ApplicationController
  before_action :set_nz, only: [:show, :edit, :update]

  def index
    @nzs = Nz.all
  end

  def new
    @employees = Employee.select(:id, :fio)
    @nz = Nz.new
  end

  def show
    @types = Type.all
  end

  def edit
    @employees = Employee.select(:id, :fio)
  end

  def create
    @nz = Nz.new(nz_params)

    if @nz.save
      redirect_to nzs_path
    else
      render 'new'
    end
  end

  def update
    pars = nz_params
    @nz.scan = pars.delete(:scan) if pars[:scan]
    if @nz.update(pars)
      redirect_to nzs_url
    else
      render action: 'edit'
    end
  end

  def not_done
    render json: Nz.not_done
  end

  private

  def set_nz
    @nz = Nz.find(params[:id])
  end

  def nz_params
    params.require(:nz).permit(:ovks_num, :date, :contract_num, :code, :destination, :apk_name, :decimal_num, :zav_num, :buy_till, :manager_id, :sp_si, :given_to_id, :note, :scan)
  end
end
