# frozen_string_literal: true

require "spec_helper"

RSpec.feature "Fill in the find support form" do
  include FillInTheFormSteps

  shared_examples "filling in the form" do
    scenario "Complete the form when not self employed" do
      given_a_user_is_struggling_because_of_coronavirus
      and_they_live_in_england
      and_needs_help_with_all_options
      and_feels_unsafe_where_they_live
      and_is_finding_it_hard_to_afford_rent_mortgage_bills
      and_is_finding_it_hard_to_afford_food
      and_is_unable_to_get_food
      and_is_not_able_to_leave_home_if_absolutely_necessary
      and_is_not_self_employed_or_a_sole_trader
      and_has_not_been_told_to_stop_working
      and_is_off_work_because_ill_or_self_isolating
      and_is_worried_about_going_to_work_because_of_living_with_someone_vulnerable
      and_has_nowhere_to_live
      and_has_been_evicted
      and_is_worried_about_mental_health
      they_view_the_results_page
      they_are_provided_with_information_about_feeling_unsafe
      they_are_provided_with_information_about_paying_bills
      they_are_provided_with_information_about_getting_food
      they_are_provided_with_information_about_going_in_to_work
      they_are_provided_with_information_about_having_somewhere_to_live
      they_are_provided_with_information_about_mental_health
      they_are_given_a_link_for_providing_feedback
    end
  end

  describe "Complete the form when not self employed" do
    context "without javascript" do
      it_behaves_like "filling in the form"
    end

    context "with javascript", js: true do
      it_behaves_like "filling in the form"
    end
  end

  scenario "Complete the form when not self employed but furloughed" do
    given_a_user_is_struggling_because_of_coronavirus
    and_they_live_in_england
    and_needs_help_with_being_unemployed
    and_is_not_self_employed_or_a_sole_trader
    and_has_been_told_to_stop_working
    they_view_the_results_page
    they_are_provided_with_information_about_being_unemployed
    they_are_given_a_link_for_providing_feedback
  end

  scenario "Complete the form when self employed" do
    given_a_user_is_struggling_because_of_coronavirus
    and_they_live_in_england
    and_needs_help_with_being_unemployed
    and_is_self_employed_or_a_sole_trader
    they_view_the_results_page
    they_are_provided_with_information_about_being_self_employed
    they_are_given_a_link_for_providing_feedback
  end

  scenario "Complete the form when in England, cannot get food and is high risk vulnerable" do
    given_a_user_is_struggling_because_of_coronavirus
    and_they_live_in_england
    and_needs_help_with_getting_food
    and_is_not_finding_it_hard_to_afford_food
    and_is_unable_to_get_food
    and_is_not_able_to_leave_home_as_they_are_vulnerable
    they_view_the_results_page
    they_are_provided_with_information_about_getting_support_when_vulnerable
    they_are_given_a_link_for_providing_feedback
  end

  scenario "Complete the form when in England, cannot get food and is not high risk vulnerable" do
    given_a_user_is_struggling_because_of_coronavirus
    and_they_live_in_england
    and_needs_help_with_getting_food
    and_is_not_finding_it_hard_to_afford_food
    and_is_unable_to_get_food
    and_is_not_able_to_leave_home_if_absolutely_necessary
    they_view_the_results_page
    they_are_not_provided_with_information_about_getting_support_when_vulnerable
    they_are_given_a_link_for_providing_feedback
  end

  scenario "Ensure we can perform a healthcheck" do
    visit healthcheck_path

    expect(page).to have_content("OK")
  end

  scenario "Ensure the privacy notice page is visible" do
    visit privacy_path

    expect(page).to have_content(I18n.t("privacy_page.title"))
  end

  scenario "Ensure the accessibility statement page is visible" do
    visit accessibility_statement_path

    expect(page).to have_content(I18n.t("accessibility_statement.title"))
  end

  scenario "Ensure the session expired page is visible" do
    visit session_expired_path

    expect(page).to have_content(I18n.t("session_expired.title"))
  end
end
