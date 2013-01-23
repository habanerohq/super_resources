require 'spec_helper'

describe SimpleResourcesController do
  describe 'url helpers' do
    it "collection_url derives for you" do
      get :index
      subject.send(:collection_url).should eq('http://test.host/simple_resources')
    end

    it "resource_url derives for you" do
      r = SimpleResource.create!
      get :index
      subject.send(:resource_url, r).should eq("http://test.host/simple_resources/#{r.id}")
    end

    it "resource_url assumes the current resource and derives for you" do
      r = SimpleResource.create!
      get :edit, {:id => r.to_param}
      subject.send(:resource_url).should eq("http://test.host/simple_resources/#{r.id}")
    end

    it "new_resource_url derives for you" do
      get :index
      subject.send(:new_resource_url).should eq('http://test.host/simple_resources/new')
    end

    it "edit_resource_url derives for you" do
      r = SimpleResource.create!
      get :index
      subject.send(:edit_resource_url, r).should eq("http://test.host/simple_resources/#{r.id}/edit")
    end

    it "edit_resource_url assumes the current resource and derives path for you" do
      r = SimpleResource.create!
      get :show, {:id => r.to_param}
      subject.send(:edit_resource_url).should eq("http://test.host/simple_resources/#{r.id}/edit")
    end
  end
end

describe ChildResourcesController do
  describe 'url helpers' do
    it "collection_url derives nesting for you" do
      p = ParentResource.create!
      get :index, {:parent_resource_id => p.id}
      subject.send(:collection_url).should eq("http://test.host/parent_resources/#{p.id}/child_resources")
    end

    it "resource_url derives nesting for you" do
      p = ParentResource.create!
      c = ChildResource.create!(:parent_resource => p)
      get :index, {:parent_resource_id => p.id}
      subject.send(:resource_url, c).should eq("http://test.host/parent_resources/#{p.id}/child_resources/#{c.id}")
    end

    it "resource_url assumes the current resource and derives nesting for you" do
      p = ParentResource.create!
      c = ChildResource.create!(:parent_resource => p)
      get :edit, {:id => c.to_param, :parent_resource_id => p.id}
      subject.send(:resource_url).should eq("http://test.host/parent_resources/#{p.id}/child_resources/#{c.id}")
    end

    it "new_resource_url derives nesting for you" do
      p = ParentResource.create!
      c = ChildResource.create!(:parent_resource => p)
      get :index, {:parent_resource_id => p.id}
      subject.send(:new_resource_url).should eq("http://test.host/parent_resources/#{p.id}/child_resources/new")
    end

    it "edit_resource_url derives nesting for you" do
      p = ParentResource.create!
      c = ChildResource.create!(:parent_resource => p)
      get :index, {:parent_resource_id => p.id}
      subject.send(:edit_resource_url, c).should eq("http://test.host/parent_resources/#{p.id}/child_resources/#{c.id}/edit")
    end

    it "edit_resource_url assumes the current resource and derives nesting for you" do
      p = ParentResource.create!
      c = ChildResource.create!(:parent_resource => p)
      get :show, {:id => c.to_param, :parent_resource_id => p.id}
      subject.send(:edit_resource_url).should eq("http://test.host/parent_resources/#{p.id}/child_resources/#{c.id}/edit")
    end
  end
end
