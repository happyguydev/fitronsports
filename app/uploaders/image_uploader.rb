class ImageUploader < CarrierWave::Uploader::Base
  include CarrierWave::MiniMagick

  # Choose what kind of storage to use for this uploader:
  # storage :fog

  def store_dir
    if model.attachable_type.downcase == 'request'
      "uploads/requests/#{model.attachable&.janitor&.id}/#{model.id}"
    elsif model.attachable_type.downcase == 'report'
      "uploads/reports/#{model.attachable&.inspector&.id}/#{model.id}/signature"
    else #report part
      "uploads/reports/#{model.attachable&.report&.inspector&.id}/#{model.id}"
    end
  end
  
=begin
  version :hd do
    process resize_to_fit: [1920, 1080]
  end

  version :full do
    process resize_to_fit: [1280, 729]
  end

  version :large do
    process resize_to_fit: [960, 540]
  end

  version :medium do
    process resize_to_fit: [640, 360]
  end

  version :small do
    process resize_to_fit: [426, 240]
  end
=end
  version :medium do
    process resize_to_fit: [640, 360]
    process :quality => 70
  end

  version :thumb do
    process resize_to_fit: [50, 50]
  end

  # Add a white list of extensions which are allowed to be uploaded.
  # For images you might use something like this:
  def extension_whitelist
    %w[jpg jpeg gif png]
  end
end
