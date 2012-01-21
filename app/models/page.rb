# encoding: utf-8
# == Schema Information
#
# Table name: pages
#
#  id         :integer(4)      not null, primary key
#  slug       :string(255)
#  title      :string(255)
#  body       :text
#  created_at :datetime
#  updated_at :datetime
#

class Page < ActiveRecord::Base
  validates :slug,  :presence => { :message => "Le slug est obligatoire" }
  validates :title, :presence => { :message => "Le titre est obligatoire" }
  validates :body,  :presence => { :message => "Le corps est obligatoire" }

  before_validation :parameterize_slug

  def parameterize_slug
    self.slug = slug.parameterize
  end

  def to_param
    slug
  end
end
