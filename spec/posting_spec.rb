# frozen_string_literal: true


# Only one test, lets add another tests with other test cases and refactor existing

require 'spec_helper'

RSpec.describe Posting, type: :model do
  describe '.article_with_image' do

    let(:posting) { insert :posting, body: posting_body, type: 'Article' }
    let(:posting_body) do
        "<p>Hi dear community members,</p>\r\n<p><strong>Spotlight #3</strong>"\
        "is our latest bi-weekly community digest for you. It covers Cybersecurity, "\
        "IT and DevOps topics<strong>. </strong>Check it out, join discussions and share "\
        "your feedback below<strong>!</strong></p>\r\n#{figure_tag}\r\n<p><strong><br></strong></p>\r\n<h2>Trending"\
        "</h2>\r\n<ul>\r\n<li><a target=\"_blank\" href=\"https://www.peerspot.com/quest"\
        "ions/looking-for-an-identity-and-access-management-product-for-an-energy-and-utility-organ"\
        "ization\">Looking for an Identity and Access Management product for an energy and utility organization</a></li>"
      end

    context 'when posting body has image inside figure' do
      let(:figure_tag) do # Changed figure tag to have alt attribute to test if function filters it
        "<figure alt=\"Figure\"><img src=\"https://images."\
        "peerspot.com/image/upload/c_limit,f_auto,q_auto,w_550/bvvrzbv97pp5srg612"\
        "le16pv99rg.jpg\" data-image=\"27c79574-7aa7-4eea-8515-d2a128698803.jpg\" alt=\"Spotlight"\
        " #3 - a community digest\"></figure>"
      end

      let(:expected_response) do
        {
          'alt' => 'Spotlight #3 - a community digest',
          'src' => 'https://images.peerspot.com/image/upload/c_limit,f_auto,q_auto,w_550/bvvrzbv97pp5srg612le16pv99rg.jpg',
          'data-image' => '27c79574-7aa7-4eea-8515-d2a128698803.jpg'
        }
      end

      # useless test, is not a part of article_with_image function test
      # it 'should be an Article model' do
      #   expect(posting.type).to eq('Article')
      #   expect(posting.body).to eq(posting_body)
      # end

      it 'returns image attributes from body' do
        expect(posting.article_with_image).to eq(expected_response)
      end
    end

    context 'when posting body does not have image inside figure' do
      let(:figure_tag) { "<figure><p>Blank</p></figure>" }

      it 'returns blanks hash whe no image tag' do
        expect(posting.article_with_image).to be_nil
      end
    end

    context 'when posting body does not have figure inside' do
      let(:figure_tag) { "" }

      it 'returns blanks hash whe no figure tag' do
        expect(posting.article_with_image).to be_nil
      end
    end
  end
end
