# frozen_string_literal: true

require 'rails_helper'
# I'd add FactoryGirl instances for every case with traits
# to call let(:posting_with_figure) { FactoryGirl.create(:posting, :with_figure) }
# let(:posting_without_figure) { FactoryGirl.create(:posting, :without_figure) }
# etc

RSpec.describe Posting, type: :model do
  describe '.article_with_image' do
    let(:posting_body) { "<p>Hi dear community members,</p>\r\n<p><strong>Spotlight #3</strong>"\
                    "is our latest bi-weekly community digest for you. It covers Cybersecurity, "\
                    "IT and DevOps topics<strong>. </strong>Check it out, join discussions and share "\
                    "your feedback below<strong>!</strong></p>\r\n<figure><img src=\"https://images."\
                    "peerspot.com/image/upload/c_limit,f_auto,q_auto,w_550/bvvrzbv97pp5srg612"\
                    "le16pv99rg.jpg\" data-image=\"27c79574-7aa7-4eea-8515-d2a128698803.jpg\" alt=\"Spotlight"\
                    " #3 - a community digest\"></figure>\r\n<p><strong><br></strong></p>\r\n<h2>Trending"\
                    "</h2>\r\n<ul>\r\n<li><a target=\"_blank\" href=\"https://www.peerspot.com/quest"\
                    "ions/looking-for-an-identity-and-access-management-product-for-an-energy-and-utility-organ"\
                    "ization\">Looking for an Identity and Access Management product for an energy and utility organization</a></li>"}

    let(:response ) {
      'alt' => 'Spotlight #3 - a community digest',
      'src' => 'https://images.peerspot.com/image/upload/c_limit,f_auto,q_auto,w_550/bvvrzbv97pp5srg612le16pv99rg.jpg',
      'data-image' => '27c79574-7aa7-4eea-8515-d2a128698803.jpg'
    }

    let(:posting) { insert :posting, body: posting_body, type: 'Article' }

    it 'should be an Article model' do
      expect(posting.type).to eq('Article')
      expect(posting.body).to eq(posting_body)
    end

    it 'should return image attributes from body' do
      expect(posting.article_with_image).to eq(response)
    end

    context 'posting type is Article' do
      context 'both figure tags present' do
        it 'returns common string' do
          expect(posting.article_with_image).to eq "#{figure_start}_#{figure_end}"
          # here we need to prepare posting_body with any of figure tags
        end

        context 'img tag presents' do
          it 'calls ImageExtractor' do
          end
        end

        context "img tag doesn\'t present" do
          it 'returns not include <img' do
          end
        end
      end

      context 'any of figure tag is not present' do
        it 'returns common string' do
          expect(posting.article_with_image).to eq "#{figure_start}_#{figure_end}"
          # here we need to prepare posting_body without any of figure tags
        end
      end
    end

    context 'posting type is not Article' do
      it 'returns type' do
      end
    end
  end
end