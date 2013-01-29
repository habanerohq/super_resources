require 'spec_helper'

describe SimpleResourcesController do
  describe 'DRYs up RESTful scaffolded actions' do
    def valid_attributes
      {}
    end

    def valid_session
      {}
    end

    describe "GET index" do
      it "assigns all simple resources as collection" do
        r = SimpleResource.create! valid_attributes
        get :index, {}, valid_session
        assigns(:collection).should eq([r])
      end
    end

    describe "GET show" do
      it "assigns the requested resource as resource" do
        r = SimpleResource.create! valid_attributes
        get :show, {:id => r.to_param}, valid_session
        assigns(:resource).should eq(r)
      end
    end

    describe "GET new" do
      it "assigns a new resource as resource" do
        get :new, {}, valid_session
        assigns(:resource).should be_a_new(SimpleResource)
      end
    end

    describe "GET edit" do
      it "assigns the requested resource as resource" do
        r = SimpleResource.create! valid_attributes
        get :edit, {:id => r.to_param}, valid_session
        assigns(:resource).should eq(r)
      end
    end

    describe "POST create" do
      describe "with valid params" do
        it "creates a new resource" do
          expect {
            post :create, {:simple_resource => valid_attributes}, valid_session
          }.to change(SimpleResource, :count).by(1)
        end

        it "assigns a newly created resource as resource" do
          post :create, {:simple_resource => valid_attributes}, valid_session
          assigns(:resource).should be_a(SimpleResource)
          assigns(:resource).should be_persisted
        end

        it "redirects to the created resource" do
          post :create, {:simple_resource => valid_attributes}, valid_session
          response.should redirect_to(SimpleResource.last)
        end
      end

      describe "with invalid params" do
        it "assigns a newly created but unsaved resource as resource" do
          # Trigger the behavior that occurs when invalid params are submitted
          SimpleResource.any_instance.stub(:save).and_return(false)
          post :create, {:simple_resource => {}}, valid_session
          assigns(:resource).should be_a_new(SimpleResource)
        end

        it "re-renders the 'new' template" do
#          pending("Failure/Error: response.should render_template('new')")
          # Trigger the behavior that occurs when invalid params are submitted
          SimpleResource.any_instance.stub(:save).and_return(false)
          post :create, {:simple_resource => {}}, valid_session
          response.should render_template("new")
        end
      end
    end

    describe "PUT update" do
      describe "with valid params" do
        it "updates the requested resource" do
          r = SimpleResource.create! valid_attributes
          # Assuming there are no other resources in the database, this
          # specifies that the resource created on the previous line
          # receives the :update_attributes message with whatever params are
          # submitted in the request.
          SimpleResource.any_instance.should_receive(:update_attributes).with({'these' => 'params'})
          put :update, {:id => r.to_param, :simple_resource => {'these' => 'params'}}, valid_session
        end

        it "assigns the requested resource as resource" do
          r = SimpleResource.create! valid_attributes
          put :update, {:id => r.to_param, :simple_resource => valid_attributes}, valid_session
          assigns(:resource).should eq(r)
        end

        it "redirects to the resource" do
          r = SimpleResource.create! valid_attributes
          put :update, {:id => r.to_param, :simple_resource => valid_attributes}, valid_session
          response.should redirect_to(r)
        end
      end

      describe "with invalid params" do
        it "assigns the resource as resource" do
          r = SimpleResource.create! valid_attributes
          # Trigger the behavior that occurs when invalid params are submitted
          SimpleResource.any_instance.stub(:save).and_return(false)
          put :update, {:id => r.to_param, :simple_resource => {}}, valid_session
          assigns(:resource).should eq(r)
        end

        it "re-renders the 'edit' template" do
#          pending("Failure/Error: response.should render_template('edit')")
          r = SimpleResource.create! valid_attributes
          # Trigger the behavior that occurs when invalid params are submitted
          SimpleResource.any_instance.stub(:save).and_return(false)
          SimpleResource.any_instance.stub(:save).and_return(['error'])
          put :update, {:id => r.to_param, :simple_resource => {}}, valid_session
          response.should render_template("edit")
        end
      end
    end

    describe "DELETE destroy" do
      it "destroys the requested resource" do
        r = SimpleResource.create! valid_attributes
        expect {
          delete :destroy, {:id => r.to_param}, valid_session
        }.to change(SimpleResource, :count).by(-1)
      end

      it "redirects to the resources list" do
        r = SimpleResource.create! valid_attributes
        delete :destroy, {:id => r.to_param}, valid_session
        response.should redirect_to(subject.send :collection_url)
      end
    end      
  end
end
