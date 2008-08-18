require File.dirname(__FILE__) + '/spec_helper'

describe Discogs::Artist do
  before do
    @release = Discogs::Release.new('188365')
  end

  describe "getters" do
    before do
      release_file = File.join(File.dirname(__FILE__), 'fixtures', 'release.xml')
      @release_data = File.read(release_file)
      @release.should_receive(:fetched).and_return(@release_data)
    end

    it "returns discog_status from xml" do
      @release.discog_status.should eql('Accepted')
    end

    it "returns title from xml" do
      @release.title.should eql('Feel Good Lost')
    end

    it "returns labels from xml" do
      @release.labels.should eql(["Noise Factory Records"])
    end

    it "returns genres from xml" do
      @release.genres.should eql(['Rock'])
    end

    it "returns styles from xml" do
      @release.styles.should eql(['Indie Rock', 'Experimental'])
    end

    it "returns country from xml" do
      @release.country.should eql('Canada')
    end

    it "returns release date from xml" do
      @release.released.should eql('2001')
    end

    it "returns formats from xml" do
      mock_format = mock('Format')
      Discogs::Format.should_receive(:new).and_return(mock_format)
      @release.formats.should eql([mock_format])
    end

    it "returns tracks from xml" do
      mock_track = mock('Track')
      Discogs::Track.should_receive(:new).at_least(12).times.and_return(mock_track)
      @release.tracks.should eql([mock_track]*12)
    end

    it "returns images from xml" do
      mock_image = mock('Image')
      Discogs::Image.should_receive(:new).and_return(mock_image)
      @release.images.should eql([mock_image])
    end

    it "returns contributors from xml" do
      mock_contributor = mock('Contributor')
      Discogs::Contributor.should_receive(:new).at_least(7).times.and_return(mock_contributor)
      @release.contributors.should eql([mock_contributor]*7)
    end
  end

  it "constructs a url for release request" do
    @release.api_key = 'foo'
    @release.discog_id = '1234'
    @release.send(:request_url).should eql('http://www.discogs.com/release/1234?f=xml&api_key=foo')
  end

end
