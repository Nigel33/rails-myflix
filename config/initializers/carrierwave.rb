CarrierWave.configure do |config|
    # Configuration for Amazon S3
  if Rails.env.development? || Rails.env.production?
    config.storage = :aws
    config.aws_bucket = ENV['AWS_S3_BUCKET']
    config.aws_acl = 'public_read'
    config.aws_credentials = {
      :access_key_id     => ENV['S3_KEY'],
      :secret_access_key => ENV['S3_SECRET'],
      :region            => 'us-east-1'
    }
  else
    config.storage = :file
    config.enable_processing = Rails.env.development?
  end
end