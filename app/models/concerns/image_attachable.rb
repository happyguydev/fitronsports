module ImageAttachable
  extend ActiveSupport::Concern

  included do
    has_many_attached :images
  end

  def not_original_images
    return self.images_attachments.where("note != '![*edited*]'")
  end

  def original_images
    return self.images_attachments.where(note: "![*edited*]")
  end

  def image_url(img)
    S3_BUCKET.object(img.key).public_url
  end

  def attach_images(images_attachments)
    images_attachments.each do |id, attachment|
      attach = self.images.attach(attachment['blob'])
      self.images_attachments.find(self.images.last.id).update(note: attachment['note'])
    end
  end

  def attachments_update(images_attachments)
    images_attachments.each do |id, params|
      attachment = self.images.find(params['id'].to_i)
      if params['_destroy'] == 'true'
        attachment.purge_later
      else
        attachment.update(note: params['note'])
      end
    end
  end
end
