CarrierWave.configure do |config|
 
    # In Heroku, follow http://devcenter.heroku.com/articles/config-vars
    #
    # $ heroku config:add S3_KEY=your_s3_access_key S3_SECRET=your_s3_secret S3_REGION=eu-west-1 S3_ASSET_URL=http://assets.example.com/ S3_BUCKET_NAME=s3_bucket/folder

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