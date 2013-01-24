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
    let(:p) { ParentResource.create! }
    let(:c) { ChildResource.create!(:parent_resource => p) }

    it "collection_url derives nesting for you" do
      get :index, {:parent_resource_id => p.id}
      subject.send(:collection_url).should eq("http://test.host/parent_resources/#{p.id}/child_resources")
    end

    it "resource_url derives nesting for you" do
      get :index, {:parent_resource_id => p.id}
      subject.send(:resource_url, c).should eq("http://test.host/parent_resources/#{p.id}/child_resources/#{c.id}")
    end

    it "resource_url assumes the current resource and derives nesting for you" do
      get :edit, {:id => c.to_param, :parent_resource_id => p.id}
      subject.send(:resource_url).should eq("http://test.host/parent_resources/#{p.id}/child_resources/#{c.id}")
    end

    it "new_resource_url derives nesting for you" do
      get :index, {:parent_resource_id => p.id}
      subject.send(:new_resource_url).should eq("http://test.host/parent_resources/#{p.id}/child_resources/new")
    end

    it "edit_resource_url derives nesting for you" do
      get :index, {:parent_resource_id => p.id}
      subject.send(:edit_resource_url, c).should eq("http://test.host/parent_resources/#{p.id}/child_resources/#{c.id}/edit")
    end

    it "edit_resource_url assumes the current resource and derives nesting for you" do
      get :show, {:id => c.to_param, :parent_resource_id => p.id}
      subject.send(:edit_resource_url).should eq("http://test.host/parent_resources/#{p.id}/child_resources/#{c.id}/edit")
    end
  end
end

describe ParentResourcesController do
  describe 'url helpers' do
    let(:ggp) { GreatGrandparentResource.create! }
    let(:gp)  { GrandparentResource.create!(:great_grandparent_resource => ggp) }
    let(:p)   { ParentResource.create!(:grandparent_resource => gp) }

    it "collection_url derives nesting for you" do
      get :index, {:grandparent_resource_id => gp.id, :great_grandparent_resource_id => ggp.id}
      subject.send(:collection_url).should eq("http://test.host/great_grandparent_resources/#{ggp.id}/grandparent_resources/#{gp.id}/parent_resources")
    end

    it "resource_url derives nesting for you" do
      get :index, {:grandparent_resource_id => gp.id, :great_grandparent_resource_id => ggp.id}
      subject.send(:resource_url, p).should eq("http://test.host/great_grandparent_resources/#{ggp.id}/grandparent_resources/#{gp.id}/parent_resources/#{p.id}")
    end

    it "resource_url assumes the current resource and derives nesting for you" do
      get :edit, {:id => p.id, :grandparent_resource_id => gp.id, :great_grandparent_resource_id => ggp.id}
      subject.send(:resource_url).should eq("http://test.host/great_grandparent_resources/#{ggp.id}/grandparent_resources/#{gp.id}/parent_resources/#{p.id}")
    end

    it "new_resource_url derives nesting for you" do
      get :index, {:grandparent_resource_id => gp.id, :great_grandparent_resource_id => ggp.id}
      subject.send(:new_resource_url).should eq("http://test.host/great_grandparent_resources/#{ggp.id}/grandparent_resources/#{gp.id}/parent_resources/new")
    end

    it "edit_resource_url derives nesting for you" do
      get :index, {:grandparent_resource_id => gp.id, :great_grandparent_resource_id => ggp.id}
      subject.send(:edit_resource_url, p).should eq("http://test.host/great_grandparent_resources/#{ggp.id}/grandparent_resources/#{gp.id}/parent_resources/#{p.id}/edit")
    end

    it "edit_resource_url assumes the current resource and derives nesting for you" do
      get :show, {:id => p.id, :grandparent_resource_id => gp.id, :great_grandparent_resource_id => ggp.id}
      subject.send(:edit_resource_url).should eq("http://test.host/great_grandparent_resources/#{ggp.id}/grandparent_resources/#{gp.id}/parent_resources/#{p.id}/edit")
    end
  end
end
