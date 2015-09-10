class Api::VideosController < ApiController
  before_filter :authenticate_user!, only: [:create, :update, :destroy]
  before_action :set_video!, only: [:update, :destroy]

  def index
    @search = ::SearchEngine.new(search_params).find
    @channels = Channel.mappings_for(@search.results)
  end

  def homepage
    @videos = Video.for_homepage.page(params[:page]).per(params[:per])
    @channels = Channel.mappings_for(@videos)
  end

  def show
    @video = Video.includes(:channel, :categories).find(params[:id])
    if params[:include_playlists] && current_channel
      @playlists = @video.playlists.where(channel_id: current_channel.id)
    end
  end

  def similar
    video = Video.includes(:categories).find(params[:id])
    @videos = video.similar(params[:count].to_i)
    @channels = Channel.mappings_for(@videos)
  end

  def create
    service = Video::CreateService.new(create_params, current_channel)
    @video = service.call
    @upload_params = service.upload_params if !service.created_by_url?
    respond_with @video, status: :created
  end

  def update
    service = Video::UpdateService.new(@video, update_params, current_channel)
    @video = service.call
    @playlists = @video.playlists.where(channel_id: current_channel.id)
    respond_with @video, status: :accepted
  end

  def destroy
    Video.transaction do
      Uploader.new(current_channel).delete(@video.id)
      @video.destroy
    end
    respond_with @video
  end


  private
  

  def set_video!
    @video = Video.find(params[:id])
    authorize! @video
  end

  def search_params
    params.permit(:order_by, :order, :query, :page, :per, :created_from, :created_to, categories:[], duration: [])
  end

  def create_params
    @create_params ||= params.require(:video).permit(:title, :url)
  end

  def update_params
    params.require(:video).permit(:title, :description, :default_thumb_id, :hidden, :categories, :playlists, categories: [], playlists: [])
  end

end
