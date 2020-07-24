require "spec_helper"

RSpec.describe DataExportCheckboxHelper, type: :helper do
  before do
    FormResponse.create!(
      form_response: {
        need_help_with: [I18n.t("coronavirus_form.groups.getting_food.title")],
      },
      created_at: "2020-04-10 12:00:00",
    )
    FormResponse.create!(
      form_response: {
        need_help_with: [I18n.t("coronavirus_form.groups.getting_food.title")],
      },
      created_at: "2020-04-10 12:00:00",
    )
    FormResponse.create!(
      form_response: {
        need_help_with: [I18n.t("coronavirus_form.groups.paying_bills.title")],
      },
      created_at: "2020-04-10 12:00:00",
    )
    FormResponse.create!(
      form_response: {
        need_help_with: [I18n.t("coronavirus_form.groups.paying_bills.title")],
      },
      created_at: "2020-04-15 12:00:00",
    )
    FormResponse.create!(
      form_response: {
        need_help_with: [I18n.t("coronavirus_form.groups.paying_bills.title")],
      },
      created_at: "2020-04-20 12:00:00",
    )
  end

  describe "#usage_statistics" do
    it "returns data in correct format with no start_date or end_date" do
      expected = { "Getting food 2020-04-10" => [{ response: "Getting food", date: "Fri, 10 Apr 2020".to_date, count: 2 }],
                   "Paying your rent, mortgage, or bills 2020-04-10" => [{ response: "Paying your rent, mortgage, or bills", date: "Fri, 10 Apr 2020".to_date, count: 1 }],
                   "Paying your rent, mortgage, or bills 2020-04-15" => [{ response: "Paying your rent, mortgage, or bills", date: "Wed, 15 Apr 2020".to_date, count: 1 }],
                   "Paying your rent, mortgage, or bills 2020-04-20" => [{ response: "Paying your rent, mortgage, or bills", date: "Mon, 20 Apr 2020".to_date, count: 1 }] }

      expect(helper.usage_statistics(nil, nil)).to eq(expected)
    end

    it "returns data in correct format with start_date and end_date" do
      expected = { "Getting food 2020-04-10" => [{ response: "Getting food", date: "Fri, 10 Apr 2020".to_date, count: 2 }],
                   "Paying your rent, mortgage, or bills 2020-04-10" => [{ response: "Paying your rent, mortgage, or bills", date: "Fri, 10 Apr 2020".to_date, count: 1 }],
                   "Paying your rent, mortgage, or bills 2020-04-15" => [{ response: "Paying your rent, mortgage, or bills", date: "Wed, 15 Apr 2020".to_date, count: 1 }] }

      expect(helper.usage_statistics("2020-04-10", "2020-04-16")).to eq(expected)
    end

    it "returns data in correct format with start_date" do
      expected = { "Paying your rent, mortgage, or bills 2020-04-15" => [{ response: "Paying your rent, mortgage, or bills", date: "Wed, 15 Apr 2020".to_date, count: 1 }],
                   "Paying your rent, mortgage, or bills 2020-04-20" => [{ response: "Paying your rent, mortgage, or bills", date: "Mon, 20 Apr 2020".to_date, count: 1 }]  }

      expect(helper.usage_statistics("2020-04-14", nil)).to eq(expected)
    end

    it "returns data in correct format with end_date" do
      expected = { "Getting food 2020-04-10" => [{ response: "Getting food", date: "Fri, 10 Apr 2020".to_date, count: 2 }],
                   "Paying your rent, mortgage, or bills 2020-04-10" => [{ response: "Paying your rent, mortgage, or bills", date: "Fri, 10 Apr 2020".to_date, count: 1 }]  }

      expect(helper.usage_statistics(nil, "2020-04-14")).to eq(expected)
    end

    it "returns data in correct format with checkbox option selected" do
      FormResponse.create!(
        form_response: {
          need_help_with: [I18n.t("coronavirus_form.groups.filter_questions.questions.need_help_with.options").first],
        },
        created_at: "2020-04-10 12:00:00",
      )

      expected = { "Getting food 2020-04-10" => [{ response: "Getting food", date: "Fri, 10 Apr 2020".to_date, count: 2 }],
                   "Paying your rent, mortgage, or bills 2020-04-10" => [{ response: "Paying your rent, mortgage, or bills", date: "Fri, 10 Apr 2020".to_date, count: 1 }],
                   "Paying your rent, mortgage, or bills 2020-04-15" => [{ response: "Paying your rent, mortgage, or bills", date: "Wed, 15 Apr 2020".to_date, count: 1 }],
                   "Paying your rent, mortgage, or bills 2020-04-20" => [{ response: "Paying your rent, mortgage, or bills", date: "Mon, 20 Apr 2020".to_date, count: 1 }],
                   "Not sure 2020-04-10" => [{ response: "Not sure", date: "Fri, 10 Apr 2020".to_date, count: 1 }] }

      expect(helper.usage_statistics(nil, nil)).to eq(expected)
    end
  end
end
