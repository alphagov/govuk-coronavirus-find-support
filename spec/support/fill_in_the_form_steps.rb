# frozen_string_literal: true

module FillInTheFormSteps
  def given_a_user_is_struggling_because_of_coronavirus
    visit urgent_medical_help_path
  end

  def and_does_not_need_urgent_medical_help
    expect(page).to have_content(I18n.t("coronavirus_form.groups.help.questions.urgent_medical_help.title"))

    choose "No"

    click_on "Continue"
  end

  def and_needs_help_with_all_options
    expect(page).to have_content(I18n.t("coronavirus_form.groups.filter_questions.questions.need_help_with.title"))

    check I18n.t("coronavirus_form.groups.feeling_unsafe.title")
    check I18n.t("coronavirus_form.groups.paying_bills.title")
    check I18n.t("coronavirus_form.groups.getting_food.title")
    check I18n.t("coronavirus_form.groups.being_unemployed.title")
    check I18n.t("coronavirus_form.groups.going_in_to_work.title")
    check I18n.t("coronavirus_form.groups.somewhere_to_live.title")
    check I18n.t("coronavirus_form.groups.mental_health.title")
    check I18n.t("coronavirus_form.groups.filter_questions.questions.need_help_with.options").first

    click_on "Continue"
  end

  def and_feels_unsafe_where_they_live
    expect(page).to have_content(I18n.t("coronavirus_form.groups.feeling_unsafe.questions.feel_safe.title"))

    choose "No"

    click_on "Continue"
  end

  def and_is_finding_it_hard_to_afford_rent_mortgage_bills
    expect(page).to have_content(I18n.t("coronavirus_form.groups.paying_bills.questions.afford_rent_mortgage_bills.title"))

    choose "Yes"

    click_on "Continue"
  end

  def and_is_finding_it_hard_to_afford_food
    expect(page).to have_content(I18n.t("coronavirus_form.groups.getting_food.questions.afford_food.title"))

    choose "Yes"

    click_on "Continue"
  end

  def and_is_unable_to_get_food
    expect(page).to have_content(I18n.t("coronavirus_form.groups.getting_food.questions.get_food.title"))

    choose "No"

    click_on "Continue"
  end

  def and_has_been_told_to_stop_working
    expect(page).to have_content(I18n.t("coronavirus_form.groups.being_unemployed.questions.have_you_been_made_unemployed.title"))

    choose "Yes, I’ve been made unemployed, or might be soon"

    click_on "Continue"
  end

  def and_is_off_work_because_ill_or_self_isolating
    expect(page).to have_content(I18n.t("coronavirus_form.groups.being_unemployed.questions.are_you_off_work_ill.title"))

    choose "Yes"

    click_on "Continue"
  end

  def and_is_self_employed_or_a_sole_trader
    expect(page).to have_content(I18n.t("coronavirus_form.groups.being_unemployed.questions.self_employed.title"))

    choose "Yes"

    click_on "Continue"
  end

  def and_is_worried_about_going_to_work_because_of_living_with_someone_vulnerable
    expect(page).to have_content(I18n.t("coronavirus_form.groups.going_in_to_work.questions.living_with_vulnerable.title"))

    choose "Yes"

    click_on "Continue"
  end

  def and_has_nowhere_to_live
    expect(page).to have_content(I18n.t("coronavirus_form.groups.somewhere_to_live.questions.have_somewhere_to_live.title"))

    choose "No"

    click_on "Continue"
  end

  def and_has_been_evicted
    expect(page).to have_content(I18n.t("coronavirus_form.groups.somewhere_to_live.questions.have_you_been_evicted.title"))

    choose "Yes"

    click_on "Continue"
  end

  def and_is_worried_about_mental_health
    expect(page).to have_content(I18n.t("coronavirus_form.groups.mental_health.questions.mental_health_worries.title"))

    choose "Yes, I am"

    click_on "Continue"
  end

  def and_is_not_able_to_leave_home_if_absolutely_necessary
    expect(page).to have_content(I18n.t("coronavirus_form.groups.leave_home.questions.able_to_leave.title"))

    choose "I should not leave home because I have coronavirus symptoms, or someone in my household does"

    click_on "Continue"
  end

  def they_view_the_results_page
    expect(page).to have_content(I18n.t("coronavirus_form.results.header.title"))
    expect(current_path).to eq "/en/results"
  end

  def they_are_provided_with_information_about_feeling_unsafe
    expect(page).to have_content(I18n.t("results_link.feeling_unsafe.feel_safe.title"))
  end

  def they_are_provided_with_information_about_paying_bills
    expect(page).to have_content(I18n.t("results_link.paying_bills.afford_rent_mortgage_bills.title"))
  end

  def they_are_provided_with_information_about_getting_food
    expect(page).to have_content(I18n.t("results_link.getting_food.afford_food.title"))
    expect(page).to have_content(I18n.t("results_link.getting_food.get_food.title"))
  end

  def they_are_provided_with_information_about_being_unemployed
    expect(page).to have_content(I18n.t("results_link.being_unemployed.have_you_been_made_unemployed.title"))
    expect(page).to have_content(I18n.t("results_link.being_unemployed.are_you_off_work_ill.title"))
    expect(page).to have_content(I18n.t("results_link.being_unemployed.self_employed.title"))
  end

  def they_are_provided_with_information_about_going_in_to_work
    expect(page).to have_content(I18n.t("results_link.going_in_to_work.living_with_vulnerable.title"))
  end

  def they_are_provided_with_information_about_having_somewhere_to_live
    expect(page).to have_content(I18n.t("results_link.somewhere_to_live.have_somewhere_to_live.title"))
    expect(page).to have_content(I18n.t("results_link.somewhere_to_live.have_you_been_evicted.title"))
  end

  def they_are_provided_with_information_about_mental_health
    expect(page).to have_content(I18n.t("results_link.mental_health.mental_health_worries.title"))
  end

  def they_are_given_a_link_for_providing_feedback
    expect(page).to have_content(I18n.t("coronavirus_form.results.feedback.link_text"))
  end
end
