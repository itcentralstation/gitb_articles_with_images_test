class Posting < ApplicationRecord

  belongs_to :author,    class_name: 'User', foreign_key: 'user_id'
  belongs_to :editor,    class_name: 'User', foreign_key: 'editor_id'
  
  # I don't like a lot of things here.
  # First of all, the methods naming is confusing.
  # I'm not sure if it's working or not without running the code.

  # What are the shortcomings of this implementation? - hard to understand, hard to support etc.
  # Does the code adhere to best practices? - definitely no.

  # If I understand correctly we're checking for the first image in the Article here
  # It should be named like first_image or something like that

  # the structure should be the following:

  # def first_image
  #   return nil unless type == 'Article'
  #
  #   body.match(/.../)[0]
  # end

  def article_with_image
    # why should we return type if it's not article, I don't understand. We're expecting to receive an image but we can receive a type instead (ProductReview or Question), why?
    return type if type != 'Article'

    # that's not a good approach
    figure_start = body.index('<figure')
    figure_end = body.index('</figure>')
    # Why should we return #{figure_start}_#{figure_end} in case of absent figure tag - I have no idea.
    return "#{figure_start}_#{figure_end}" if figure_start.nil? || figure_end.nil?

    # it's not elegant solution, why don't we use regexp for that?
    image_tags = body[figure_start...figure_end + 9]
    # the same, it's very weird return.
    # it's better to search for the image using regexp and then return it or return nil, something like that.
    # the text return "not include..." is totally unacceptable.
    return 'not include <img' unless image_tags.include?('<img')

    posting_image_params(image_tags)
  end

  private

  # I'm pretty sure we don't need this parse method
  # why don't we just return actual image html from the previous method?
  # I don't see the task we need to use different image alt if we don't have it (as we doing in the view)
  # So we can just pass the html image to the view
  def posting_image_params(html)
    tag_parse = -> (image, att) { image.match(/#{att}="(.+?)"/) }
    tag_attributes = {}

    %w[alt src data-image].each do |attribute|
      data = tag_parse.(html, attribute)
      unless data.nil?
        tag_attributes[attribute] = data[1] unless data.size < 2
      end
    end
    # tag_parse
    tag_attributes
  end
end