# frozen_string_literal: true

require "spec_helper"

RSpec.describe CoronavirusForm::AbleToLeaveController, type: :controller do
  describe "POST" do
    before do
      Timecop.freeze(Time.utc(2020, 3, 1, 10, 43, 45))
    end

    it "saves the form response to the database" do
      session[:questions_to_ask] = %w(foo)

      post :submit, params: { able_to_leave: "Yes" }

      expect(FormResponse.first.form_response).to eq(
        "questions_to_ask" => %w(foo),
        "able_to_leave" => "Yes",
      )
      expect(FormResponse.first.created_at).to eq(Time.utc(2020, 3, 1, 10, 0, 0))
    end

    it "does not save the session id or csrf token to the database" do
      session[:questions_to_ask] = %w(foo)

      post :submit, params: { able_to_leave: "Yes" }

      expect(FormResponse.first.form_response["session_id"]).to be_nil
      expect(FormResponse.first.form_response["_csrf_token"]).to be_nil
    end
  end
end
