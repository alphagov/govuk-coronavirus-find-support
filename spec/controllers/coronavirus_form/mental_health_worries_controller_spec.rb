# frozen_string_literal: true

require "spec_helper"

RSpec.describe CoronavirusForm::MentalHealthWorriesController, type: :controller do
  describe "POST" do
    context "if mental health worries is the last question" do
      it "saves the form response to the database" do
        session[:questions_to_ask] = %w[mental_health_worries]
        before_count = FormResponse.count
        post :submit, params: { mental_health_worries: I18n.t("coronavirus_form.groups.mental_health.questions.mental_health_worries.options.option_yes.label") }

        expect(FormResponse.count).to be > before_count
      end
    end

    context "if mental health worries is not the last question" do
      it "does not save the form response to the database" do
        session[:questions_to_ask] = %w[mental_health_worries self_employed]
        before_count = FormResponse.count
        post :submit, params: { mental_health_worries: I18n.t("coronavirus_form.groups.mental_health.questions.mental_health_worries.options.option_yes.label") }

        expect(FormResponse.count).to eq(before_count)
      end
    end
  end
end
