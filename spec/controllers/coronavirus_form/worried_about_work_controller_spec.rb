# frozen_string_literal: true

require "spec_helper"

RSpec.describe CoronavirusForm::WorriedAboutWorkController, type: :controller do
  describe "POST" do
    context "if worried about work is the last question" do
      it "saves the form response to the database" do
        session[:questions_to_ask] = %w[worried_about_work]
        before_count = FormResponse.count
        post :submit, params: { worried_about_work: I18n.t("coronavirus_form.groups.going_in_to_work.questions.worried_about_work.options.option_yes.label") }

        expect(FormResponse.count).to be > before_count
      end
    end

    context "if worried about work is not the last question do" do
      it "does not save the form response to the database" do
        session[:questions_to_ask] = %w[worried_about_work mental_health_worries]
        before_count = FormResponse.count
        post :submit, params: { worried_about_work: I18n.t("coronavirus_form.groups.going_in_to_work.questions.living_with_vulnerable.options.option_yes.label") }

        expect(FormResponse.count).to eq(before_count)
      end
    end
  end
end
