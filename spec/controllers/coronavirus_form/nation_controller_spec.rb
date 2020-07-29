# frozen_string_literal: true

require "spec_helper"

RSpec.describe CoronavirusForm::NationController, type: :controller do
  describe "POST" do
    it "saves the form response to the database" do
      before_count = FormResponse.count
      post :submit, params: { nation: I18n.t("coronavirus_form.groups.location.questions.nation.options.option_england.label") }

      expect(FormResponse.count).to be > before_count
    end
  end
end
