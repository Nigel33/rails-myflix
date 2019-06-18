class SmallCoverUploader < CarrierWave::Uploader::Base 
	include CarrierWave::MiniMagick

	# process :resize_to_fit => [236, 166]

end 