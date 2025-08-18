# frozen_string_literal: true

# Minimal shim so specs that `require 'rails_helper'` can run without a full Rails app.
require 'spec_helper'
require 'active_support/core_ext/object/blank'
require 'nokogiri'

# Tiny stand-in for ApplicationRecord/ActiveRecord
class ApplicationRecord
  def self.belongs_to(*) = nil
end

# Ensure base class is loaded before subclasses
require_relative '../app/models/posting'
%w[article question product_review user].each do |name|
  require_relative "../app/models/#{name}"
end

# Minimal attributes used in specs
Posting.class_eval { attr_accessor :body, :user, :editor, :type } if defined?(Posting)

# Tiny factory helper used by the specs (create(:posting), etc.)
def create(kind, attrs = {})
  map = { posting: Posting, user: User, article: Article, question: Question, product_review: ProductReview }
  klass = map.fetch(kind)
  obj = klass.new
  attrs.each do |k, v|
    setter = "#{k}="
    obj.public_send(setter, v) if obj.respond_to?(setter)
  end
  obj
end
