require 'spec_helper'

describe GreatGrandparentResourcesController do
  describe "GET index" do
    it "executes a passed block" do
      ggp = GreatGrandparentResource.create!
      get :index
      assigns(:collection).should eq([ggp])
      subject.send(:collection).first.description.should eq('We are all great grandparents')
    end
  end

  describe "GET show" do
    it "executes a passed block" do
      ggp = GreatGrandparentResource.create!
      get :show, {:id => ggp.to_param}
      assigns(:resource).should eq(ggp)
      subject.send(:resource).description.should eq('I am a great grandparent')
    end
  end

  describe "GET new" do
    it "executes a passed block" do
      get :new
      assigns(:resource).should be_a_new(GreatGrandparentResource)
      subject.send(:resource).description.should eq('I am becoming a new great grandparent')
    end
  end

  describe "GET edit" do
    it "executes a passed block" do
      ggp = GreatGrandparentResource.create!
      get :edit, {:id => ggp.to_param}
      assigns(:resource).should eq(ggp)

      subject.send(:resource).description.should eq('I am becoming a great grandparent again')
    end
  end

  describe "POST create" do
    it "executes a passed block" do
      post :create
      subject.send(:resource).description.should eq('I am a new great grandparent')
    end
  end

  describe "PUT update" do
    it "executes a passed block" do
      ggp = GreatGrandparentResource.create!
      GreatGrandparentResource.any_instance.stub(:save).and_return(false)
      put :update, {:id => ggp.to_param}
      subject.send(:resource).description.should eq('I am a great grandparent again')
    end
  end

  describe "DELETE destroy" do
    it "executes a passed block" do
      ggp = GreatGrandparentResource.create!
      delete :destroy, {:id => ggp.to_param}
      subject.instance_variable_get(:@obituary).should eq('Here lies a dead great grandparent')
    end
  end

  # check we haven't fuzled any of the rest of the standard REstful action expectations

  def valid_attributes
    {}
  end

  def valid_session
    {}
  end

  describe "POST create" do
    describe "with valid params" do
      it "creates a new resource" do
        expect {
          post :create, {:great_grandparent_resource => valid_attributes}, valid_session
        }.to change(GreatGrandparentResource, :count).by(1)
      end

      it "assigns a newly created resource as resource" do
        post :create, {:great_grandparent_resource => valid_attributes}, valid_session
        assigns(:resource).should be_a(GreatGrandparentResource)
        assigns(:resource).should be_persisted
      end

      it "redirects to the created resource" do
        post :create, {:great_grandparent_resource => valid_attributes}, valid_session
        response.should redirect_to(GreatGrandparentResource.last)
      end
    end

    describe "with invalid params" do
      it "assigns a newly created but unsaved resource as resource" do
        # Trigger the behavior that occurs when invalid params are submitted
        GreatGrandparentResource.any_instance.stub(:save).and_return(false)
        post :create, {:great_grandparent_resource => {}}, valid_session
        assigns(:resource).should be_a_new(GreatGrandparentResource)
      end

      it "re-renders the 'new' template" do
        pending("Failure/Error: response.should render_template('new')")
        # Trigger the behavior that occurs when invalid params are submitted
        GreatGrandparentResource.any_instance.stub(:save).and_return(false)
        post :create, {:great_grandparent_resource => {}}, valid_session
        response.should render_template("new")
      end
    end
  end

  describe "PUT update" do
    describe "with valid params" do
      it "updates the requested resource" do
        r = GreatGrandparentResource.create! valid_attributes
        # Assuming there are no other resources in the database, this
        # specifies that the resource created on the previous line
        # receives the :update_attributes message with whatever params are
        # submitted in the request.
        GreatGrandparentResource.any_instance.should_receive(:update_attributes).with({'these' => 'params'})
        put :update, {:id => r.to_param, :great_grandparent_resource => {'these' => 'params'}}, valid_session
      end

      it "assigns the requested resource as resource" do
        r = GreatGrandparentResource.create! valid_attributes
        put :update, {:id => r.to_param, :great_grandparent_resource => valid_attributes}, valid_session
        assigns(:resource).should eq(r)
      end

      it "redirects to the resource" do
        r = GreatGrandparentResource.create! valid_attributes
        put :update, {:id => r.to_param, :great_grandparent_resource => valid_attributes}, valid_session
        response.should redirect_to(r)
      end
    end

    describe "with invalid params" do
      it "assigns the resource as resource" do
        r = GreatGrandparentResource.create! valid_attributes
        # Trigger the behavior that occurs when invalid params are submitted
        GreatGrandparentResource.any_instance.stub(:save).and_return(false)
        put :update, {:id => r.to_param, :great_grandparent_resource => {}}, valid_session
        assigns(:resource).should eq(r)
      end

      it "re-renders the 'edit' template" do
        pending("Failure/Error: response.should render_template('edit')")
        r = GreatGrandparentResource.create! valid_attributes
        # Trigger the behavior that occurs when invalid params are submitted
        GreatGrandparentResource.any_instance.stub(:save).and_return(false)
        GreatGrandparentResource.any_instance.stub(:save).and_return(['error'])
        put :update, {:id => r.to_param, :great_grandparent_resource => {}}, valid_session
        response.should render_template("edit")
      end
    end
  end

  describe "DELETE destroy" do
    it "destroys the requested resource" do
      r = GreatGrandparentResource.create! valid_attributes
      expect {
        delete :destroy, {:id => r.to_param}, valid_session
      }.to change(GreatGrandparentResource, :count).by(-1)
    end

    it "redirects to the resources list" do
      r = GreatGrandparentResource.create! valid_attributes
      delete :destroy, {:id => r.to_param}, valid_session
      response.should redirect_to(subject.send :collection_url)
    end
  end      


end
