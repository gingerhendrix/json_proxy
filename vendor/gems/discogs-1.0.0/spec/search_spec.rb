require File.dirname(__FILE__) + '/spec_helper'

describe Discogs::Search do
  before do
    search_file = File.join(File.dirname(__FILE__), 'fixtures', 'search.xml')
    @search_data = File.read(search_file)
    @search = Discogs::Search.new('macha')
    @search.should_receive(:fetched).and_return(@search_data)
  end

  it "returns exact results " do
    mock_result = mock('SearchResult')
    Discogs::SearchResult.should_receive(:new).at_least(3).times.and_return(mock_result)
    @search.exactresults.should eql([mock_result]*3)
  end

  it "returns fuzzy results" do
    mock_result = mock('SearchResult')
    Discogs::SearchResult.should_receive(:new).at_least(20).times.and_return(mock_result)
    @search.results.should eql([mock_result]*20)
  end

  it "returns exact result size" do
    @search.exactresult_size.should eql(3)
  end

  it "returns fuzzy result size" do
    @search.result_size.should eql(20)
  end
end
