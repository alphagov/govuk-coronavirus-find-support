# frozen_string_literal: true

require "spec_helper"

RSpec.describe CoronavirusForm::WorriedAboutWorkController, type: :controller do
  describe "POST" do
    context "if living with vulnerable is the last question" do
      before do
        allow_any_instance_of(QuestionsHelper).to receive(:questions_to_ask).and_return(%w[worried_about_work])
        Timecop.freeze(Time.utc(2020, 3, 1, 10, 43, 45))
      end

      after do
        Timecop.return
      end

      it "saves the form response to the database" do
        session[:questions_to_ask] = %w[worried_about_work]

        post :submit, params: { worried_about_work: I18n.t("coronavirus_form.groups.going_in_to_work.questions.worried_about_work.options.option_yes.label") }

        expect(FormResponse.first.form_response).to eq(
          "questions_to_ask" => %w[worried_about_work],
          "worried_about_work" => I18n.t("coronavirus_form.groups.going_in_to_work.questions.worried_about_work.options.option_yes.label"),
        )
        expect(FormResponse.first.created_at).to eq(Time.utc(2020, 3, 1, 10, 0, 0))
      end

      it "does not save the form response to the database when the SMOKE_TEST header is present" do
        session[:questions_to_ask] = %w[worried_about_work]
        request.env["HTTP_SMOKE_TEST"] = "true"
        before_count = FormResponse.count

        post :submit, params: { worried_about_work: I18n.t("coronavirus_form.groups.going_in_to_work.questions.worried_about_work.options.option_yes.label") }

        expect(FormResponse.count).to eq(before_count)
      end

      it "does not save the session id or csrf token to the database" do
        session[:questions_to_ask] = %w[worried_about_work]

        post :submit, params: { worried_about_work: I18n.t("coronavirus_form.groups.going_in_to_work.questions.worried_about_work.options.option_yes.label") }

        expect(FormResponse.first.form_response["session_id"]).to be_nil
        expect(FormResponse.first.form_response["_csrf_token"]).to be_nil
      end
    end
  end
end
