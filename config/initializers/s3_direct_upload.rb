S3DirectUpload.config do |c|
  c.access_key_id     = Rails.application.secrets.aws_access_key_id
  c.secret_access_key = Rails.application.secrets.aws_secret_access_key
  c.bucket            = Rails.application.secrets.aws_bucket
end
