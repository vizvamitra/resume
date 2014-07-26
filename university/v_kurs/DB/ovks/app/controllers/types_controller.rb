class TypesController < ApplicationController
  before_action :set_type, only: [:show, :edit, :update, :destroy]

  # GET /types
  # GET /types.json
  def index
    @types = Type.all
  end

  # GET /types/1
  # GET /types/1.json
  def show
  end

  # GET /types/new
  def new
    @type = Type.new
  end

  # GET /types/1/edit
  def edit
  end

  # POST /types
  def create
    @type = Type.new(type_params)

    if @type.save
      redirect_to types_path
    else
      render action: 'new'
    end
  end

  # PATCH/PUT /types/1
  def update
    if @type.update(type_params)
      redirect_to types_path
    else
      render action: 'edit'
    end
  end

  # DELETE /types/1
  def destroy
    @type.destroy
    redirect_to types_url
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_type
      @type = Type.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def type_params
      params.require(:type).permit(:name)
    end
end
