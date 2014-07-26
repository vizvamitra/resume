class SongsController < ApplicationController
  before_action :set_song, only: [:show, :edit, :update, :destroy]

  # GET /songs
  # GET /songs.json
  def index
    order_by, order = get_order_params
    @order = order == 'desc' ? 'asc' : 'desc'

    @songs = Song.get_by_group_id(params['group_id'].to_i, order_by, order)
    @group = Group.get_one(params['group_id'])
  end

  # GET /songs/1
  # GET /songs/1.json
  def show
  end

  # GET /songs/new
  def new
    @song = Song.new
    @song.group_id = params['group_id'].to_i
  end

  # GET /songs/1/edit
  def edit
  end

  # POST /songs
  # POST /songs.json
  def create
    @song = Song.new(song_params)

    respond_to do |format|
      if @song.save
        format.html { redirect_to group_songs_path(@song.group_id), notice: 'Песня успешно добавлена.' }
      else
        format.html { render action: 'new' }
      end
    end
  end

  # PATCH/PUT /songs/1
  # PATCH/PUT /songs/1.json
  def update
    respond_to do |format|
      if @song.update(song_params)
        format.html { redirect_to group_songs_path(@song.group_id), notice: 'Данные песни успешно обновлены.' }
      else
        format.html { render action: 'edit' }
      end
    end
  end

  # DELETE /songs/1
  # DELETE /songs/1.json
  def destroy
    @song.delete
    respond_to do |format|
      format.html { redirect_to group_songs_path(@song.group_id) }
    end
  end

private
  # Use callbacks to share common setup or constraints between actions.
  def set_song
    @song = Song.get_one(params[:id])
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def song_params
    params.require(:song).permit(:title, :music_by, :lyrics_by, :group_id)
  end

  def get_order_params
    order_by = case params['order_by']
      when 'music_by' then 'music_by'
      when 'lyrics_by' then 'lyrics_by'
      else 'title'
    end
    order = case params['order']
      when 'asc' then 'asc'
      when 'desc' then 'desc'
      else ''
    end
    [order_by, order]
  end
end
