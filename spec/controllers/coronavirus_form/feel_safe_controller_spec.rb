# frozen_string_literal: true

require "spec_helper"

RSpec.describe CoronavirusForm::FeelSafeController, type: :controller do
  describe "POST" do
    context "if do you feel safe is the last question" do
      it "saves the form response to the database" do
        session[:questions_to_ask] = %w[feel_safe]
        before_count = FormResponse.count
        post :submit, params: { feel_safe: I18n.t("coronavirus_form.groups.feeling_unsafe.questions.feel_safe.options.option_yes.label") }

        expect(FormResponse.count).to be > before_count
      end

      context "if do you feel safe is not the last question" do
        it "does not save the form response to the database" do
          session[:questions_to_ask] = %w[feel_safe mental_health_worries]
          before_count = FormResponse.count
          post :submit, params: { feel_safe: I18n.t("coronavirus_form.groups.feeling_unsafe.questions.feel_safe.options.option_yes.label") }

          expect(FormResponse.count).to eq(before_count)
        end
      end
    end
  end
end
