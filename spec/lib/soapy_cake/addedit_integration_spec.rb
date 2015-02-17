RSpec.describe 'ADDEDIT integration test' do
  subject { SoapyCake::AdminAddedit.new }

  let(:advertiser_id) { 15886 }
  let(:vertical_id) { 41 }
  let(:offer_id) { 8910 }
  let(:offer_contract_id) { 1456 }
  let(:tier_id) { 4 }

  describe 'offers' do
    it 'creates an offer', :vcr do
      result = subject.add_offer(
        hidden: false,
        offer_status_id: SoapyCake::Const::OFFER_STATUS_PUBLIC,
        offer_type_id: SoapyCake::Const::OFFER_TYPE_3RD_PARTY,
        currency_id: SoapyCake::Const::CURRENCY_EUR,
        ssl: false,
        click_cookie_days: 30,
        impression_cookie_days: 30,
        redirect_404: 'off',
        enable_view_thru_conversion: 'off',
        click_trumps_impression: 'off',
        disable_click_deduplication: 'off',
        last_touch: 'off',
        enable_transaction_id_deduplication: 'off',
        postbacks_only: 'off',
        fire_global_pixel: 'on',
        fire_pixel_on_nonpaid_conversions: 'off',
        offer_link: 'http://www.example.com/',
        thankyou_link: 'http://www.example.com/',
        from_lines: 'from',
        subject_lines: 'subject',

        advertiser_id: advertiser_id,
        vertical_id: vertical_id,
        postback_url_ms_delay: 60,
        offer_contract_hidden: false,
        price_format_id: SoapyCake::Const::PRICE_FORMAT_CPA,
        received: 2.0,
        received_percentage: false,
        payout: 1.5,

        tags: '',
        offer_name: 'Test Offer',
        offer_description: 'TEST1',
        restrictions: 'TEST2',
        advertiser_extended_terms: 'TEST3',
        testing_instructions: 'TEST4'
      )

      expect(result).to include(
        creative_id: 9431,
        offer_contract_id: 1455,
        offer_id: 8910
      )
    end

    it 'updates an offer', :vcr do
      result = subject.edit_offer(
        offer_id: offer_id,

        advertiser_id: advertiser_id,
        vertical_id: vertical_id,
        postback_url_ms_delay: 50,
        offer_contract_hidden: false,
        price_format_id: SoapyCake::Const::PRICE_FORMAT_CPA,
        received: 2.0,
        received_percentage: false,
        payout: 1.5,
        tags: ''
      )

      expect(result).to include(offer_id: offer_id)
    end

    context 'errors' do
      it 'fails when not enough params are given' do
        expect do
          subject.edit_offer(offer_id: 123)
        end.to raise_error(RuntimeError, "Parameter 'advertiser_id' missing!")
      end

      it 'fails when invalid offer_id is given on edit' do
        expect do
          subject.edit_offer(offer_id: -1)
        end.to raise_error(RuntimeError, 'offer_id must be > 0')
      end
    end
  end

  describe 'offer contracts' do
    it 'creates an offer contract', :vcr do
      result = subject.add_offer_contract(
        offer_id: offer_id,
        offer_contract_name: 'Test Contract',
        price_format_id: SoapyCake::Const::PRICE_FORMAT_CPA,
        received: 3.2,
        received_percentage: false,
        payout: 2.5,
        offer_link: 'http://oc.example.com',
        thankyou_link: 'http://oc.example.com/thanks',
        offer_contract_hidden: true,
        offer_contract_is_default: false,
        use_fallback_targeting: true
      )

      expect(result).to include(offer_contract_id: 1456)
    end

    it 'updates an offer contract', :vcr do
      result = subject.edit_offer_contract(
        offer_id: offer_id,
        offer_contract_id: offer_contract_id,
        offer_contract_name: 'Test Contract',
        price_format_id: SoapyCake::Const::PRICE_FORMAT_CPA,
        received: 3.2,
        received_percentage: false,
        payout: 2.5,
        offer_link: 'http://oc.example.com',
        thankyou_link: 'http://oc.example.com/thanks',
        offer_contract_hidden: true,
        offer_contract_is_default: false,
        use_fallback_targeting: true
      )

      expect(result).to include(offer_contract_id: 1456)
    end

    context 'errors' do
      it 'fails when not enough params are given' do
        expect do
          subject.edit_offer_contract(offer_contract_id: 123)
        end.to raise_error(RuntimeError, "Parameter 'offer_id' missing!")
      end

      it 'fails when invalid offer_id is given on edit' do
        expect do
          subject.edit_offer_contract(offer_contract_id: -1)
        end.to raise_error(RuntimeError, 'offer_contract_id must be > 0')
      end
    end
  end

  describe 'offer / offer contract caps' do
    it 'updates a cap for an offer contract', :vcr do
      result = subject.update_caps(
        offer_contract_id: offer_contract_id,
        cap_type_id: SoapyCake::Const::CAP_TYPE_CONVERSION,
        cap_interval_id: SoapyCake::Const::CAP_INTERVAL_DAILY,
        cap_amount: 42,
        send_alert_only: false
      )

      expect(result[:message]).to eq('Cap Updated')
    end

    it 'removes a cap for an offer contract', :vcr do
      result = subject.update_caps(
        offer_contract_id: offer_contract_id,
        cap_type_id: SoapyCake::Const::CAP_TYPE_CONVERSION,
        cap_interval_id: SoapyCake::Const::CAP_INTERVAL_DISABLED,
        cap_amount: 42,
        send_alert_only: false
      )

      expect(result[:message]).to eq('Cap Updated')
    end
  end

  describe 'offer tiers' do
    it 'adds an offer tier', :vcr do
      result = subject.add_offer_tier(
        offer_id: offer_id,
        offer_contract_id: offer_contract_id,
        tier_id: tier_id,
        price_format_id: SoapyCake::Const::PRICE_FORMAT_CPA,
        status_id: SoapyCake::Const::OFFER_STATUS_PUBLIC
      )

      expect(result[:message]).to eq('Offer Tier Added')
    end
  end
end
