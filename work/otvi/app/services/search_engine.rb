class SearchEngine
  def initialize params
    @params = params
  end

  def find
    Sunspot.search(Video) do
      fulltext query do
        boost_fields title: 2.0
        boost_fields description: 1.0
      end

      with(:category_ids, categories) if categories
      with(:duration, duration)
      with(:created_at, period)
      with(:ready, true) unless not_ready_allowed?
      with(:hidden, false) unless hidden_allowed?
      paginate page: page, per_page: per_page
      order_by(order_field, order) if ordering_needed?
    end
  end

  private

  def order_field
    allowed = {'created_at' => :created_at, 'duration' => :duration}
    allowed[@params[:order_by]] || :created_at
  end

  def order
    allowed = {'asc' => :asc, 'desc' => :desc}
    allowed[@params[:order]] || :desc
  end

  def ordering_needed?
    @params[:order_by] || @params[:query].blank?
  end

  def query
    @params[:query]
  end

  def page
    page = @params[:page].to_i
    page > 0 ? page : 1
  end

  def per_page
    per_page = @params[:per].to_i
    (1..50).include?(per_page) ? per_page : 50
  end

  def categories
    @params[:categories]
  end

  def duration
    min = @params[:duration].try(:[], 0).to_i
    max = @params[:duration].try(:[], 1).to_i
    max = 100*60*60 if max.zero? # max 100 hours if max not set
    min..max
  end

  def period
    from = parse_date(@params[:created_from]) || DateTime.strptime('0', '%s')
    to = parse_date(@params[:created_to]) || DateTime.now
    from..to
  end

  def parse_date date_string
    Time.zone.parse(date_string) rescue nil
  end

  def not_ready_allowed?
    @params[:allow_not_ready] || false
  end

  def hidden_allowed?
    @params[:allow_hidden] || false
  end
end