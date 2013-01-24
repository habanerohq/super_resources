require 'spec_helper'

describe 'Nested resources' do
  let(:ggp)       { GreatGrandparentResource.create! }
  let(:gp)        { GrandparentResource.create!(:great_grandparent_resource => ggp) }
  let(:p)         { ParentResource.create!(:grandparent_resource => gp) }
  let(:c)         { ChildResource.create!(:parent_resource => p) }
  let(:orphan_c)  { ChildResource.create! }

  describe ChildResourcesController do
    describe "RESTful resource actions" do
      it "scopes the resource collection qualified by a parent" do
        get :index, {:parent_resource_id => p.id}
        subject.send(:collection).should eq([c])
      end

      it "shows a resource qualified by a parent" do
        get :show, {:id => c.to_param, :parent_resource_id => p.id}
        subject.send(:resource).should eq(c)
      end

      it "qualifies a new resource qualified by a parent" do
        get :new, {:parent_resource_id => p.id}
        subject.send(:resource).should be_a_new(ChildResource)
        subject.send(:resource).parent_resource.should eq(p)
      end

      it "provide editing for a resource qualified by a parent" do
        get :edit, {:id => c.to_param, :parent_resource_id => p.id}
        subject.send(:resource).should eq(c)
      end

      it "creates a resource qualified by a parent" do
        expect {
          post :create, {:parent_resource_id => p.id}
        }.to change(ChildResource, :count).by(1)

        subject.send(:resource).should be_a(ChildResource)
        subject.send(:resource).should be_persisted

        response.should redirect_to(subject.send(:resource_url, ChildResource.last))
      end

      it "update a resource qualified by a parent" do
        ChildResource.any_instance.should_receive(:update_attributes).with({'these' => 'params'})
        put :update, {:id => c.to_param, :child_resource => {'these' => 'params'}, :parent_resource_id => p.id}

        subject.send(:resource).should eq(c)
        response.should redirect_to(subject.send(:resource_url, c))
      end

      it "destroys a resource qualified by a parent" do
        d = ChildResource.create!(:parent_resource => p)
        expect {
          delete :destroy, {:id => d.to_param, :parent_resource_id => p.id}
        }.to change(ChildResource, :count).by(-1)

        response.should redirect_to(subject.send(:collection_url))        
      end
    end
  end

  describe ParentResourcesController do
    describe "nested RESTful resource actions" do
      it "scopes the resource collection qualified by a grandparent" do
        get :index, {:great_grandparent_resource_id => ggp.id, :grandparent_resource_id => gp.id}
        subject.send(:collection).should eq([p])
      end

      it "shows a resource qualified by a grandparent" do
        get :show, {:id => p.to_param, :great_granbparent_resource_id => ggp.id, :grandparent_resource_id => gp.id}
        subject.send(:resource).should eq(p)
      end

      it "qualifies a new resource qualified by a grandparent" do
        get :new, {:great_grandparent_resource_id => ggp.id, :grandparent_resource_id => gp.id}
        subject.send(:resource).should be_a_new(ParentResource)
        subject.send(:resource).grandparent_resource.great_grandparent_resource.should eq(ggp)
      end

      it "provide editing for a resource qualified by a grandparent" do
        get :edit, {:id => p.to_param, :great_granbparent_resource_id => ggp.id, :grandparent_resource_id => gp.id}
        subject.send(:resource).should eq(p)
      end

      it "creates a resource qualified by a grandparent" do
        expect {
          post :create, {:great_grandparent_resource_id => ggp.id, :grandparent_resource_id => gp.id}
        }.to change(ParentResource, :count).by(1)

        subject.send(:resource).should be_a(ParentResource)
        subject.send(:resource).should be_persisted

        response.should redirect_to(subject.send(:resource_url, ParentResource.last))
      end

      it "update a resource qualified by a grandparent" do
        ParentResource.any_instance.should_receive(:update_attributes).with({'these' => 'params'})
        put :update, {:id => p.to_param, :parent_resource => {'these' => 'params'}, :great_granbparent_resource_id => ggp.id, :grandparent_resource_id => gp.id}

        subject.send(:resource).should eq(p)
        response.should redirect_to(subject.send(:resource_url, p))
      end

      it "destroys a resource qualified by a grandparent" do
        d = ParentResource.create!(:grandparent_resource => gp)
        expect {
          delete :destroy, {:id => d.to_param, :grandparent_resource_id => gp.id}
        }.to change(ParentResource, :count).by(-1)

        response.should redirect_to(subject.send(:collection_url))        
      end
    end
  end  
end
