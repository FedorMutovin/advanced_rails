class Link < ApplicationRecord
  belongs_to :linkable, polymorphic: true

  validates :name, :url, presence: true
  validates :url, url: true

  before_validation :set_gist_name

  private

  def set_gist_name
    self.name = gist if gist?
  end

  def gist?
    url.include?("/gist.github.com/")
  end

  def gist
    Octokit::Client.new.gist(url.split('/').last).files.first[1].content if gist?
  end
end
