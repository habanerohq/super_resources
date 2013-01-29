require 'spec_helper'

describe AdaptedResourcesController do
  describe 'resource class method' do
    it "answers the resource class through an adapted resource_class method" do
      get :index
      subject.send(:resource_class).should eq(MyAdaptedResource)
    end
  end

  describe 'individual and collection methods' do
    it "answers the the name of the resource's input param hash name " do
      subject.send(:resource_params_name).should eq(:input)
    end
  end

  describe 'customized resource building' do
    it "adapts building" do
      get :new, {}
      assigns(:resource).description.should eq(subject.send :a_hard_coded_description)
    end
  end

# test RESTful actions still work after the above shenanigans

  describe 'standard RESTful actions still work' do
    def valid_attributes
      {}
    end

    def valid_session
      {}
    end

    describe "GET index" do
      it "assigns all simple resources as collection" do
        r = MyAdaptedResource.create! valid_attributes
        get :index, {}, valid_session
        assigns(:collection).should eq([r])
      end
    end

    describe "GET show" do
      it "assigns the requested resource as resource" do
        r = MyAdaptedResource.create! valid_attributes
        get :show, {:id => r.to_param}, valid_session
        assigns(:resource).should eq(r)
      end
    end

    describe "GET new" do
      it "assigns a new resource as resource" do
        get :new, {}, valid_session
        assigns(:resource).should be_a_new(MyAdaptedResource)
      end
    end

    describe "GET edit" do
      it "assigns the requested resource as resource" do
        r = MyAdaptedResource.create! valid_attributes
        get :edit, {:id => r.to_param}, valid_session
        assigns(:resource).should eq(r)
      end
    end

    describe "POST create" do
      describe "with valid params" do
        it "creates a new resource" do
          expect {
            post :create, {:input => valid_attributes}, valid_session
          }.to change(MyAdaptedResource, :count).by(1)
        end

        it "assigns a newly created resource as resource" do
          post :create, {:input => valid_attributes}, valid_session
          assigns(:resource).should be_a(SimpleResource)
          assigns(:resource).should be_persisted
        end

        it "redirects to the created resource" do
          post :create, {:simple_resource => valid_attributes}, valid_session
          response.should redirect_to("/adapted_resources/#{MyAdaptedResource.last.id}")
        end
      end

      describe "with invalid params" do
        it "assigns a newly created but unsaved resource as resource" do
          # Trigger the behavior that occurs when invalid params are submitted
          MyAdaptedResource.any_instance.stub(:save).and_return(false)
          post :create, {:input => {}}, valid_session
          assigns(:resource).should be_a_new(MyAdaptedResource)
        end

        it "re-renders the 'new' template" do
#          pending("Failure/Error: response.should render_template('new')")
          # Trigger the behavior that occurs when invalid params are submitted
          MyAdaptedResource.any_instance.stub(:save).and_return(false)
          post :create, {:input => {}}, valid_session
          response.should render_template("new")
        end
      end
    end

    describe "PUT update" do
      describe "with valid params" do
        it "updates the requested resource" do
          r = MyAdaptedResource.create! valid_attributes
          # Assuming there are no other resources in the database, this
          # specifies that the resource created on the previous line
          # receives the :update_attributes message with whatever params are
          # submitted in the request.
          MyAdaptedResource.any_instance.should_receive(:update_attributes).with({'these' => 'params'})
          put :update, {:id => r.to_param, :input => {'these' => 'params'}}, valid_session
        end

        it "assigns the requested resource as resource" do
          r = MyAdaptedResource.create! valid_attributes
          put :update, {:id => r.to_param, :input => valid_attributes}, valid_session
          assigns(:resource).should eq(r)
        end

        it "redirects to the resource" do
          r = MyAdaptedResource.create! valid_attributes
          put :update, {:id => r.to_param, :input => valid_attributes}, valid_session
          response.should redirect_to('/adapted_resources/1')
        end
      end

      describe "with invalid params" do
        it "assigns the resource as resource" do
          r = MyAdaptedResource.create! valid_attributes
          # Trigger the behavior that occurs when invalid params are submitted
          AdaptedResource.any_instance.stub(:save).and_return(false)
          put :update, {:id => r.to_param, :input => {}}, valid_session
          assigns(:resource).should eq(r)
        end

        it "re-renders the 'edit' template" do
#          pending("Failure/Error: response.should render_template('edit')")
          r = MyAdaptedResource.create! valid_attributes
          # Trigger the behavior that occurs when invalid params are submitted
          MyAdaptedResource.any_instance.stub(:save).and_return(false)
          MyAdaptedResource.any_instance.stub(:save).and_return(['error'])
          put :update, {:id => r.to_param, :input => {}}, valid_session
          response.should render_template("edit")
        end
      end
    end

    describe "DELETE destroy" do
      it "destroys the requested resource" do
        r = MyAdaptedResource.create! valid_attributes
        expect {
          delete :destroy, {:id => r.to_param}, valid_session
        }.to change(MyAdaptedResource, :count).by(-1)
      end

      it "redirects to the resources list" do
        r = MyAdaptedResource.create! valid_attributes
        delete :destroy, {:id => r.to_param}, valid_session
        response.should redirect_to(subject.send :collection_url)
      end
    end      
  end
end

describe MyAdaptedResourcesController do
  def valid_attributes
    { :description => subject.send(:a_hard_coded_description) }
  end

  def valid_session
    {}
  end

  describe 'finding resourcess' do
    it "finds resources by a specific finder when one is given" do
      get :index
      subject.send(:finder_method).should eq(:find_by_description)
    end
  end

  describe 'standard RESTful actions still work' do
    describe "GET show" do
      it "assigns the requested resource as resource" do
        r = MyAdaptedResource.create! valid_attributes
        get :show, {:id => r.to_param}, valid_session
        assigns(:resource).should eq(nil) # since we have changed the finder method and not set up a friendly id strategy
      end
    end
  end
end  

