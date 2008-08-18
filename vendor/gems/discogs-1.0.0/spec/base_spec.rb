require File.dirname(__FILE__) + '/spec_helper'

describe Discogs::Base do
  before do
    artist_file = File.join(File.dirname(__FILE__), 'fixtures', 'artist.xml')
    @artist_data = File.read(artist_file)
  end

  it "obtains xml data via open-uri and zlib" do
    base = Discogs::Base.new('Broken Social Scene')
    mock_reader = mock('Zlib::GzipReader')
    Zlib::GzipReader.should_receive(:new).and_return(mock_reader)
    mock_reader.should_receive(:read).and_return(@artist_data)
    mock_reader.should_receive(:close)
    base.send(:fetched)
  end

  it "finds the api_key from a yaml file" do
    base = Discogs::Base.new
    YAML.should_receive(:load).and_return({:api_key => '1234'})
    base.send(:load_api_key).should eql('1234')
  end
end
