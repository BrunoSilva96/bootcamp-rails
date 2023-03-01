require "rails_helper"

describe Admin::ModelLoadingService do
  context "when #call" do
    let!(:system_requirement) { create_list(:system_requirement, 15) }
    
    context "when params are present" do
      let!(:search_system_requirement) do
        system_requirement = []
        15.times { |n| system_requirement << create(:system_requirement, name: "Search #{n + 1}", video_board: "GeForce") }
        system_requirement
      end

      let!(:unexpected_system_requirement) do
        system_requirement = []
        15.times { |n| system_requirement << create(:system_requirement, name: "Search0 #{n + 1}") }
        system_requirement
      end

      let(:params) do
        { search: { name: "Search", video_board: "GeFor" }, order: { name: :desc }, page: 2, length: 4 }
      end

      it "performs right :length following pagination" do
        service = described_class.new(SystemRequirement.all, params)
        service.call
        expect(service.records.count).to eq 4
      end

      it "do right search, order and pagination" do
        search_system_requirement.sort! { |a, b| b[:name] <=> a[:name] }
        service = described_class.new(SystemRequirement.all, params)
        service.call
        expected_system_required = search_system_requirement[4..7]
        expect(service.records).to contain_exactly *expected_system_required
      end

      it "sets right :page" do
        service = described_class.new(SystemRequirement.all, params)
        service.call
        expect(service.pagination[:page]).to eq 2
      end

      it "sets right :length" do
        service = described_class.new(SystemRequirement.all, params)
        service.call
        expect(service.pagination[:length]).to eq 4
      end

      it "sets right :total" do
        service = described_class.new(SystemRequirement.all, params)
        service.call
        expect(service.pagination[:total]).to eq 15
      end

      it "sets right :total_pages" do
        service = described_class.new(SystemRequirement.all, params)
        service.call
        expect(service.pagination[:total_pages]).to eq 4
      end

      it "does not return unexpected records" do
        params.merge!(page: 1, length: 50)
        service = described_class.new(SystemRequirement.all, params)
        service.call
        expect(service.records).to_not include *unexpected_system_requirement
      end
    end

    context "when params are not present" do
      it "returns default :length pagination" do
        service = described_class.new(SystemRequirement.all, nil)
        service.call
        expect(service.records.count).to eq 10
      end

      it "returns first 10 records" do
        service = described_class.new(SystemRequirement.all, nil)
        service.call
        expected_system_required = system_requirement[0..9]
        expect(service.records).to contain_exactly *expected_system_required
      end

      it "sets right :page" do
        service = described_class.new(SystemRequirement.all, nil)
        service.call
        expect(service.pagination[:page]).to eq 1
      end

      it "sets right :length" do
        service = described_class.new(SystemRequirement.all, nil)
        service.call
        expect(service.pagination[:length]).to eq 10
      end

      it "sets right :total" do
        service = described_class.new(SystemRequirement.all, nil)
        service.call
        expect(service.pagination[:total]).to eq 15
      end

      it "sets right :total_pages" do
        service = described_class.new(SystemRequirement.all, nil)
        service.call
        expect(service.pagination[:total_pages]).to eq 2
      end
    end
  end
end