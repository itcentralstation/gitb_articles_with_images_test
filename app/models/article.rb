class Article < Posting
  # This functions is a part of article class, so it should be here instead of posting model

  def article_with_image
    # Don`t need this as this function already part of article class
    # return type if type != 'Article'

    figure_start = body.index('<figure')
    figure_end = body.index('</figure>')
    return if figure_start.nil? || figure_end.nil?

    figure_context_start = body[figure_start + 8...figure_end].index("<") # Get the index of first tag inside figure
    return unless figure_context_start

    image_tags = body[figure_context_start...figure_end] # Select figure context to avoid mismatch with figure attributes
    return unless image_tags.include?('<img')

    posting_image_params(image_tags)
  end

  private

  def posting_image_params(html)
    tag_parse = -> (image, att) { image.match(/#{att}="(.+?)"/) }
    tag_attributes = {}

    %w[alt src data-image].each do |attribute|
      data = tag_parse.(html, attribute)
      tag_attributes[attribute] = data[1] if data && data.size > 0 #refactored
    end
    # tag_parse
    tag_attributes
  end
end
