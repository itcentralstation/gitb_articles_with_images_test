class Posting < ApplicationRecord

  belongs_to :author,    class_name: 'User', foreign_key: 'user_id'
  belongs_to :editor,    class_name: 'User', foreign_key: 'editor_id'
  
# Those methods are really bad I would say, first thing that comes to my mind is that I am not
# sure whether this logic should be here on the first place, I would do something like that in the controller.

# Next problem: in our view we retrieving response from this method like this: 
#
# -image = posting.article_with_image
# -if image ...
#
# As I can see, there is first return, which gives us type if it is not Article, so
# it is possible on view to receive `type` which is something and condition for -if image is met in that case (it shouldn't be)
#
# As for the retrieving '<figure>' I can say nothing, this is the first time I faced such logic with html as params at all.
# I can assume, if there is not such object inside body, index can return some kind of an error that will not load the page at all, but
# the error screen
#
# Then we have the second return, which of course works wrong as well. If one of the variables above is nil
# it returns "#{nil}_#{nil}" which is some kind of parsing and I doubt that it is nil we expect to see on our view.
# And still condition for for -if image is met in this case
# 
# As for the third return it still returns a string and the condition is still met in that case.
# 
# Okay, so the first method has to many return, I would suggest to split logic + rubocop would suggested the same I guess if it is present

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

# As for the second method, there is a forgotten commented change tag_parse
# Then I see if data is nil, method returns tag_attributes whis at this point is an empty hash
# I am note sure for 100%, but in that case -if image (which is an empty hash) will not met the condition and skip it
#
  
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

# Overall, If to be honest, I think it is an unadequate code which shouldn't be allowed to be deployed to production
# It cannot be fixed, only rewriting.
end
