require "rails_helper"

RSpec.describe SearchEngine, type: :service, search: true do

  describe '#find' do

    before(:all) do
      category = create(:category, id: 2)
      video_attrs = [
        {
          description: 'test',
          duration: 100,
          created_at: '01.01.2014',
          hidden: false
        },
        {
          title: 'test',
          duration: 50,
          created_at: '01.01.2015',
          categories: [category],
          hidden: false
        },
        {
          duration: 200,
          created_at: '01.02.2015',
          categories: [category],
          hidden: false
        },
        {
          duration: 150,
          created_at: '15.01.2015',
          hidden: true
        },
        {
          duration: 250,
          created_at: '01.03.2015',
          upload_status: ['error', 'uploading', 'converting'].sample,
          hidden: false
        }
      ]
      @videos = video_attrs.map{ |attrs| create(:ok_video, **attrs) }
      Sunspot.commit
    end

    def match_results mappings
      mappings.each do |params, expected|
        search = SearchEngine.new(params).find
        expect(search.results).to match_array expected
      end
    end


    it 'applies ready status' do
      match_results({
        {allow_not_ready: true} => [0,1,2,  4].map{|i| @videos[i]},
        {allow_not_ready: false} => @videos[0..2],
        {} => @videos[0..2]
      })
    end

    it 'applies hidden status' do
      match_results({
        {allow_hidden: true} => @videos[0..3],
        {allow_hidden: false} => @videos[0..2],
        {} => @videos[0..2]
      })
    end

    it 'applies duration' do
      match_results({
        {duration: [0, 150]} => @videos[0..1],
        {duration: [100, 200]} => [@videos[0], @videos[2]],
        {} => @videos[0..2]
      })
    end

    it 'applies creation period' do
      match_results({
        {created_from: '10.11.2014'} => @videos[1..2],
        {created_to: '10.11.2014'} => [@videos[0]],
        {created_from: '10.11.2014', created_to: '11.01.2015'}=>[@videos[1]]
      })
    end

    it 'applies category ids' do
      match_results({
        {categories: [1,2]} => @videos[1..2],
        {categories: [1]} => [],
      })
    end

    describe 'ordering' do
      context 'if order_by is given' do
        it 'applies ordering' do
          match_results({
            {order_by: 'duration', order: 'asc'} => [1,0,2].map{|i| @videos[i]},
            {order_by: 'duration'} => [2,0,1].map{|i| @videos[i]},
            {order_by: 'created_at', order: 'desc'} => @videos[0..2].reverse
          })
        end
      end

      context 'if order_by not given' do
        context 'when searching' do
          it 'orders results by relevance' do
            search = SearchEngine.new({query: 'test'}).find
            expect(search.results).to eq [1,0].map{|i| @videos[i]}
          end
        end

        context 'when not searching' do
          it 'orders results by created_at descending' do
            search = SearchEngine.new({}).find
            expect(search.results).to be_ordered_by(:created_at, :desc)
          end
        end
      end
    end

    it 'paginates results' do
      match_results({
        {page: 1, per: 2} => @videos[1..2],
        {page: 2, per: 2} => [@videos[0]],
        {page: 10, per: 1} => []
      })
    end


    after(:all) do
      Category.all.map(&:destroy)
      Video.all.map(&:destroy)
    end

  end
end