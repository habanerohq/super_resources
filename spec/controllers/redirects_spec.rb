require 'spec_helper'

describe 'In the context of generic RESTful-ness,' do
  let(:ggp)       { GreatGrandparentResource.create! }
  let(:gp)        { GrandparentResource.create!(:great_grandparent_resource => ggp) }

  describe GrandparentResourcesController do
    describe 'overriding redirects' do
      it "redirects from create as adapted" do
        expect {
          post :create, {:great_grandparent_resource_id => ggp.id}
        }.to change(GreatGrandparentResource, :count).by(1)

        subject.send(:resource).should be_a(GrandparentResource)
        subject.send(:resource).should be_persisted

        response.should redirect_to(subject.send(:great_grandparent_resource_url, ggp))
      end

      it "redirects from update as adapted" do
        GrandparentResource.any_instance.should_receive(:update_attributes).with({'these' => 'params'}).and_return(true)
        put :update, {:id => gp.to_param, :grandparent_resource => {'these' => 'params'}, :great_grandparent_resource_id => ggp.id}

        subject.send(:resource).should eq(gp)

        response.should redirect_to(subject.send(:great_grandparent_resource_url, ggp))
      end

      it "redirects from destroy as adapted" do
        d = GrandparentResource.create!(:great_grandparent_resource => ggp)
        expect {
          delete :destroy, {:id => d.to_param, :great_grandparent_resource_id => ggp.id}
        }.to change(GrandparentResource, :count).by(-1)

        response.should redirect_to(subject.send(:great_grandparent_resource_url, ggp))
      end
    end
  end
end
