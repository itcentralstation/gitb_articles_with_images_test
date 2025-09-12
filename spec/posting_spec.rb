# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Posting, type: :model do
  describe '.article_with_image' do
    # posting body should go to Fixtures or Factories
    posting_body =  "<p>Hi dear community members,</p>\r\n<p><strong>Spotlight #3</strong>"\
                    "is our latest bi-weekly community digest for you. It covers Cybersecurity, "\
                    "IT and DevOps topics<strong>. </strong>Check it out, join discussions and share "\
                    "your feedback below<strong>!</strong></p>\r\n<figure><img src=\"https://images."\
                    "peerspot.com/image/upload/c_limit,f_auto,q_auto,w_550/bvvrzbv97pp5srg612"\
                    "le16pv99rg.jpg\" data-image=\"27c79574-7aa7-4eea-8515-d2a128698803.jpg\" alt=\"Spotlight"\
                    " #3 - a community digest\"></figure>\r\n<p><strong><br></strong></p>\r\n<h2>Trending"\
                    "</h2>\r\n<ul>\r\n<li><a target=\"_blank\" href=\"https://www.peerspot.com/quest"\
                    "ions/looking-for-an-identity-and-access-management-product-for-an-energy-and-utility-organ"\
                    "ization\">Looking for an Identity and Access Management product for an energy and utility organization</a></li>"

    response = {
      'alt' => 'Spotlight #3 - a community digest',
      'src' => 'https://images.peerspot.com/image/upload/c_limit,f_auto,q_auto,w_550/bvvrzbv97pp5srg612le16pv99rg.jpg',
      'data-image' => '27c79574-7aa7-4eea-8515-d2a128698803.jpg'
    }

    let(:posting) { insert :posting, body: posting_body, type: 'Article' }

    # we should test here different scenarious:
    # 1. successfull search for the first image
    # 2. no image in an Article
    # 3. not an Article type
    # 4. incorrect body (missing closing figure tag etc.)
    # 5. few images in a body, returning only the first one.
    it 'should be an Article model' do
      expect(posting.type).to eq('Article')
      expect(posting.body).to eq(posting_body)
    end
    it 'should return image attributes from body' do
      expect(posting.article_with_image).to eq(response)
    end
  end
end