class PhotoResource < BaseResource
  attributes :width, :height, :filename, :filesize, :title, :caption, :tags
  attribute :url, delegate: :cloudfront_url

  has_one :event, always_include_linkage_data: true
  has_one :teacher, always_include_linkage_data: true
end
