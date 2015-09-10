require 'rails_helper'

RSpec.describe Video, :type => :model do

  describe 'validations' do
    it_behaves_like 'validates presence of', :title, :channel, :callback_token, :embed
    it_behaves_like 'validates uniqueness of', :callback_token

    context 'when upload status is "ok"' do
      it 'validates presence of duration' do
        expect(build(:ok_video, duration: nil)).not_to be_valid
      end

      it 'validates presence of files' do
        expect(build(:ok_video, files: nil)).not_to be_valid
      end

      it 'validates correctness of default_thumb_id' do
        expect(build(:ok_video, default_thumb_id: 0)).to be_valid
        expect(build(:ok_video, default_thumb_id: 4)).to be_valid
        expect(build(:ok_video, default_thumb_id: -1)).not_to be_valid
        expect(build(:ok_video, default_thumb_id: 100)).not_to be_valid
      end
    end
  end

  describe 'scopes' do
    before(:each) do
      @uploading_videos = create_list(:uploading_video, 3)
      @converting_videos = create_list(:converting_video, 3)
      @ok_videos = create_list(:ok_video, 3)
      @error_videos = create_list(:error_video, 3)
    end

    describe 'uploading' do
      it 'returns currently uploading videos' do
        expect(Video.uploading).to match_array(@uploading_videos)
      end
    end

    describe 'converting' do
      it 'returns currently uploading videos' do
        expect(Video.converting).to match_array(@converting_videos)
      end
    end

    describe 'ready' do
      it 'returns successfully converted videos' do
        expect(Video.ready).to match_array(@ok_videos)
      end
    end

    describe 'failed' do
      it 'returns failed videos' do
        expect(Video.failed).to match_array(@error_videos)
      end
    end

    describe 'recent' do
      it 'orders videos by created_at descending' do
        expect(Video.recent).to be_ordered_by :created_at, :desc
      end
    end

    describe 'moderated' do
      it 'returns only moderated videos' do
        videos = create_list(:video, 2, moderated: true)
        expect(Video.moderated).to match_array(videos)
      end
    end

    describe 'visible' do
      it 'returns videos with hidden: false' do
        create_list(:video, 2, hidden: true)
        Video.visible.each{|v| expect(v.hidden).to be_falsey}
      end
    end

    describe 'for_homepage' do
      it 'returns recent ready visible moderated videos' do
        videos = Video.ready.moderated.visible.recent
        expect(Video.for_homepage).to eq videos
      end
    end
  end

  describe 'callbacks' do
    context 'when newly created' do
      it 'sets callback_token' do
        expect(Video.new.callback_token).not_to be_empty
      end

      it 'sets unique callback_token' do
        token, other_token = SecureRandom.hex(10), SecureRandom.hex(10)
        allow(SecureRandom).to receive(:hex).and_return(token, other_token)
        create(:video, callback_token: token)
        expect(Video.new.callback_token).to eq other_token
      end

      it 'sets embed' do
        expect(Video.new.embed).not_to be_nil
      end
    end
  end


  describe '#similar' do
    let(:categories){create_list(:category, 2)}

    context 'if video has categories' do
      it 'returns videos from random video\'s category' do
        create_list(:ok_video, 3, categories: [categories[0]], moderated: true, hidden: false)
        create_list(:ok_video, 3, categories: [categories[1]], moderated: true, hidden: false)
        video = create(:ok_video, categories: categories)
        results = video.similar
        category = results.first.categories.first
        results.each{|v| expect v.categories == [category]}
      end
    end

    context 'if video is not in any category' do
      it 'returns videos fram any category' do
        video = create(:ok_video)
        video.similar.each {|v| expect(categories).include?(v.category)}
      end
    end

    it 'returns only ready videos' do
      not_ready_video = create(:video, moderated: true, hidden: false)
      expect(create(:video).similar).not_to include(not_ready_video)
    end

    it 'returns only moderated videos' do
      not_moderated_video = create(:ok_video, moderated: false, hidden: false)
      expect(create(:video).similar).not_to include(not_moderated_video)
    end

    it 'returns only visible videos' do
      hidden_video = create(:ok_video, moderated: true, hidden: true)
      expect(create(:video).similar).not_to include(hidden_video)
    end

    it 'orders videos by created_at descending' do
      create_list(:ok_video, 3, moderated: true, hidden: false)
      expect(create(:video).similar).to be_ordered_by :created_at, :desc
    end

    it 'returns given number of videos' do
      create_list(:ok_video, 5, moderated: true, hidden: false)
      video = create(:video)
      expect(video.similar.count).to eq 5
      expect(video.similar(3).count).to eq 3
    end

    it 'caps max video count to 10' do
      create_list(:ok_video, 11, moderated: true, hidden: false)
      expect(create(:video).similar(11).count).to eq 10
    end

    it 'excludes self' do
      video = create(:ok_video, moderated: true, hidden: false)
      expect(video.similar).to be_empty
      expect(create(:video).similar).to eq [video]
    end
  end

end
