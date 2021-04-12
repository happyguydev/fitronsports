require 'aws-sdk-s3'

Aws.config.update(
  {
    region: ENV.fetch('S3_BUCKET_REGION'),
    credentials: Aws::Credentials.new(
      ENV.fetch('S3_BUCKET_ACCESS_KEY'),
      ENV.fetch('S3_BUCKET_SECRET_KEY')
    )
  }
)

S3_BUCKET = Aws::S3::Resource.new.bucket(ENV.fetch('S3_BUCKET_URL'))