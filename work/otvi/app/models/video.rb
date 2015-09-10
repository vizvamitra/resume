class Video < ActiveRecord::Base
  belongs_to :channel
  has_one :embed, as: :embeddable, dependent: :destroy
  has_and_belongs_to_many :categories
  has_many :playlist_items, dependent: :delete_all
  has_many :playlists, through: :playlist_items
  has_many :thumbnail_owners, class_name: "Playlist", foreign_key: 'thumbnail_video_id', dependent: :nullify

  validates_presence_of :title, :channel, :callback_token, :embed
  validates_uniqueness_of :callback_token, on: :create
  validates_presence_of :duration, :files, if: -> {upload_status == "ok"}
  validate :correct_default_thumb_id?, if: -> {upload_status == "ok"}

  enum upload_status: [:uploading, :converting, :ok, :error]

  scope :uploading, ->{ where(upload_status: Video.upload_statuses['uploading']) }
  scope :converting, ->{ where(upload_status: Video.upload_statuses['converting']) }
  scope :ready, ->{ where(upload_status: Video.upload_statuses['ok']) }
  scope :failed, ->{ where(upload_status: Video.upload_statuses['error']) }
  scope :recent, ->{ order(created_at: :desc) }
  scope :moderated, ->{ where(moderated: true) }
  scope :visible, ->{ where(hidden: false) }
  scope :for_homepage, ->{ ready.moderated.visible.recent }

  after_initialize(if: :new_record?) do
    self.embed = Embed.new
    self.callback_token = unique_callback_token
  end

  searchable do
    text :title
    text :description
    boolean :ready, using: :ok?
    boolean :hidden, using: :hidden?
    integer :category_ids, multiple: true, references: Category
    integer :duration
    time :created_at
  end

  delegate :small_thumbs, :large_thumbs,
           :sources, :qualities,
           to: :content

  def default_small_thumb
    small_thumbs[default_thumb_id]
  end

  def default_large_thumb
    large_thumbs[default_thumb_id]
  end

  def similar(count=10)
    count = (1..10).include?(count) ? count : 10
    category = categories.sample
    collection = (category ? category.videos : Video)
    scope = collection.ready.moderated.visible.recent
    scope.where.not(id: id).limit(count)
  end

  private

  def content
    @content ||= Video::Content.new(files)
  end

  def unique_callback_token
    # CODE HIDDEN #
  end

  def correct_default_thumb_id?
    max_value = [small_thumbs.count, large_thumbs.count].min - 1
    unless (0..max_value).include? default_thumb_id
      self.errors.add(:default_thumb_id, :inclusion)
    end
  end
end
