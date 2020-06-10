# frozen_string_literal: true

require "spec_helper"

RSpec.describe CoronavirusForm::HaveYouBeenMadeUnemployedController, type: :controller do
  describe "POST" do
    context "if have you been made unemployed is the last question" do
      before do
        allow_any_instance_of(QuestionsHelper).to receive(:questions_to_ask).and_return(%w[have_you_been_made_unemployed])
        Timecop.freeze(Time.utc(2020, 3, 1, 10, 43, 45))
      end

      after do
        Timecop.return
      end

      it "saves the form response to the database" do
        session[:questions_to_ask] = %w[have_you_been_made_unemployed]

        post :submit, params: { have_you_been_made_unemployed: I18n.t("coronavirus_form.groups.being_unemployed.questions.have_you_been_made_unemployed.options.option_yes.label") }

        expect(FormResponse.first.form_response).to eq(
          "questions_to_ask" => %w[have_you_been_made_unemployed],
          "have_you_been_made_unemployed" => I18n.t("coronavirus_form.groups.being_unemployed.questions.have_you_been_made_unemployed.options.option_yes.label"),
        )
        expect(FormResponse.first.created_at).to eq(Time.utc(2020, 3, 1, 10, 0, 0))
      end

      it "does not save the form response to the database when the SMOKE_TEST header is present" do
        session[:questions_to_ask] = %w[have_you_been_made_unemployed]
        request.env["HTTP_SMOKE_TEST"] = "true"
        before_count = FormResponse.count

        post :submit, params: { have_you_been_made_unemployed: I18n.t("coronavirus_form.groups.being_unemployed.questions.have_you_been_made_unemployed.options.option_yes.label") }

        expect(FormResponse.count).to eq(before_count)
      end

      it "does not save the session id or csrf token to the database" do
        session[:questions_to_ask] = %w[have_you_been_made_unemployed]

        post :submit, params: { have_you_been_made_unemployed: I18n.t("coronavirus_form.groups.being_unemployed.questions.have_you_been_made_unemployed.options.option_yes.label") }

        expect(FormResponse.first.form_response["session_id"]).to be_nil
        expect(FormResponse.first.form_response["_csrf_token"]).to be_nil
      end
    end
  end
end
