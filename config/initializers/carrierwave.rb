CarrierWave.configure do |config|
  if Rails.env.staging? || Rails.env.production?
    config.fog_credentials = {
      provider:              'AWS',                                               # required
      aws_access_key_id:     ENV['S3_BUCKET_ACCESS_KEY'],                         # required unless using use_iam_profile
      aws_secret_access_key: ENV['S3_BUCKET_SECRET_KEY'],                         # required unless using use_iam_profile
      region:                ENV['S3_BUCKET_REGION']
    }
    config.fog_directory  = ENV['S3_BUCKET_URL']                                      # required
    config.storage = :fog
  else
    config.storage = :file
  end
end

module CarrierWave
  module MiniMagick
      def quality(percentage)
          manipulate! do |img|
              img.quality(percentage.to_s)
              img = yield(img) if block_given?
              img
          end
      end
  end
end