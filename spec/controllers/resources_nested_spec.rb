require 'spec_helper'

describe ChildResourcesController do
  let(:ggp)       { GreatGrandparentResource.create! }
  let(:gp)        { GrandparentResource.create!(:great_grandparent_resource => ggp) }
  let(:p)         { ParentResource.create!(:grandparent_resource => gp) }
  let(:c)         { ChildResource.create!(:parent_resource => p) }

  describe 'parent method' do
    it "answers the resource's immediate parent through a standard parent method" do
      get :show, {:id => c.to_param, :parent_resource_id => p.id, :grandparent_resource_id => gp.id, :great_grandparent_resource_id => ggp.id}
      subject.send(:parent).should eq(p)
    end
  end

  describe 'nested resources by derived name methods' do
    it "answers the resource through a method named after the route information" do
      get :show, {:id => c.to_param, :parent_resource_id => p.id, :grandparent_resource_id => gp.id, :great_grandparent_resource_id => ggp.id}
      subject.send(:child_resource).should eq(c)
    end

    it "answers the resource's parent through a method named after the route information" do
      get :show, {:id => c.to_param, :parent_resource_id => p.id, :grandparent_resource_id => gp.id, :great_grandparent_resource_id => ggp.id}
      subject.send(:parent_resource).should eq(p)
    end

    it "answers the resource's grandparent through a method named after the route information" do
      get :show, {:id => c.to_param, :parent_resource_id => p.id, :grandparent_resource_id => gp.id, :great_grandparent_resource_id => ggp.id}
      subject.send(:grandparent_resource).should eq(gp)
    end

    it "answers the resource's great-grandparent through a method named after the route information" do
      get :show, {:id => c.to_param, :parent_resource_id => p.id, :grandparent_resource_id => gp.id, :great_grandparent_resource_id => ggp.id}
      subject.send(:great_grandparent_resource).should eq(ggp)
    end
  end
end
