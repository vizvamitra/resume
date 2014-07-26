class EmployeesController < ApplicationController
  before_action :set_employee, only: [:show, :edit, :update, :destroy]

  # GET /employees
  def index
    @departments = Department.all
  end

  # GET /employees/new
  def new
    @employee = Employee.new
    @departments = Department.all
  end

  # GET /employees/1/edit
  def edit
    @departments = Department.all
  end

  # POST /employees
  def create
    @employee = Employee.new(employee_params)

    if @employee.save
      redirect_to employees_path
    else
      @departments = Department.all
      render action: 'new'
    end
  end

  # PATCH/PUT /employees/1
  def update
    if @employee.update(employee_params)
      redirect_to employees_path
    else
      @departments = Department.all
      render action: 'edit'
    end
  end

  # DELETE /employees/1
  def destroy
    @employee.destroy
    redirect_to employees_url
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_employee
      @employee = Employee.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def employee_params
      params.require(:employee).permit(:fio, :phone, :department_id, :post)
    end
end
