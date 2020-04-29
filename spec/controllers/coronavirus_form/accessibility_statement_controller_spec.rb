# frozen_string_literal: true

require "spec_helper"

RSpec.describe CoronavirusForm::AccessibilityStatementController, type: :controller do
  let(:current_template) { "coronavirus_form/accessibility_statement" }

  describe "GET show" do
    it "renders the page" do
      get :show, params: { locale: "en" }
      expect(response).to render_template(current_template)
    end
  end
end
