# frozen_string_literal: true

require "spec_helper"

RSpec.describe CoronavirusForm::DataExportController, type: :controller do
  subject(:instance) { described_class.new }

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
