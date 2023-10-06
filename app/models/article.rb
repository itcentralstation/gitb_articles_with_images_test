class Article < Posting
  # method should return hash or nil (not string)
  def article_with_image
    figure_matches = body.to_s.match(/<figure.*?>.*?(<img.*?>.*?<\/img>|<img.*?\/>).*?(.*?(<img.*?>.*?<\/img>|<img.*?\/>).*?)*<\/figure>/)
    return unless figure_matches
    first_image = figure_matches[1]
    posting_image_params(first_image)
  end

  private

  def posting_image_params(html)
    tag_attributes = {}

    %w[alt src data-image].each do |attribute|
      data = html.match(/#{attribute}=("(.+?)"|'(.+?)')/)
      tag_attributes[attribute] = data[2] || data[3] if data
    end
    # tag_parse
    tag_attributes
  end
end
