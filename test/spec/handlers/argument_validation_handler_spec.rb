require File.dirname(__FILE__) + '/../spec_helper'


describe "Argument Validation Handler#action" do

  before(:each) do
    @handler = Server::Handlers::ArgumentValidationHandler.new 
  end
  
  def action
    @handler.action @request, @response
  end
 
end
 
