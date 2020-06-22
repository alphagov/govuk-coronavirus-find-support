# frozen_string_literal: true

require "spec_helper"

RSpec.describe CoronavirusForm::AbleToLeaveController, type: :controller do
  describe "POST" do
    context "if able to leave is the last question" do
      it "saves the form response to the database" do
        session[:questions_to_ask] = %w[able_to_leave]
        before_count = FormResponse.count
        post :submit, params: { able_to_leave: I18n.t("coronavirus_form.groups.getting_food.questions.able_to_leave.options.option_yes.label") }

        expect(FormResponse.count).to be > before_count
      end
    end

    context "if able to leave is not the last question" do
      it "does not save the form response to the database" do
        session[:questions_to_ask] = %w[afford_food able_to_leave mental_health_worries]
        before_count = FormResponse.count
        post :submit, params: { afford_rent_mortgage_bills: I18n.t("coronavirus_form.groups.paying_bills.questions.afford_rent_mortgage_bills.options.option_yes.label") }

        expect(FormResponse.count).to eq(before_count)
      end
    end
  end
end
