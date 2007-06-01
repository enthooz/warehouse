require File.dirname(__FILE__) + '/../test_helper'
require 'users_controller'

# Re-raise errors caught by the controller.
class UsersController; def rescue_action(e) raise e end; end

context "Users Controller" do
  def setup
    @controller = UsersController.new
    @request    = ActionController::TestRequest.new
    @response   = ActionController::TestResponse.new
    class << @controller
      def access_denied(options = {})
        render :text => "error: #{options[:error].inspect}, redirect to #{options[:url].inspect}"
        false
      end

      def login_required_with_testing
        login_required_without_testing
        render :text => 'passed' unless performed?
        false
      end
      alias_method_chain :login_required, :testing
    end
  end

  specify "should require logged_in user" do
    login_as nil
    get :show
    assert_match /^error/, @response.body
  end
  
  specify "should accept valid user" do
    login_as :rick
    get :show, :id => users(:rick).id.to_s
    assert_match /^passed/, @response.body
  end
  
  specify "should accept implicit user" do
    login_as :rick
    get :show
    assert_match /^passed/, @response.body
  end
end
