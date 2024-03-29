class Posting < ApplicationRecord

  belongs_to :author,    class_name: 'User', foreign_key: 'user_id'
  belongs_to :editor,    class_name: 'User', foreign_key: 'editor_id'

  # bad method name and Article-related method in Posting parent class at least. Ideally it all should be moved to a
  # SnippetGerenatorService for better alignment with SOLID principles.
  def article_with_image
    return type if type != 'Article' # move the method to the Article class and this check isn't needed

    # intead of searching for indexes it's better to use a regexp for matching. Here's a great resource to play around
    # with regular expressions: https://regex101.com/

    # Oh, last but not least: I'm pretty sure figure tag is not only used by images
    figure_start = body.index('<figure')
    figure_end = body.index('</figure>')

    # As you can see from the execution:
    #  => "#{nil}_#{nil}"
    #  => "_"
    # The following code will simply return an underscore and this code will break the view if there's no image present
    # in the Article's body.
    # return nil instead
    return "#{figure_start}_#{figure_end}" if figure_start.nil? || figure_end.nil?

    # What's the point of +9 here?
    image_tags = body[figure_start...figure_end + 9]

    # Same issue here. We'll break the view
    return 'not include <img' unless image_tags.include?('<img')

    posting_image_params(image_tags)
  end

  private

  # I'm pretty sure we could do all of that using Regular expression, not jusst parse for tags.
  # I assume this still will work if the image format is the same across all the Articles but I have no context on that.
  # Also, ideally we should host all the images on our own to avoid things like broken images if image hosting (or
  # wherever image URL comes from is down). This way we could also store the image additionally via PostingImage model
  # to simply query for the needed image instead of parsing text for the url and all attribute since if the text for
  # the Article is pasted from somewhere else in the internet the format of the tag could be different.
  # We still could come up with a solution like this by trying to write a migration to create a PostingImage class and
  # start using it across the project and a data migration task to create the PostingImages for existing projects where
  # our Regular expression will match them. We need to rescue the migration task for parsing errors. This way, our
  # worst case scenario would be some of the articles with weird urls will be missing the image instead of breaking the
  # whole App if parsing fails when page loads. Also, it's just faster in terms of execution. We'll do all the parsing
  # in our migration task.
  # btw, this way we could implement the ability to choose the snippet image for future Articles instead of defaulting it
  # to the first image used in Article.
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
