# frozen_string_literal: true

require "spec_helper"

RSpec.describe CoronavirusForm::DataExportController, type: :controller do
  subject(:instance) { described_class.new }

  describe "#usage_statistics" do
    let(:start_date) { "2020-04-10" }
    let(:end_date) { "2020-04-15" }

    before do
      FormResponse.create(form_response: { able_to_leave: "Yes", get_food: "Yes" }, created_at: "2020-04-10 10:00:00")
      FormResponse.create(form_response: { able_to_leave: "Yes", get_food: "No" }, created_at: "2020-04-10 10:00:00")
      FormResponse.create(form_response: { able_to_leave: "Yes", get_food: "Yes" }, created_at: "2020-04-11 10:00:00")
      FormResponse.create(form_response: { able_to_leave: "No", get_food: "No" }, created_at: "2020-04-11 10:00:00")
    end

    it "returns a hash containing aggregated form responses" do
      expected_response = {
        "Are you able to leave your home if absolutely necessary?" => [
          {
            response: "Yes",
            date: "2020-04-10",
            count: 2,
          },
          {
            response: "No",
            date: "2020-04-11",
            count: 1,
          },
          {
            response: "Yes",
            date: "2020-04-11",
            count: 1,
          },
        ],
        "Are you able to get food?" => [
          {
            response: "No",
            date: "2020-04-10",
            count: 1,
          },
          {
            response: "Yes",
            date: "2020-04-10",
            count: 1,
          },
          {
            response: "No",
            date: "2020-04-11",
            count: 1,
          },
          {
            response: "Yes",
            date: "2020-04-11",
            count: 1,
          },
        ],
      }

      expect(instance.usage_statistics(start_date, end_date)).to eq(expected_response)
    end
  end
end
