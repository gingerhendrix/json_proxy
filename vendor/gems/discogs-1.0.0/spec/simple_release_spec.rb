
require File.dirname(__FILE__) + '/spec_helper'

describe Discogs::SimpleRelease do
  before do
    @release = Discogs::SimpleRelease.new '188365', {
                :title => 'title', 
                :label => 'label', 
                :format => 'format', 
                :year => 'year',
                :discog_status => 'discog_status',
                :discog_type => 'discog_type',
                :trackinfo => 'trackinfo'
              }
  end

  describe "getters" do
   
    it "returns discog_id from initial params" do
      @release.discog_id.should eql('188365')
    end
    
    it "returns title from initial params" do
      @release.title.should eql('title')
    end

    it "returns label from initial params" do
      @release.label.should eql('label')
    end

    it "returns format from initial params" do
      @release.format.should eql('format')
    end

    it "returns year from initial params" do
      @release.year.should eql('year')
    end

    it "returns discog_type from initial params" do
      @release.discog_type.should eql('discog_type')
    end
    
    it "returns discog_status from initial params" do
      @release.discog_status.should eql('discog_status')
    end
    
    it "returns trackinfo from initial params" do
      @release.trackinfo.should eql('trackinfo')
    end
  
  end
  
end
