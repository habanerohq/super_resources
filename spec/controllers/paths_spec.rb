require 'spec_helper'

describe SimpleResourcesController do
  describe 'path helpers' do
    it "collection_path derives path for you" do
      get :index
      subject.send(:collection_path).should eq('http://test.host/simple_resources')
    end

    it "resource_path derives path for you" do
      r = SimpleResource.create!
      get :index
      subject.send(:resource_path, r).should eq("http://test.host/simple_resources/#{r.id}")
    end

    it "resource_path assumes the current resource and derives path for you" do
      r = SimpleResource.create!
      get :edit, {:id => r.to_param}
      subject.send(:resource_path).should eq("http://test.host/simple_resources/#{r.id}")
    end

    it "new_resource_path derives path for you" do
      get :index
      subject.send(:new_resource_path).should eq('http://test.host/simple_resources/new')
    end

    it "edit_resource_path derives path for you" do
      r = SimpleResource.create!
      get :index
      subject.send(:edit_resource_path, r).should eq("http://test.host/simple_resources/#{r.id}/edit")
    end

    it "edit_resource_path assumes the current resource and derives path for you" do
      r = SimpleResource.create!
      get :show, {:id => r.to_param}
      subject.send(:edit_resource_path).should eq("http://test.host/simple_resources/#{r.id}/edit")
    end
  end
end

describe ChildResourcesController do
  describe 'path helpers' do
    it "collection_path derives nested path for you" do
      p = ParentResource.create!
      get :index, {:parent_resource_id => p.id}
      subject.send(:collection_path).should eq('http://test.host/parent_resources')
    end

    it "resource_path derives nested path for you" do
      pending
      r = ParentResource.create!
      get :index
      subject.send(:resource_path, r).should eq("http://test.host/parent_resources/#{r.id}")
    end

    it "resource_path assumes the current resource and derives nested path for you" do
      pending
      r = ParentResource.create!
      get :edit, {:id => r.to_param}
      subject.send(:resource_path).should eq("http://test.host/parent_resources/#{r.id}")
    end

    it "new_resource_path derives nested path for you" do
      pending
      get :index
      subject.send(:new_resource_path).should eq('http://test.host/parent_resources/new')
    end

    it "edit_resource_path derives nested path for you" do
      pending
      r = ParentResource.create!
      get :index
      subject.send(:edit_resource_path, r).should eq("http://test.host/parent_resources/#{r.id}/edit")
    end

    it "edit_resource_path assumes the current resource and derives nested path for you" do
      pending
      r = ParentResource.create!
      get :show, {:id => r.to_param}
      subject.send(:edit_resource_path).should eq("http://test.host/parent_resources/#{r.id}/edit")
    end
  end
end
