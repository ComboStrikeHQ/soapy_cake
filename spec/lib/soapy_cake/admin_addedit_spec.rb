# frozen_string_literal: true

RSpec.describe SoapyCake::AdminAddedit do
  subject(:admin_addedit) { described_class.new }

  before do
    # rubocop:disable RSpec/SubjectStub
    allow(admin_addedit).to receive(:run).and_return({})
    # rubocop:enable RSpec/SubjectStub
  end

  describe '#edit_offer' do
    let(:offer_params) do
      {
        offer_id: 12,
        advertiser_id: 1,
        vertical_id: 1,
        postback_url_ms_delay: 0,
        offer_contract_hidden: true,
        price_format_id: :cpa,
        received: 0,
        received_percentage: 0,
        payout: 0,
        tags: 'new-tag'
      }
    end

    it 'keeps existing tags' do
      expect(SoapyCake::Request).to receive(:new).with(
        :admin,
        :addedit,
        :offer,
        hash_including(tags: 'new-tag', tags_modification_type: 'add')
      )

      admin_addedit.edit_offer(offer_params)
    end

    it 'allows replacing tags' do
      expect(SoapyCake::Request).to receive(:new).with(
        :admin,
        :addedit,
        :offer,
        hash_including(tags: 'new-tag', tags_modification_type: 'replace')
      )

      admin_addedit.edit_offer(offer_params.merge(tags_replace: true))
    end
  end

  describe '#add_offer' do
    let(:offer_params) do
      {
        offer_name: 'Test',
        hidden: true,
        offer_status_id: :public,
        offer_type_id: :third_party,
        currency_id: :eur,
        ssl: true,
        click_cookie_days: 1,
        impression_cookie_days: 1,
        redirect_404: true,
        enable_view_thru_conversions: true,
        click_trumps_impression: true,
        disable_click_deduplication: false,
        last_touch: true,
        enable_transaction_id_deduplication: true,
        postbacks_only: false,
        fire_global_pixel: true,
        fire_pixel_on_non_paid_conversions: false,
        offer_link: 'http://www.ree.com',
        thankyou_link: 'http://www.www.ww',
        from_lines: '',
        subject_lines: '',
        advertiser_id: 1,
        vertical_id: 1,
        postback_url_ms_delay: 0,
        offer_contract_hidden: false,
        price_format_id: :cpa,
        received: 4,
        received_percentage: false,
        payout: 4
      }
    end

    it 'always adds on creation' do
      expect(SoapyCake::Request).to receive(:new).with(
        :admin,
        :addedit,
        :offer,
        hash_including(tags: 'tag', tags_modification_type: 'add')
      )

      admin_addedit.add_offer(offer_params.merge(tags: 'tag', tags_replace: true))
    end
  end

  describe '#edit_geo_targets' do
    let(:base_opts) do
      {
        offer_contract_id: 1,
        allow_countries: true,
        countries: %w[DE]
      }
    end

    it 'replaces the existing config by default' do
      expect(SoapyCake::Request).to receive(:new).with(
        :admin,
        :addedit,
        :geo_targets,
        hash_including(add_edit_option: 'replace')
      )

      admin_addedit.edit_geo_targets(base_opts)
    end

    it 'allows to override the add_edit_option' do
      expect(SoapyCake::Request).to receive(:new).with(
        :admin,
        :addedit,
        :geo_targets,
        hash_including(add_edit_option: 'add')
      )

      admin_addedit.edit_geo_targets(base_opts.merge(add_edit_option: 'add'))
    end

    it 'does not mutate the passed options' do
      allow(SoapyCake::Request).to receive(:new)

      opts_before = base_opts.dup
      admin_addedit.edit_geo_targets(base_opts)
      expect(base_opts).to eq(opts_before)
    end
  end

  describe '#add_geo_targets' do
    let(:base_opts) do
      {
        offer_contract_id: 1,
        allow_countries: true,
        countries: %w[DE]
      }
    end

    it 'adds geo targets' do
      expect(SoapyCake::Request).to receive(:new).with(
        :admin,
        :addedit,
        :geo_targets,
        hash_including(add_edit_option: 'add')
      )

      admin_addedit.add_geo_targets(base_opts)
    end
  end

  describe '#create_creative' do
    context 'when no offer id was passed' do
      it 'raises an error' do
        expect { admin_addedit.create_creative({}) }.to raise_error(
          'need offer_id to create creative'
        )
      end
    end

    context 'when creative id was passed' do
      it 'raises an error' do
        expect do
          admin_addedit.create_creative(offer_id: 10, creative_id: 11)
        end.to raise_error('cannot pass creative_id when creating creative')
      end
    end

    context 'when given the right parameters' do
      it 'creates a creative and adds a file to it' do
        expect(SoapyCake::Request).to receive(:new).with(
          :admin,
          :addedit,
          :creative,
          creative_name: 'creative_name',
          creative_status_id: 1,
          creative_type_id: 3,
          height: 0,
          notes: '',
          offer_link: '',
          third_party_name: '',
          width: 0,
          offer_id: 10
        ).and_call_original

        expect(SoapyCake::Request).to receive(:new).with(
          :admin,
          :addedit,
          :creative_files,
          creative_file_import_url: 'http://www.example.org/image.png',
          creative_id: nil
        ).and_call_original

        admin_addedit.create_creative(
          offer_id: 10,
          creative_name: 'creative_name',
          creative_file_import_url: 'http://www.example.org/image.png'
        )
      end
    end
  end
end
