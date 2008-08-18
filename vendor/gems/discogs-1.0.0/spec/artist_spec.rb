require File.dirname(__FILE__) + '/spec_helper'

describe Discogs::Artist do
  before do
    artist_file = File.join(File.dirname(__FILE__), 'fixtures', 'artist.xml')
    @artist_data = File.read(artist_file)
    @artist = Discogs::Artist.new('Broken Social Scene')
    @artist.should_receive(:fetched).and_return(@artist_data)
  end

  it "returns name from xml data" do
    @artist.name.should eql('Broken Social Scene')
  end

  it "returns members from xml data" do
    @artist.members.should eql(["Amy Millan", "Andrew Whiteman", "Brendan Canning", "Charles Spearin", "David Newfeld", "Emily Haines", "Evan Cranley", "Feist", "James Shaw", "Jason Collett", "Jo-Ann Goldsmith", "John Crossingham", "Julie Penner", "Justin Peroff", "Kevin Drew", "Lisa Lobsinger", "Martin Davis Kinack", "Ohad Benchetrit", "Torquil Campbell"])
  end

  it "returns images from xml data" do
    mock_image = mock('image')
    Discogs::Image.should_receive(:new).twice.and_return(mock_image)
    @artist.images.should eql([mock_image, mock_image])
  end

  it "returns url from xml data" do
    @artist.urls.should eql(["http://www.arts-crafts.ca/bss/"])
  end

  it "returns releases from xml data" do
    mock_release = mock('release')
    Discogs::Release.should_receive(:new).at_least(59).times.and_return(mock_release)
    @artist.releases.should eql([mock_release]*59)
  end
end
