# frozen_string_literal: true

require "spec_helper"

RSpec.describe CoronavirusForm::ResultsController, type: :controller do
  render_views

  describe "GET /results" do
    subject { get :show }

    before do
      session[:questions_to_ask] = %w[feel_safe]
      session[:nation] = "England"
    end

    it "shows default feedback" do
      expect(subject.body).to include(I18n.t("feedback.titles.default"))
    end

    context "when an answer is present" do
      before { session[:have_you_been_evicted] = "Yes" }

      it "shows the feed back for that answer" do
        expect(expect(subject.body).to(include(I18n.t("feedback.titles.somewhere_to_live"))))
      end

      it "does not show default feedback" do
        expect(subject.body).not_to include(I18n.t("feedback.titles.default"))
      end

      it "does not show other feedback" do
        expect(subject.body).not_to include(I18n.t("feedback.titles.mental_health"))
      end
    end

    context "with multiple answers" do
      before do
        session[:have_you_been_evicted] = "Yes"
        session[:get_food] = "No"
      end

      it "shows the feed back for each answer" do
        expect(expect(subject.body).to(include(I18n.t("feedback.titles.somewhere_to_live"))))
        expect(expect(subject.body).to(include(I18n.t("feedback.titles.getting_food"))))
      end

      it "does not show default feedback" do
        expect(subject.body).not_to include(I18n.t("feedback.titles.default"))
      end

      it "does not show other feedback" do
        expect(subject.body).not_to include(I18n.t("feedback.titles.mental_health"))
      end
    end
  end
end
