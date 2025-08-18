# frozen_string_literal: true

# Base content record representing an authored, HTML-backed posting.
# Articles, Questions, and ProductReviews inherit from this.
class Posting < ApplicationRecord
  belongs_to :author,    class_name: 'User', foreign_key: 'user_id' # rubocop:disable Rails/InverseOf
  belongs_to :editor,    class_name: 'User'

  # Returns the first inline image found in the posting's body as a Hash of attributes,
  # or nil if no image is found. Uses a robust HTML parser instead of brittle string scans.
  #
  # Example return:
  # { 'src' => 'https://example.com/img.jpg', 'alt' => 'desc', 'data-image' => '...' }
  #
  # The "first" image preference:
  # - Prefer an <img> inside the first <figure> if present
  # - Otherwise, the first <img> in the fragment
  def first_inline_image
    return nil if body.blank?

    fragment = Nokogiri::HTML.fragment(body)
    img = fragment.at_css('figure img') || fragment.at_css('img')
    return nil if img&.[]('src').blank?

    { 'src' => img['src'], 'alt' => img['alt'], 'data-image' => img['data-image'] }.compact
  end

  # Backwards-compatibility shim for any existing callers.
  # Prefer using `first_inline_image` going forward.
  def article_with_image
    first_inline_image
  end
end
