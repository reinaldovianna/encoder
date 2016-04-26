class HomeController < ApplicationController
  def index
  	@encodes = ['utf-8']
  end

  def generate
  	send_data file.force_encoding(encode_from).encode(encode_to),
    :type => "text/csv; charset=#{encode_to};",
    :disposition => "attachment; filename=#{new_file_name}"
  end

  private
  	def file_params
       params.permit(:file, :encode)
  	end

  	def file
  		@file ||= file_params[:file].tempfile.read
  	end

  	def encode_from
  		detection = CharlockHolmes::EncodingDetector.detect(file)
  		detection[:encoding]
  	end

  	def encode_to
  		params[:encode]
  	end

  	def new_file_name
  		"#{DateTime.now.to_s}_#{file_params[:file].original_filename}"
  	end
end
