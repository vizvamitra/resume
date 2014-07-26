class ConcertsController < ApplicationController
  before_action :set_concert, only: [:show, :edit, :update, :destroy]

   # GET /concerts/new
  def new
    @concert = Concert.new
    @tour = Tour.get_one(params['tour_id'].to_i)
    @concert.tour_id = @tour.id
  end

  # GET /concerts/1/edit
  def edit
    @tour = Tour.get_one(params['tour_id'].to_i)
  end

  # POST /concerts
  # POST /concerts.json
  def create
    @concert = Concert.new(concert_params)
    @tour = Tour.get_one(@concert.tour_id)

    respond_to do |format|
      if @concert.save
        format.html { redirect_to group_tour_path(@tour.group_id,
                      @concert.tour_id),
                      notice: 'Данные о концерте успешно добавлены.' }
      else
        format.html { render action: 'new' }
      end
    end
  end

  # PATCH/PUT /concerts/1
  # PATCH/PUT /concerts/1.json
  def update
    @tour = Tour.get_one(@concert.tour_id)
    respond_to do |format|
      if @concert.update(concert_params)
        format.html { redirect_to group_tour_path(@tour.group_id,
                      @concert.tour_id),
                      notice: 'Данные о концерте успешно изменены.' }
      else
        format.html { render action: 'edit' }
      end
    end
  end

  # DELETE /concerts/1
  # DELETE /concerts/1.json
  def destroy
    @tour = Tour.get_one(@concert.tour_id)
    @concert.delete
    if @concert.errors.any?
      errors = ""
      @concert.errors.full_messages.each do |msg|
        errors << msg << "\n"
      end
    end
    respond_to do |format|
      format.html { redirect_to group_tour_path(@tour.group_id,
                    @concert.tour_id), notice: errors }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_concert
      @concert = Concert.get_one(params[:id].to_i)
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def concert_params
      pars = params.require(:concert).permit! do |whitelist|
        whitelist['tour_id'] = params['concert']['tour_id']
        whitelist['city'] = params['concert']['city']
        whitelist['country'] = params['concert']['country']
        whitelist['date(1i)'] = params['concert']['date(1i)']
        whitelist['date(2i)'] = params['concert']['date(2i)']
        whitelist['date(3i)'] = params['concert']['date(3i)']
      end

      pars['city'] = pars['city'].trim
      pars['country'] = pars['country'].trim
      pars['tour_id'] = pars['tour_id'].to_i
      pars['date(1i)'] = pars['date(1i)'].to_i
      pars['date(2i)'] = pars['date(2i)'].to_i
      pars['date(3i)'] = pars['date(3i)'].to_i

      pars['date'] = 
          pars.delete('date(1i)').to_s + '-' +
          pars.delete('date(2i)').to_s + '-' +
          pars.delete('date(3i)').to_s

      pars
    end
end
