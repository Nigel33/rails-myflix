CarrierWave.configure do |config|
 
    # In Heroku, follow http://devcenter.heroku.com/articles/config-vars
    #
    # $ heroku config:add S3_KEY=your_s3_access_key S3_SECRET=your_s3_secret S3_REGION=eu-west-1 S3_ASSET_URL=http://assets.example.com/ S3_BUCKET_NAME=s3_bucket/folder

    # Configuration for Amazon S3
  if Rails.env.staging? || Rails.env.production?
    config.fog_provider = 'fog/aws'
    config.fog_credentials = {
      :provider              => 'AWS',
      :aws_access_key_id     => ENV['S3_KEY'],
      :aws_secret_access_key => ENV['S3_SECRET'],
    }
    config.storage = :fog
    config.fog_directory = 'name_of_directory'
  else
    config.storage = :file
    config.enable_processing = Rails.env.development?
  end
end