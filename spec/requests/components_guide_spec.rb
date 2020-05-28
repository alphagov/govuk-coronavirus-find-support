require "spec_helper"

RSpec.describe "Components guide", type: :request do
  describe "GET /components-guide" do
    context "in test" do
      it "raises an error" do
        expect {
          get "/component-guide"
        }.to(raise_error ActionController::RoutingError)
      end
    end
  end
end
