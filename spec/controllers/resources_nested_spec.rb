require 'spec_helper'

describe 'some nested controllers' do
  describe 'parent method' do
    it "answers the resource's immediate parent through a standard parent method" do
      pending
    end
  end

  describe 'nested resources by derived name methods' do
    it "answers the resource through a method named after the route information" do
      pending
    end

    it "answers the resource's parent through a method named after the route information" do
      pending
    end

    it "answers the resource's grandparent through a method named after the route information" do
      pending
    end

    it "answers the resource's great-grandparent through a method named after the route information" do
      pending
    end
  end
end
