# frozen_string_literal: true

require "spec_helper"

RSpec.describe CoronavirusForm::DataExportController, type: :controller do
  subject(:instance) { described_class.new }

  describe "#show" do
    let(:start_date) { "2020-04-10" }
    let(:end_date) { "2020-04-15" }

    context "with basic auth enabled" do
      it "rejects unauthenticated users" do
        request.headers["HTTP_ACCEPT"] = "text/csv"
        get :show, params: { start_date: start_date, end_date: end_date }
        expect(response).to have_http_status(401)
      end

      it "permits authenticated users" do
        request.headers["HTTP_ACCEPT"] = "text/csv"
        username = ENV["DATA_EXPORT_BASIC_AUTH_USERNAME"]
        password = ENV["DATA_EXPORT_BASIC_AUTH_PASSWORD"]
        request.headers["HTTP_AUTHORIZATION"] = ActionController::HttpAuthentication::Basic.encode_credentials(username, password)
        get :show, params: { start_date: start_date, end_date: end_date }
        expect(response).to have_http_status(200)
      end
    end
  end

  describe "#usage_statistics" do
    let(:start_date) { "2020-04-10" }
    let(:end_date) { "2020-04-15" }

    before do
      FormResponse.create(
        form_response: {
         able_to_leave: I18n.t("coronavirus_form.groups.leave_home.questions.able_to_leave.options.option_yes.label"),
         get_food: I18n.t("coronavirus_form.groups.getting_food.questions.get_food.options.option_yes.label"),
        },
        created_at: "2020-04-10 10:00:00",
      )
      FormResponse.create(
        form_response: {
          able_to_leave: I18n.t("coronavirus_form.groups.leave_home.questions.able_to_leave.options.option_yes.label"),
          get_food: I18n.t("coronavirus_form.groups.getting_food.questions.get_food.options.option_no.label"),
        },
        created_at: "2020-04-10 10:00:00",
      )
      FormResponse.create(
        form_response: {
          able_to_leave: I18n.t("coronavirus_form.groups.leave_home.questions.able_to_leave.options.option_yes.label"),
          get_food: I18n.t("coronavirus_form.groups.getting_food.questions.get_food.options.option_yes.label"),
        },
        created_at: "2020-04-11 10:00:00",
      )
      FormResponse.create(
        form_response: {
          able_to_leave: I18n.t("coronavirus_form.groups.leave_home.questions.able_to_leave.options.option_other.label"),
          get_food: I18n.t("coronavirus_form.groups.getting_food.questions.get_food.options.option_no.label"),
        },
        created_at: "2020-04-11 10:00:00",
      )
    end

    it "returns a hash containing aggregated form responses" do
      expected_response = {
        "Are you able to leave your home for food, medicine, or health reasons?" => [
          {
            response: I18n.t("coronavirus_form.groups.leave_home.questions.able_to_leave.options.option_yes.label"),
            date: "2020-04-10",
            count: 2,
          },
          {
            response: I18n.t("coronavirus_form.groups.leave_home.questions.able_to_leave.options.option_other.label"),
            date: "2020-04-11",
            count: 1,
          },
          {
            response: I18n.t("coronavirus_form.groups.leave_home.questions.able_to_leave.options.option_yes.label"),
            date: "2020-04-11",
            count: 1,
          },
        ],
        "Are you able to get food?" => [
          {
            response: I18n.t("coronavirus_form.groups.getting_food.questions.get_food.options.option_no.label"),
            date: "2020-04-10",
            count: 1,
          },
          {
            response: I18n.t("coronavirus_form.groups.getting_food.questions.get_food.options.option_yes.label"),
            date: "2020-04-10",
            count: 1,
          },
          {
            response: I18n.t("coronavirus_form.groups.getting_food.questions.get_food.options.option_no.label"),
            date: "2020-04-11",
            count: 1,
          },
          {
            response: I18n.t("coronavirus_form.groups.getting_food.questions.get_food.options.option_yes.label"),
            date: "2020-04-11",
            count: 1,
          },
        ],
      }

      expect(instance.usage_statistics(start_date, end_date)).to eq(expected_response)
    end
  end
end
