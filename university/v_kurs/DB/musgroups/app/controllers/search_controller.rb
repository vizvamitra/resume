class SearchController < ApplicationController
  def index
		if request.method == 'POST' && params[:query] != ""
			@results = search(search_params)
  	end
  end

private

	def search_params
    words = params.permit(:query)['query'].trim
  end

  def search(query)

  	results = {query: query, groups: [], members: [], songs: [], tours: [], concerts: []}

  	unless query == ""
			results[:groups] = Group.search_for(query)
			results[:members] = Member.search_for(query)
			results[:songs] = Song.search_for(query)
			results[:tours] = Tour.search_for(query)
			results[:concerts] = Concert.search_for(query)
		end

  	results
  end

end
