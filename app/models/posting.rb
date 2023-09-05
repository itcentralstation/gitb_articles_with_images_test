class Posting < ApplicationRecord

  belongs_to :author,    class_name: 'User', foreign_key: 'user_id'
  belongs_to :editor,    class_name: 'User', foreign_key: 'editor_id'
  
  def article_with_image
    return type if type != 'Article'

    figure_start = body.index('<figure')
    figure_end = body.index('</figure>')
    return "#{figure_start}_#{figure_end}" if figure_start.nil? || figure_end.nil?

    image_tags = body[figure_start...figure_end + 9]
    # Avoid using magic numbers. 9 should be a constant with explanatory name
    return 'not include <img' unless image_tags.include?('<img')

    posting_image_params(image_tags)
  end

  private

  def posting_image_params(html)
    tag_parse = -> (image, att) { image.match(/#{att}="(.+?)"/) }
    tag_attributes = {}

    %w[alt src data-image].each do |attribute|
      data = tag_parse.(html, attribute)
      unless data.nil?
        tag_attributes[attribute] = data[1] unless data.size < 2
        # Avoid using magic numbers. 2 should be a constant with explanatory name
      end
    end
    # tag_parse
    tag_attributes
  end
end

# In case if article contains the image, its snippet should contain image above the body -- was implemented. 

# Doesn't handle the case when article has multiple images
