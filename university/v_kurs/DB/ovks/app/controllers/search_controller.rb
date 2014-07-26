class SearchController < ApplicationController

  def search

    if params[:query].nil? || params[:query].empty?

      @found=[]

    else

      @query = params[:query]
      search_params = {
        Bill => [:ovks_num, :bill_num, :total_sum],
        BillPosition => [:model, :sn],
        Nz => [:ovks_num, :contract_num, :code, :destination, :apk_name, :decimal_num, :zav_num],
        Sz => [:ovks_num],
        Item => [:name],
        Receipt => [:ovks_num],
        Employee => [:fio]
      }

      @found = []
      search_params.each do |model, fields|
        model.search(@query, *fields).each { |obj| @found << obj }
      end

    end
  end

end
