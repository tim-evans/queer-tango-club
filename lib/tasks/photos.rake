namespace :photos do
  desc "Migrate photos embedded on models to photo models"
  task :migrate => :environment do
    CoverPhoto.transaction do
      CoverPhoto.all.each do |cover_photo|
        params = photo_params(cover_photo.attachment)

        Photo.create!(params.merge({
          event: cover_photo.event,
          title: cover_photo.title,
          tags: ['cover-photo']
        }))
      end
      # CoverPhoto.destroy_all

      Location.all.each do |location|
        unless location.photo_id
          params = photo_params(location.photo)

          photo = Photo.create!(params)
          location.photo_id = photo.id
          location.save!
        end
      end

      Expense.all.each do |expense|
        unless expense.receipt_id
          params = photo_params(expense.receipt)

          photo = Photo.create!(params)
          expense.receipt_id = photo.id
          expense.save!
        end
      end

      Photo.all.each do |photo|
        unless photo.url
          params = photo_params(photo.attachment)
          photo.attributes = params
          photo.save!
        end
      end
    end
  end

  def photo_params(attachment)
    url = attachment.url(:original)
    width, height = FastImage.size(url)
    url = url.gsub("https://#{ENV['CLOUDFRONT_URL']}/",
                   "https://#{ENV['S3_BUCKET_NAME']}.s3.amazonaws.com/")

    {
      url: url,
      width: width,
      height: height,
      filename: attachment.original_filename,
      filesize: attachment.size
    }
  end
end
