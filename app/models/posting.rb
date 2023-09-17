class Posting < ApplicationRecord

  belongs_to :author, class_name: 'User', foreign_key: 'user_id'
  belongs_to :editor, class_name: 'User', foreign_key: 'editor_id'
  
  def article_with_image
    # why we return type here for non-article postings? should be just return '' or nil.
    # This will fail on render partial.
    return type if type != 'Article'

    # Not sure why app built that way that we store/transit images within strings/params
    # images must be covered as separate entities with PaperClip or any other image management gem/tool

    # Imagine this is parsed somewhere so we need to extract images from string.
    # I'd implement some ImageExctractor service class which will care of parsing of images
    # and return image_tags

    ImageExtractor.new(body).call
  end
end