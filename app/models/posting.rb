class Posting < ApplicationRecord

  belongs_to :author,    class_name: 'User', foreign_key: 'user_id'
  belongs_to :editor,    class_name: 'User', foreign_key: 'editor_id'

  def article_with_image(type, body)
    return { error: "type (#{type}) is not Article" } if type != 'Article'

    figure_start_tag = '<figure'
    figure_end_tag = '</figure>'
    figure_start = body.index(figure_start_tag)
    figure_end = body.index(figure_end_tag)

    return { error: "<figure> ... </figure> not found" } if figure_start.nil? || figure_end.nil?

    image_tags = body[figure_start...figure_end + figure_end_tag.length]
    return { error: "`<img` not found" } unless image_tags.include?('<img')

    posting_image_params(image_tags)
  end

  private

  def posting_image_params(html)
    tag_parse = -> (image, att) { image.match(/#{att}="(.+?)"/) }
    tag_attributes = {}

    %w[alt src data-image].each do |attribute|
      data = tag_parse.(html, attribute)
      tag_attributes[attribute] = data[1] unless (data.nil? || data[1].nil?)
    end

    return { error: 'no src for the image' } unless tag_attributes["src"]

    tag_attributes
  end
end
