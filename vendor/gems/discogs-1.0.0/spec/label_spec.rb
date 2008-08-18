require File.dirname(__FILE__) + '/spec_helper'

describe Discogs::Label do
  before do
    label_file = File.join(File.dirname(__FILE__), 'fixtures', 'label.xml')
    @label_data = File.read(label_file)
    @label = Discogs::Label.new('Noise Factory Records')
    @label.should_receive(:fetched).and_return(@label_data)
  end

  it "returns name from xml" do
    @label.name.should eql('Noise Factory Records')
  end

  it "returns images from xml" do
    mock_image = mock('Image')
    Discogs::Image.should_receive(:new).and_return(mock_image)
    @label.images.should eql([mock_image])
  end

  it "returns contact_info from xml" do
    @label.contact_info.should eql("Tel: 416 787 3330\nFax: 416 787 3326\n\ninfo@noisefactoryrecords.com\n")
  end

  it "returns profile from xml" do
    @label.profile.should eql('Toronto based indie &amp;amp; electronic label.')
  end

  it "returns urls from xml" do
    @label.urls.should eql(["http://www.noisefactoryrecords.com/"])
  end

  it "returns parent from xml" do
    label = Discogs::Label.should_not_receive(:new)
    @label.parent.should be_nil
  end

  it "returns sublabels from xml" do
    label = Discogs::Label.should_not_receive(:new)
    @label.sublabels.should be_empty
  end

  it "returns releases from xml" do
    mock_release = mock('Release')
    Discogs::Release.should_receive(:new).at_least(22).times.and_return(mock_release)
    @label.releases.should eql([mock_release]*22)
  end

end
