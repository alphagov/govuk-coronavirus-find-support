# frozen_string_literal: true

require "spec_helper"

RSpec.describe CoronavirusForm::HaveYouBeenEvictedController, type: :controller do
  describe "POST" do
    context "if have you been evicted is the last question" do
      it "saves the form response to the database" do
        session[:questions_to_ask] = %w[have_you_been_evicted]
        before_count = FormResponse.count
        post :submit, params: { have_you_been_evicted: I18n.t("coronavirus_form.groups.somewhere_to_live.questions.have_you_been_evicted.options.option_yes.label") }

        expect(FormResponse.count).to be > before_count
      end
    end

    context "if have you been evicted is not the last question" do
      it "does not save the form response to the database" do
        session[:questions_to_ask] = %w[have_you_been_evicted mental_health_worries]
        before_count = FormResponse.count
        post :submit, params: { have_you_been_evicted: I18n.t("coronavirus_form.groups.somewhere_to_live.questions.have_you_been_evicted.options.option_yes.label") }

        expect(FormResponse.count).to eq(before_count)
      end
    end
  end
end
