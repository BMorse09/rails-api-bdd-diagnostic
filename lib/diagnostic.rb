require 'rails_helper'

# Instructions:
# The tests you build for this diagnostic are not expected to pass.
# Merely provide a test for each given scenario.

def examples
  Example.all
end

def example
  Example.first
end


#
# Question 1
#
# In a Ruby comment, explain Behavior Driven Development, how it is meant to be
# used, and how it differs from Test Driven Development.

# BDD is meant to test for expected behavior of parts of an application.
# Tests are meant to be written before application code, and the tests will
# drive development towards working code. This differs from TDD in that
# testing for behavior is more meaningful than arbitrary tests and also
# BDD tends to read more easily than TDD, making the tests all around more
# impactful.

#
# Question 2
#
# Create a request spec for our Examples API that ensures 'GET /examples'
# responds successfully and lists all examples.

RSpec.describe 'Examples API' do
  def examples
    Example.all
  end

  def example
    Example.first
  end

  it 'lists all examples' do
    get '/examples'

    expect(response).to be_success

    examples_response = JSON.parse(response.body)
    expect(examples_response.length).to eq(examples.count)
    expect(examples_response['examples'].first['title']).to eq(example.title)
  end
end

#
# Question 3
#
# Create a routing spec for our `Examples` resource that ensures
# GET /examples/:id routes to the examples#show action.

RSpec.describe 'routes for examples' do
  it 'routes GET /examples/:id to the examples#show action' do
    expect(get('/examples/1')).to route_to(
      controller: 'examples',
      action: 'show',
      id: '1'
    )
  end
end

#
# Question 4
#
# Test that a POST action from our ExamplesController is both successful
# and renders a JSON response.

RSpec.describe ExamplesController do
  def example_params
    {
      name: 'Example name',
      body: 'What a fantastic example this is...'
    }
  end

  describe 'POST create' do
    before(:each) do
      post :create, example: example_params, format: :json
    end

    it 'is successful' do
      expect(response).to be_successful
    end

    it 'renders a JSON response' do
      example_response = JSON.parse(response.body)
      expect(example_response).not_to be_nil
    end
  end
end

#
# Question 5
#
# Test that a PATCH action from our ExamplesController is both successful
# and renders a JSON response.

RSpec.describe ExamplesController do
  def example_diff
    {
      body: 'This actually isn\'t that fantastic of an example...'
    }
  end

  describe 'PATCH update' do
    before(:each) do
      patch :update, id: example.id, example: example_diff, format: :json
    end

    it 'is successful' do
      expect(response).to be_successful
    end

    it 'renders a JSON response' do
      example_response = JSON.parse(response.body)
      expect(example_response).not_to be_nil
    end
  end
end

#
# Question 6
#
# Test that a DELETE action from our ExamplesController is both successful
# and renders an empty response.

RSpec.describe ExamplesController do
  def example
    Example.first
  end

  describe 'DELETE destroy' do
    it 'is successful and returns an empty response' do
      delete :destroy, id: example.id, format: :json

      expect(response).to be_successful
      expect(response.body).to be_empty
    end
  end
end

#
# Question 7
#
# Test that the Example model has an association with an
# `other` model. You'll have to build an `association` model
# on your own.
#
# Also, write a test to ensure that your Example
# model validates the presence of `text` for newly
# created examples.

RSpec.describe Example do
  describe 'associations' do
    # association method here
    def association
      described_class.reflect_on_association(:others)
    end

    # test association with `other` here
    it 'has an association with comments' do
      expect(association).to_not be_nil
      expect(association.name).to eq(:comments)
    end
  end
end
