class ToursController < ApplicationController
  before_action :set_tour, only: [:show, :edit, :update, :destroy]

  # GET /tours
  # GET /tours.json
  def index
    order_by, order = get_order_params(:tour)
    @order = order == 'desc' ? 'asc' : 'desc'

    @tours = Tour.get_by_group_id(params['group_id'].to_i, order_by, order)
    @group = Group.get_one(params['group_id'].to_i)
  end

  # GET /tours/1
  # GET /tours/1.json
  def show
    order_by, order = get_order_params(:concert)
    @order = order == 'desc' ? 'asc' : 'desc'

    @group = Group.get_one(params['group_id'].to_i)
    @concerts = @tour.get_concerts(order_by, order)
    @concerts.each() do |concert| 
      if @group.top_position && concert['country']
        concert['ticket_price'] = ((0.5+1.0/@group.top_position)*(15000.0/concert['country'].length)).to_i
      end
    end
    if params['order_by'] == 'ticket_price'
      if order == 'asc'
        @concerts.sort!{|a,b| a['ticket_price'] <=> b['ticket_price']}
      else
        @concerts.sort!{|a,b| b['ticket_price'] <=> a['ticket_price']}
      end
    end
  end

  # GET /tours/new
  def new
    @group = Group.get_one(params['group_id'].to_i)
    @tour = Tour.new
    @tour.group_id = @group.id
    @concert = Concert.new
  end

  # GET /tours/1/edit
  def edit
  end

  # POST /tours
  # POST /tours.json
  def create
    @tour = Tour.new(tour_params)
    @concert = Concert.new(concert_params)
    @group = Group.get_one(@tour.group_id)

    if id = @tour.save
      @concert.tour_id = id
      done = @concert.save
      @tour.delete unless done
    else
      done = false
    end

    respond_to do |format|
      if done
        format.html { redirect_to group_tour_path(@tour.group_id, @tour.id), notice: 'Концертный тур успешно добавлен.' }
      else
        format.html { render action: 'new' }
      end
    end
  end

  # PATCH/PUT /tours/1
  # PATCH/PUT /tours/1.json
  def update
    respond_to do |format|
      if @tour.update(tour_params)
        format.html { redirect_to group_tours_path(@tour.group_id), notice: 'Данные концертного тура успешно обновлены.' }
      else
        format.html { render action: 'edit' }
      end
    end
  end

  # DELETE /tours/1
  # DELETE /tours/1.json
  def destroy
    @tour.delete
    respond_to do |format|
      format.html { redirect_to group_tours_path(@tour.group_id) }
    end
  end

private
  # Use callbacks to share common setup or constraints between actions.
  def set_tour
    @tour = Tour.get_one(params[:id].to_i)
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def tour_params
    params.require(:tour).permit(:title, :group_id)
  end

  def concert_params
    pars = params.require(:concert).permit! do |whitelist|
      whitelist['city'] = params['concert']['city']
      whitelist['country'] = params['concert']['country']
      whitelist['date(1i)'] = params['concert']['date(1i)']
      whitelist['date(2i)'] = params['concert']['date(2i)']
      whitelist['date(3i)'] = params['concert']['date(3i)']
    end
    pars['city'] = pars['city'].trim
    pars['country'] = pars['country'].trim
    pars['date(1i)'] = pars['date(1i)'].to_i
    pars['date(2i)'] = pars['date(2i)'].to_i
    pars['date(3i)'] = pars['date(3i)'].to_i

    pars['date'] = 
        pars.delete('date(1i)').to_s + '-' +
        pars.delete('date(2i)').to_s + '-' +
        pars.delete('date(3i)').to_s
    pars
  end

  def get_order_params(type)

  if type == :tour
    order_by = get_tour_order_by
  elsif type = :concert
    order_by = get_concert_order_by
  end

  order = case params['order']
    when 'asc' then 'asc'
    when 'desc' then 'desc'
    else ''
  end
  [order_by, order]
  end

  def get_tour_order_by
    case params['order_by']
      when 'begin_date' then 'begin_date'
      when 'end_date' then 'end_date'
      else 'title'
    end
  end

  def get_concert_order_by
    case params['order_by']
      when 'city' then 'city'
      when 'country' then 'country'
      else 'date'
    end
  end
end
