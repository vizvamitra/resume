require 'rails_helper'

RSpec.describe Api::VideosController, :type => :controller do

  shared_examples 'grants guest access' do

    describe 'GET index' do
      before(:each) do
        search = ::SearchEngine.new({})
        expect(SearchEngine).to receive(:new).and_return(search)
        @search = double(total: 5, results: create_list(:ok_video, 5))
        expect(search).to receive(:find).and_return(@search)
        request.call
      end

      let(:request){ ->{get :index, format: :json} }
      subject { response }

      it { should have_http_status(200) }
      it { should render_template 'videos/index' }

      it 'assigns @search' do
        expect(assigns(:search)).to eq @search
      end

      it 'assigns @channels' do
        channels = Channel.mappings_for(assigns(:search).results)
        expect(assigns(:channels)).to eq channels
      end
    end

    describe 'GET homepage' do
      let!(:videos){ create_list(:ok_video, 3, hidden: false, moderated: true) }
      let!(:other_videos){ create_list(:ok_video, 3, moderated: false) }
      let(:request){ ->{get :homepage, format: :json} }

      before(:each){ request.call }
      subject { response }

      it { should have_http_status(200) }
      it { should render_template 'videos/homepage' }
      it('assigns @videos'){ expect(assigns(:videos).to_a).to eq Video.for_homepage }

      it 'assigns @channels' do
        channels = Channel.mappings_for(assigns(:videos))
        expect(assigns(:channels)).to eq channels
      end
    end

    describe 'GET :show' do
      let(:request){ ->{get :show, id: id, format: :json} }

      context 'video exists' do
        let(:id){ create(:video).id }
        before(:each){ request.call }

        it { should have_http_status 200 }
        it { should render_template 'videos/show' }

        it 'assigns @video' do
          expect(assigns(:video)).to eq Video.includes(:channel, :categories).find(id)
        end
      end

      context 'video doesn\'t exist' do
        let(:id){ 'no such video' }

        it 'raises RecordNotFound error' do
          expect{ request.call }.to raise_error ActiveRecord::RecordNotFound
        end
      end
    end

    describe 'GET :similar' do
      let(:request){ ->{get :similar, id: video.id, format: :json, count: 4} }

      context 'video exists' do
        let(:video){ create(:ok_video) }
        let!(:videos){ create_list(:ok_video, 5, moderated: true, hidden: false) }
        before(:each){ request.call }

        it { should have_http_status 200 }
        it { should render_template 'videos/similar' }

        it 'assigns @videos' do
          expect(assigns(:videos)).to eq video.similar(4)
        end

        it 'assigns @channels' do
          expect(assigns(:channels)).to eq Channel.mappings_for(assigns(:videos))
        end
      end

      context 'video doesn\'t exist' do
        let(:video){ double(id: 'no such video') }

        it 'raises RecordNotFound error' do
          expect{ request.call }.to raise_error ActiveRecord::RecordNotFound
        end
      end
    end

  end

  shared_examples 'successful create' do
    it('creates video'){ expect(Video.count).to eq 1 }
    it('assigns @video'){ expect(assigns(:video)).to eq Video.last }
    it{ should have_http_status(201) }
    it{ should render_template 'videos/create' }
  end

  shared_examples 'failed create' do
    it('does not create video'){ expect(Video.count).to eq 0 }
    it{ should have_http_status(422) }

    it 'renders errors' do
      response_data = {errors: {video: assigns(:video).errors.messages}}
      expect(response.body).to eq response_data.to_json
    end
  end



  subject{ response }

  describe 'for guest' do
    it_behaves_like 'grants guest access'

    describe 'POST :create' do
      let(:request){ ->{post :create, video: video_attrs, format: :json} }
      let(:video_attrs){attributes_for(:video)}
      before(:each){ request.call }

      it{ should have_http_status :unauthorized }
    end

    describe 'PATCH :update' do
      let(:video){create(:ok_video)}
      let(:request){ ->{patch :update, id: video.id, video: video_attrs, format: :json} }
      let(:video_attrs){ {title: '123'} }
      before(:each){ request.call }

      it{ should have_http_status :unauthorized }
    end

    describe 'DELETE :destroy' do
      let(:video){create(:ok_video)}
      let(:request){ ->{delete :update, id: video.id, format: :json} }
      before(:each){ request.call }

      it{ should have_http_status :unauthorized }
    end

  end


  describe 'for signed in user' do
    before(:each){ sign_in :user, @user = create(:user) }

    describe 'GET :show, include_playlists: true' do
      let(:request){ ->{get :show, id: video.id, include_playlists: true, format: :json} }
      let(:video){ create(:ok_video) }
      let!(:own_playlist){ create(:playlist, channel: @user.channel, videos: [video]) }
      let!(:other_playlist){ create(:playlist, videos: [video]) }
      before(:each){ request.call }

      it 'assigns @playlists' do
        expect(assigns(:playlists)).to eq [own_playlist]
      end
    end


    describe 'POST :create' do
      let(:request){ ->{post :create, video: video_attrs, format: :json} }

      before(:each) do
        @uploader = Uploader.new
        allow(Uploader).to receive(:new).and_return(@uploader)
      end

      describe 'with invalid params' do
        let(:video_attrs){ attributes_for(:invalid_video) }

        before(:each) do
          allow(@uploader).to receive(:upload_url).and_return('http://localhost/')
          request.call
        end

        it_behaves_like 'failed create'
      end

      describe 'with valid params' do
        context 'if url given' do
          let(:video_attrs){ attributes_for(:video).merge!(url: 'example.com/video.mp4') }
          
          context 'and download request was successful' do
            before(:each) do
              expect(@uploader).to receive(:init_download)
              request.call
            end

            it_behaves_like 'successful create'
          end

          context 'and download request failed' do
            before(:each) do
              allow(@uploader).to receive(:init_download).and_raise(UploaderClient::ConnectionError)
              request.call
            end

            it_behaves_like 'failed create'
          end
        end

        context 'if url not given' do
          let(:video_attrs){ attributes_for(:video) }
          before(:each) do
            allow(@uploader).to receive(:upload_url).and_return('http://localhost/')
            request.call
          end

          it_behaves_like 'successful create'

          it 'assigns @upload_params' do
            params = Uploader.new.upload_params_for(assigns(:video))
            expect(assigns(:upload_params)).to eq params              
          end
        end

        context 'if failed getting upload url' do
          let(:video_attrs){ attributes_for(:video) }
          before(:each) do
            allow(@uploader).to receive(:upload_url).and_raise(UploaderClient::ConnectionError)
            request.call
          end

          it_behaves_like 'failed create'
        end
      end
    end


    describe 'PATCH :update' do
      let(:request){ ->{patch :update, id: video.id, video: attrs, format: :json} }

      describe 'when updating own video' do
        let(:video){ create(:video, channel: @user.channel) }

        context 'with valid params' do
          let(:attrs){ {title: 'test'} }
          let!(:own_playlist){ create(:playlist, channel: @user.channel, videos: [video]) }
          let!(:other_playlist){ create(:playlist) }
          before(:each){ request.call }

          it{ should have_http_status(202) }
          it{ should render_template(:update) }
          it('assings @video'){ expect(assigns(:video)).to eq video }
          
          it 'assings @playlists' do
            expect(assigns(:playlists)).to eq [own_playlist]
          end
        end

        context 'with invalid params' do
          let(:attrs){ {title: nil} }
          before(:each){ request.call }

          it{ should have_http_status(422) }

          it 'renders errors' do
            errors = {errors: {video: assigns(:video).errors.messages}}
            expect(response.body).to eq errors.to_json
          end
        end
      end

      describe 'when updating other\'s videos' do
        let(:video){ create(:video, channel: create(:channel)) }
        let(:attrs){ {title: 'test'} }
        before(:each){ request.call }

        it{ should have_http_status(:forbidden) }
      end

      describe 'when updating inexistant video' do
        let(:video){OpenStruct.new(id: 'no_such_video')}
        let(:attrs){ {title: 'test'} }

        it 'should raise RecordNotFound error' do
          expect{ request.call }.to raise_error ActiveRecord::RecordNotFound
        end
      end
    end

    describe 'DELETE :destroy' do
      let(:request){ ->{delete :destroy, id: video.id, format: :json} }

      before(:each) do
        @uploader = Uploader.new(@user.channel)
        allow(Uploader).to receive(:new).with(@user.channel).and_return(@uploader)
      end

      describe 'when deleting own video' do
        let(:video){ create(:video, channel: @user.channel) }

        it 'returns status 204' do
          allow(@uploader).to receive(:delete).with(video.id)
          request.call
          expect(response).to have_http_status 204
        end

        it('deletes video') do
          allow(@uploader).to receive(:delete).with(video.id)
          expect{ request.call }.to change(Video, :count).by(-1)
        end

        it 'sends delete request to uploader' do
          expect(@uploader).to receive(:delete).with(video.id)
          request.call
        end

      end

      describe 'when deleting other\'s videos' do
        let(:video){ create(:video, channel: create(:channel)) }
        before(:each){ request.call }

        it{ should have_http_status(:forbidden) }
      end

      describe 'when deleting inexistant video' do
        let(:video){OpenStruct.new(id: 'no_such_video')}

        it 'should raise RecordNotFound error' do
          expect{request.call}.to raise_error ActiveRecord::RecordNotFound
        end
      end
    end

  end
end