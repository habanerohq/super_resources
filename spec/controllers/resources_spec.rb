require 'spec_helper'

describe SimpleResourcesController do
  describe 'resource class method' do
    it "answers the resource class through a standard resource_class method" do
      pending
    end

    it "answers the resource class through an adapted resource_class method" do
      pending
    end
  end

  describe 'individual and collection methods' do
    it "answers the resource through a standard resource method" do
      pending
    end

    it "answers a collection of resources through a standard collection method" do
      pending
    end

    it "answers the resource through an adapted resource method" do
      pending
    end

    it "answers a collection of resources through an adapted collection method" do
      pending ('for example, extra scoping')
    end

    it "adapts the resource method name" do
      pending
    end

    it "adapts the collection method name" do
      pending
    end
  end

  describe 'finding resourcess' do
    it "finds resources by a default finder when no override is given" do
      pending
    end

    it "finds resources by a specific finder when one is given" do
      pending
    end
  end

  describe 'customized resource building' do
      it "allows a completely new implementation" do
        pending
      end

    it "adds extra behaviour to the existing build implementation" do
      pending
    end
  end
end
