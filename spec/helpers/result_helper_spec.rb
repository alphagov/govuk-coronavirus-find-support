require "spec_helper"

RSpec.describe ResultsHelper, type: :helper do
  describe "#relevant_group_keys" do
    it "should return all group keys if selected_groups is empty" do
      session.merge!({ "selected_groups": [] })
      expect(relevant_group_keys).to eq(%i[
        feeling_unsafe
        paying_bills
        getting_food
        being_unemployed
        going_in_to_work
        somewhere_to_live
        mental_health
      ])
    end

    it "should return selected_groups if it is not empty" do
      session.merge!({ "selected_groups": %i[feeling_unsafe paying_bills] })
      expect(relevant_group_keys).to eq(%i[feeling_unsafe paying_bills])
    end
  end

  describe "#result_groups" do
    it "should return a group data structure with a heading and filtered questions" do
      session.merge!({
        "selected_groups": %i[being_unemployed],
        "have_you_been_made_unemployed": I18n.t("coronavirus_form.groups.being_unemployed.questions.have_you_been_made_unemployed.options.option_might_be.label"),
        "are_you_off_work_ill": I18n.t("coronavirus_form.groups.being_unemployed.questions.are_you_off_work_ill.options.option_yes.label"),
        "self_employed": I18n.t("coronavirus_form.groups.being_unemployed.questions.self_employed.options.option_yes.label"),
        "nation": I18n.t("coronavirus_form.groups.location.questions.nation.options.option_england.label"),
      })
      result_array = [
        I18n.t("results_link.being_unemployed.have_you_been_made_unemployed.title"),
        I18n.t("results_link.being_unemployed.are_you_off_work_ill.title"),
        I18n.t("results_link.being_unemployed.self_employed.title"),
      ]
      expect(result_groups(session)[:being_unemployed][:questions].map { |q| q[:title] }).to eq(result_array)
    end

    it "should filter out empty groups" do
      session.merge!({
        "selected_groups": %i[being_unemployed getting_food],
        "have_you_been_made_unemployed": I18n.t("coronavirus_form.groups.being_unemployed.questions.have_you_been_made_unemployed.options.option_might_be.label"),
        "are_you_off_work_ill": I18n.t("coronavirus_form.groups.being_unemployed.questions.are_you_off_work_ill.options.option_yes.label"),
        "self_employed": I18n.t("coronavirus_form.groups.being_unemployed.questions.self_employed.options.option_yes.label"),
        "afford_food": I18n.t("coronavirus_form.groups.getting_food.questions.afford_food.options.option_no.label"),
        "nation": I18n.t("coronavirus_form.groups.location.questions.nation.options.option_england.label"),
      })
      expect(result_groups(session).keys).not_to include(:getting_food)
    end
  end

  describe "#filter_questions_by_session" do
    it "should return filtered group questions if the session responses do not meet criteria" do
      session.merge!({
        "selected_groups": %i[being_unemployed],
        "have_you_been_made_unemployed": I18n.t("coronavirus_form.groups.being_unemployed.questions.have_you_been_made_unemployed.options.option_might_be.label"),
        "are_you_off_work_ill": I18n.t("coronavirus_form.groups.being_unemployed.questions.are_you_off_work_ill.options.option_no.label"),
        "self_employed": I18n.t("coronavirus_form.groups.being_unemployed.questions.self_employed.options.option_yes.label"),
        "nation": I18n.t("coronavirus_form.groups.location.questions.nation.options.option_england.label"),
      })
      expect(result_groups(session)[:being_unemployed][:questions].map { |q| q[:title] }).not_to include(I18n.t("results_link.being_unemployed.are_you_off_work_ill.title"))
    end
  end

  describe "#filter_results_by_multiple_questions" do
    it "should return filtered results if the session nation matches that attached to the questions" do
      session.merge!({
        "nation": "nation 1",
      })
      test_hash = {
        items: [
          { show_to_nations: "nation 1" },
          { show_to_nations: "nation 2" },
        ],
      }
      expect(filter_results_by_multiple_questions(test_hash.dup)[:items]).to eq([{ show_to_nations: "nation 1" }])
    end

    it "should return support_items using same mechanism as items" do
      session.merge!({
        "nation": "nation 1",
      })
      test_hash = {
        items: [
          { show_to_nations: "nation 1" },
        ],
        support_and_advice_items: [
          { show_to_nations: "nation 1" },
          { show_to_nations: "nation 2" },
        ],
      }
      expect(filter_results_by_multiple_questions(test_hash.dup)[:support_and_advice_items]).to eq([{ show_to_nations: "nation 1" }])
    end

    let(:vulnerable_person_label) { I18n.t("coronavirus_form.groups.leave_home.questions.able_to_leave.options.option_high_risk.label") }
    let(:not_vulnerable_label) { I18n.t("coronavirus_form.groups.leave_home.questions.able_to_leave.options.option_other.label") }

    it "should return show_to_vulnerable_person items if the session able_to_leave is high_risk" do
      session.merge!({
        "able_to_leave": vulnerable_person_label,
      })
      test_hash = {
        items: [
          { show_to_vulnerable_person: true },
          { _: nil },
        ],
      }
      expect(filter_results_by_multiple_questions(test_hash.dup)[:items]).to eq([{ show_to_vulnerable_person: true }, { _: nil }])
    end

    it "should not return show_to_vulnerable_person items when the session able_to_leave is not high_risk" do
      session.merge!({
        "able_to_leave": not_vulnerable_label,
      })
      test_hash = {
        items: [
          { show_to_vulnerable_person: true },
          { _: nil },
        ],
      }
      expect(filter_results_by_multiple_questions(test_hash.dup)[:items]).to eq([{ _: nil }])
    end

    it "should filter multiple questions with AND condition" do
      session.merge!({
        "able_to_leave": not_vulnerable_label,
        "nation": "nation 1",
      })
      test_hash = {
        items: [
          { "nation": "nation 1", show_to_vulnerable_person: true },
          { "nation": "nation 1" },
        ],
      }
      expect(filter_results_by_multiple_questions(test_hash.dup)[:items]).to eq([{ "nation": "nation 1" }])
    end
  end
end
