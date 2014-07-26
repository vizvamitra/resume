class DepartmentsController < ApplicationController
  before_action :set_department, only: [:show, :edit, :update, :destroy]

  # GET /departments/new
  def new
    @department = Department.new
    @employees = Employee.where(department_id: @department.id)
  end

  # GET /departments/1/edit
  def edit
    @employees = Employee.where(department_id: @department.id)
  end

  # POST /departments
  def create
    @department = Department.new(department_params)
    if @department.save
      redirect_to employees_path
    else
      render action: 'new'
    end
  end

  # PATCH/PUT /departments/1
  def update
    if @department.update(department_params)
      redirect_to employees_path
    else
      @employees = Employee.where(department_id: @department.id)
      render action: 'edit'
    end
  end

  # DELETE /departments/1
  def destroy
    @department.destroy
    redirect_to employees_url
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_department
      @department = Department.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def department_params
      params.require(:department).permit(:title, :employee_id)
    end
end
