# frozen_string_literal: true

require "spec_helper"

RSpec.describe UsageStatisticsExporter, type: :model do
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

  describe "#results" do
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

      expect(UsageStatisticsExporter.results(start_date, end_date)).to eq(expected_response)
    end
  end

  describe "#produce_csv" do
    it "returns a csv containing aggregated form responses with a | delimiter" do
      results = UsageStatisticsExporter.results(start_date, end_date)
      expected_response =
        "question|answer|date|count
Are you able to get food?|No|2020-04-10|1
Are you able to get food?|Yes|2020-04-10|1
Are you able to get food?|No|2020-04-11|1
Are you able to get food?|Yes|2020-04-11|1
Are you able to leave your home for food, medicine, or health reasons?|Yes|2020-04-10|2
Are you able to leave your home for food, medicine, or health reasons?|I’m unable to leave my home for another reason|2020-04-11|1
Are you able to leave your home for food, medicine, or health reasons?|Yes|2020-04-11|1\n"

      expect(UsageStatisticsExporter.produce_csv(results)).to eq(expected_response)
    end
  end
end
