# frozen_string_literal: true

require "spec_helper"

RSpec.describe CoronavirusForm::LivingWithVulnerableController, type: :controller do
  describe "POST" do
    context "if living with vulnerable is the last question" do
      it "saves the form response to the database" do
        session[:questions_to_ask] = %w[living_with_vulnerable]
        before_count = FormResponse.count
        post :submit, params: { living_with_vulnerable: I18n.t("coronavirus_form.groups.going_in_to_work.questions.living_with_vulnerable.options.option_yes.label") }

        expect(FormResponse.count).to be > before_count
      end
    end

    context "if living with vulnerable is not the last question do" do
      it "does not save the form response to the database" do
        session[:questions_to_ask] = %w[living_with_vulnerable mental_health_worries]
        before_count = FormResponse.count
        post :submit, params: { living_with_vulnerable: I18n.t("coronavirus_form.groups.going_in_to_work.questions.living_with_vulnerable.options.option_yes.label") }

        expect(FormResponse.count).to eq(before_count)
      end
    end
  end
end
