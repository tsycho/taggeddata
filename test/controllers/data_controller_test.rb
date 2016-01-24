require 'test_helper'

class DataControllerTest < ActionController::TestCase
  test "should get index" do
    get :index
    assert_response :success
  end

  test "should create datum" do
    post :create, :params => {:value => 42, :tags => "foo, bar", :date => Date.today }
    assert_response :success

    d = Datum.last
    puts d
  end

end
