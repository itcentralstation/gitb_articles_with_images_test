# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Posting, type: :model do
  describe '#first_inline_image' do
    let(:user) { create(:user) }

    context 'when body is nil or empty' do
      it 'returns nil for nil body' do
        posting = create(:posting, body: nil, user: user, editor: user)
        expect(posting.first_inline_image).to be_nil
      end

      it 'returns nil for empty body' do
        posting = create(:posting, body: '', user: user, editor: user)
        expect(posting.first_inline_image).to be_nil
      end
    end

    context 'when body has no images' do
      it 'returns nil' do
        posting = create(:posting, body: '<p>Hello world</p>', user: user, editor: user)
        expect(posting.first_inline_image).to be_nil
      end
    end

    context 'when body includes an image inside a figure' do
      it 'returns the first figure image attributes' do
        html = '<p>Intro</p>' \
               '<figure><img src="https://img/1.jpg" alt="one" data-image="A"></figure>' \
               '<figure><img src="https://img/2.jpg" alt="two"></figure>'
        posting = create(:posting, body: html, user: user, editor: user)
        expect(posting.first_inline_image).to eq(
          { 'src' => 'https://img/1.jpg', 'alt' => 'one', 'data-image' => 'A' }
        )
      end
    end

    context 'when body includes multiple images but first figure appears after a loose img' do
      it 'prefers the image in a figure first' do
        html = '<p>Intro</p>' \
               '<img src="https://img/loose.jpg" alt="loose">' \
               '<figure><img src="https://img/figure.jpg" alt="fig"></figure>'
        posting = create(:posting, body: html, user: user, editor: user)
        expect(posting.first_inline_image).to eq(
          { 'src' => 'https://img/figure.jpg', 'alt' => 'fig' }
        )
      end
    end

    context 'when images are present but missing src' do
      it 'returns nil' do
        posting = create(:posting, body: '<figure><img alt="no src"></figure>', user: user, editor: user)
        expect(posting.first_inline_image).to be_nil
      end
    end

    context 'backwards compatibility: article_with_image' do
      it 'delegates to first_inline_image' do
        html = '<figure><img src="https://img/x.jpg" alt="x"></figure>'
        posting = create(:posting, body: html, user: user, editor: user)
        expect(posting.article_with_image).to eq(
          { 'src' => 'https://img/x.jpg', 'alt' => 'x' }
        )
      end
    end
  end

  describe '.article_with_image (existing contract example)' do
    posting_body =  "<p>Hi dear community members,</p>\r\n<p><strong>Spotlight #3</strong>" \
                    'is our latest bi-weekly community digest for you. It covers Cybersecurity, ' \
                    'IT and DevOps topics<strong>. </strong>Check it out, join discussions and share ' \
                    "your feedback below<strong>!</strong></p>\r\n<figure><img src=\"https://images." \
                    'peerspot.com/image/upload/c_limit,f_auto,q_auto,w_550/bvvrzbv97pp5srg612' \
                    'le16pv99rg.jpg" data-image="27c79574-7aa7-4eea-8515-d2a128698803.jpg" alt="Spotlight ' \
                    "#3 - a community digest\"></figure>\r\n<p><strong><br></strong></p>\r\n<h2>Trending" \
                    "</h2>\r\n<ul>\r\n<li><a target=\"_blank\" href=\"https://www.peerspot.com/quest" \
                    'ions/looking-for-an-identity-and-access-management-product-for-an-energy-and-utility-organ' \
                    'ization">Looking for an Identity and Access Management product for an energy and utility organization</a></li>'

    response = {
      'alt' => 'Spotlight #3 - a community digest',
      'src' => 'https://images.peerspot.com/image/upload/c_limit,f_auto,q_auto,w_550/bvvrzbv97pp5srg612le16pv99rg.jpg',
      'data-image' => '27c79574-7aa7-4eea-8515-d2a128698803.jpg'
    }

    it 'returns image attributes from body for a typical article body' do
      posting = create(:posting, body: posting_body, type: 'Article')
      expect(posting.type).to eq('Article')
      expect(posting.body).to eq(posting_body)
      expect(posting.article_with_image).to eq(response)
    end
  end
end
