# encoding: utf-8
require 'lfmarkdown'
require 'lfsanitizer'
require 'lftruncator'

##
# Some ActiveRecord::Base extensions
#
class ActiveRecord::Base
  def self.sanitize_attr(attr)
    method = "sanitize_#{attr}".to_sym
    before_validation method
    define_method method do
      send("#{attr}=", LFSanitizer.clean(self[attr]))
    end
    define_method attr do
      self[attr].to_s.html_safe
    end
  end

  def self.truncate_attr(attr, nb_words=80)
    method = "truncate_#{attr}".to_sym
    before_save method
    define_method method do
      send("truncated_#{attr}=", LFTruncator.truncate(send(attr), nb_words)) if send("#{attr}_changed?")
    end
    define_method "truncated_#{attr}" do
      self["truncated_#{attr}"].html_safe
    end
  end

  def self.wikify_attr(attr, *opts)
    method = "wikify_#{attr}".to_sym
    before_validation method
    define_method method do
      send("#{attr}=", wikify(send("wiki_#{attr}"), *opts))
    end
    sanitize_attr attr
  end

  # Transform wiki syntax to HTML
  def wikify(txt, *extensions)
    LFMarkdown.new(txt, *extensions).to_html
  end
end
