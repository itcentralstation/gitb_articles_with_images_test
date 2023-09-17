class ImageExtractor
  def initialize(body)
    @body = body
  end

  attr_reader :body

  def call
  	figure_start = body.index('<figure')
    figure_end = body.index('</figure>')
    return "#{figure_start}_#{figure_end}" if figure_start.nil? || figure_end.nil?

    image_tags = body[figure_start...figure_end + 9]
    # not sure why we return this string msg to UI though
    # it will fail on partial view
    return 'not include <img' unless image_tags.include?('<img')

    posting_image_params(image_tags)
  end

  def posting_image_params(html)
  	# using lambda is nice and tricky :)
  	# but why not just use method for that, if we just use it inside same class
    tag_parse = -> (image, att) { image.match(/#{att}="(.+?)"/) }
    tag_attributes = {}

    %w[alt src data-image].each do |attribute|
      data = tag_parse.(html, attribute)
      if data && data.size > 2
        tag_attributes[attribute] = data[1]
      end
    end
    # tag_parse
    tag_attributes
  end
end