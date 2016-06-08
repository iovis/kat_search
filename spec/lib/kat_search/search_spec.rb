require 'spec_helper'

describe KatSearch::Search do
  subject { build :search }
  let(:search_failed) { build :search_failed }
  let(:url) { 'https://kat.cr/usearch/suits%20s05e16/' }
  let(:url_failed) { 'https://kat.cr/usearch/suits%20s05e72/' }

  before(:each) do
    stub_request(:get, url).to_return File.new('spec/http_stubs/kat_successful_search.http')
    stub_request(:get, url_failed).to_return File.new('spec/http_stubs/kat_failed_search.http')
  end

  it 'generates the search url' do
    expect(subject.url).to eq(url)
  end

  context '#results_found?' do
    it 'is true if results are found' do
      expect(subject.results_found?).to be_truthy
    end

    it 'is false if no results are found' do
      expect(search_failed.results_found?).to be_falsy
    end
  end

  context '#links' do
    it "generates #{KatSearch::Search::NUMBER_OF_LINKS} links" do
      expect(subject.links.size).to eq(KatSearch::Search::NUMBER_OF_LINKS)
    end

    it 'generates Link instances' do
      expect(subject.links).to all(be_a(KatSearch::Link))
    end

    it 'returns an empty list if no results found' do
      expect(search_failed.links).to eq([])
    end
  end
end
