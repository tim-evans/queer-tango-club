class TeacherResource < BaseResource
  attributes :name, :url, :bio

  has_many :photos
  has_many :guests

  before_create do
    @model.group = context[:group]
  end

  def self.records(options={})
    options[:context][:group].teachers
  end
end
