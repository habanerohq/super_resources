require 'spec_helper'

describe SimpleResourcesController do
  describe 'resource class method' do
    it "answers the resource class through a standard resource_class method" do
      get :index
      subject.send(:resource_class).should eq(SimpleResource)
    end
  end

  describe 'individual and collection methods' do
    it "answers the resource through a standard resource method" do
      r = SimpleResource.create!
      get :show, {:id => r.to_param}
      subject.send(:resource).should eq(r)
    end

    it "answers the the name of the resource's input param hash name " do
      subject.send(:resource_params_name).should eq(:simple_resource)
    end

    it "answers a collection of resources through collection method" do
      r = SimpleResource.create!
      get :index, {:id => r.to_param}
      subject.send(:collection).should eq([r])
    end
  end

  describe 'finding resourcess' do
    it "finds resources by a default finder when no override is given" do
      get :index
      subject.send(:finder_method).should eq(:find)
    end
  end
end
