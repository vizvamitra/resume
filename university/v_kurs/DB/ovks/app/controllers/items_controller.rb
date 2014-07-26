class ItemsController < ApplicationController
  before_action :set_sz_nz, only: [:create]
  before_action :set_item, only: [:edit, :update, :destroy]

  def create
    items = create_items
    items.each do |item|
      @sz_nz.items << item
      item.save
    end
    respond_to do |format|
      format.js { @items = items } 
      format.html { redirect_to @sz_nz }
    end
  end

  def edit
    @types = Type.all
  end

  def update
    if @item.update(item_params)
      redirect_to @item.owner
    else
      @types = Type.all
      render action: 'edit'
    end
  end

  def destroy
    @item.destroy
    redirect_to @item.owner
  end

  private

  def set_sz_nz
    @sz_nz = if params[:sz]
        Sz.find(params[:sz])
      elsif params[:nz]
        Nz.find(params[:nz])
      else
        redirect_to bills_path
      end
  end

  def create_items
    count = params[:count].empty? ? 1 : params[:count].to_i
    pars = item_params
    items = []
    count.times do
      items << Item.new(pars)
    end
    items
  end

  def set_item
    @item = Item.find(params[:id])
  end

  def item_params
    params.require(:item).permit(:type_id, :name, :info, :done, :done_info)
  end
end
