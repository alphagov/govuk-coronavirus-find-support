# frozen_string_literal: true

require "spec_helper"

RSpec.describe CoronavirusForm::AffordRentMortgageBillsController, type: :controller do
  describe "POST" do
    context "if afford rent mortgage bills is the last question" do
      before do
        allow_any_instance_of(QuestionsHelper).to receive(:questions_to_ask).and_return(%w[afford_rent_mortgage_bills])
        Timecop.freeze(Time.utc(2020, 3, 1, 10, 43, 45))
      end

      after do
        Timecop.return
      end

      it "saves the form response to the database" do
        session[:questions_to_ask] = %w[afford_rent_mortgage_bills]

        post :submit, params: { afford_rent_mortgage_bills: I18n.t("coronavirus_form.groups.paying_bills.questions.afford_rent_mortgage_bills.options.option_yes.label") }

        expect(FormResponse.first.form_response).to eq(
          "questions_to_ask" => %w[afford_rent_mortgage_bills],
          "afford_rent_mortgage_bills" => I18n.t("coronavirus_form.groups.paying_bills.questions.afford_rent_mortgage_bills.options.option_yes.label"),
        )
        expect(FormResponse.first.created_at).to eq(Time.utc(2020, 3, 1, 10, 0, 0))
      end

      it "does not save the form response to the database when the SMOKE_TEST header is present" do
        session[:questions_to_ask] = %w[afford_rent_mortgage_bills]
        request.env["HTTP_SMOKE_TEST"] = "true"
        before_count = FormResponse.count

        post :submit, params: { afford_rent_mortgage_bills: I18n.t("coronavirus_form.groups.paying_bills.questions.afford_rent_mortgage_bills.options.option_yes.label") }

        expect(FormResponse.count).to eq(before_count)
      end

      it "does not save the session id or csrf token to the database" do
        session[:questions_to_ask] = %w[afford_rent_mortgage_bills]

        post :submit, params: { afford_rent_mortgage_bills: I18n.t("coronavirus_form.groups.paying_bills.questions.afford_rent_mortgage_bills.options.option_yes.label") }

        expect(FormResponse.first.form_response["session_id"]).to be_nil
        expect(FormResponse.first.form_response["_csrf_token"]).to be_nil
      end
    end
  end
end
