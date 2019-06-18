class LargeCoverUploader < CarrierWave::Uploader::Base 
	include CarrierWave::MiniMagick

	# process :resize_to_fill => [500, 400]
end 