class Posting < ApplicationRecord

  belongs_to :author,    class_name: 'User', foreign_key: 'user_id'
  belongs_to :editor,    class_name: 'User', foreign_key: 'editor_id'
  

  # Current implementation uses the body attribute of Posting model
  # Tries to parse from big string ( raw html ) the image tags by .index and
  # returns index range as a string if could not get <figure> or </figure>
  # If indexes are presented ( so <figure> exists inside body ) and included <img>
  # it gets all content inside <figure>

  # If indexes are presented and do not include <img> it returns a string


  # For unsuccessfull cases when indexes are not presented or do not include <img> current implementation
  # will raise an error as inside view we expect article_with_image to be a hash

  # For successfull case when we found <img> by indexes from raw html we defined proc with regular expression
  # for only one matching

  # We try to pass html to this proc tag_parse
  # it checks the result of regular expression and build hash only if there are two matches or more.
  # This condition is redunant as inside data there will be always >2 objects as we are using unnamed group
  # that could be get from matchdata by [1] -> data[1] always returns matching (.+?)


  # So according to the questions

  # - Does the implementation achieve the desired effect?
  # Yes, it does only in case when we have one image attrubutes inside body

  # - What are the shortcomings of this implementation?
  # Different types that article_with_image could return
  # We are not handling multiple <img> correctly
  # View fails to render if article_with_image has unsuccessfull case
  # Unit test is missing the edge casses

  # - Does the code adhere to best practices?
  # It does not.

  # -The code includes a unit test, which passes. What is wrong with this unit test? How could it be improved?
  # Add the edge cases when there is not 'alt', 'src', 'data-image'
  # Add the edge cases when there are multiple 'alt', 'src', 'data-image'

  # -How might you implement this differently?

  # If we need to store raw html and can not change this approach I use .scan
  # Change the logic for unsuccefull cases and returning type


  def article_with_image
    return type if type != 'Article'

    figure_start = body.index('<figure')
    figure_end = body.index('</figure>')
    return "#{figure_start}_#{figure_end}" if figure_start.nil? || figure_end.nil?

    image_tags = body[figure_start...figure_end + 9]
    return 'not include <img' unless image_tags.include?('<img')

    posting_image_params(image_tags)
  end

  private

  def posting_image_params(html)
    tag_parse = -> (image, att) { image.match(/#{att}="(.+?)"/) }
    tag_attributes = {}

    %w[alt src data-image].each do |attribute|
      data = tag_parse.(html, attribute)

      if data && data.size > 2
        tag_attributes[attribute] = data[1]
      end

      # unless data.nil?
      #   tag_attributes[attribute] = data[1] unless data.size < 2
      # end
    end
    # tag_parse
    tag_attributes
  end
end
