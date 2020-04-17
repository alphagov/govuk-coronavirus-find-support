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
        "have_you_been_made_unemployed": "Yes, I’ve been made unemployed, or might be soon",
        "are_you_off_work_ill": "Yes",
        "self_employed": "Yes",
      })
      expect(result_groups(session)).to eq(
        being_unemployed: {
          heading:  I18n.t("coronavirus_form.groups.being_unemployed.title"),
          questions: [
            I18n.t("results_link.being_unemployed.have_you_been_made_unemployed"),
            I18n.t("results_link.being_unemployed.are_you_off_work_ill"),
            I18n.t("results_link.being_unemployed.self_employed"),
          ],
        },
      )
    end

    it "should filter out empty groups" do
      session.merge!({
        "selected_groups": %i[being_unemployed getting_food],
        "have_you_been_made_unemployed": "Yes, I’ve been made unemployed, or might be soon",
        "are_you_off_work_ill": "Yes",
        "self_employed": "Yes",
        "afford_food": "No",
      })
      expect(result_groups(session)).to eq(
        being_unemployed: {
          heading:  I18n.t("coronavirus_form.groups.being_unemployed.title"),
          questions: [
            I18n.t("results_link.being_unemployed.have_you_been_made_unemployed"),
            I18n.t("results_link.being_unemployed.are_you_off_work_ill"),
            I18n.t("results_link.being_unemployed.self_employed"),
          ],
        },
      )
    end
  end

  describe "#filter_questions_by_session" do
    it "should return all group questions if all the session responses meet criteria" do
      session.merge!({
        "selected_groups": %i[being_unemployed],
        "have_you_been_made_unemployed": "Yes, I’ve been made unemployed, or might be soon",
        "are_you_off_work_ill": "Yes",
        "self_employed": "Yes",
      })
      expect(filter_questions_by_session(:being_unemployed, session)).to eq([
        I18n.t("results_link.being_unemployed.have_you_been_made_unemployed"),
        I18n.t("results_link.being_unemployed.are_you_off_work_ill"),
        I18n.t("results_link.being_unemployed.self_employed"),
      ])
    end

    it "should return filtered group questions if the session responses do not meet criteria" do
      session.merge!({
        "selected_groups": %i[being_unemployed],
        "have_you_been_made_unemployed": "Yes, I’ve been made unemployed, or might be soon",
        "are_you_off_work_ill": "No",
        "self_employed": "Yes",
      })
      expect(filter_questions_by_session(:being_unemployed, session)).to eq([
        I18n.t("results_link.being_unemployed.have_you_been_made_unemployed"),
        I18n.t("results_link.being_unemployed.self_employed"),
      ])
    end
  end
end
