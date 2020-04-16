# frozen_string_literal: true

module FillInTheFormSteps
  def given_a_user_is_struggling_because_of_coronavirus
    visit urgent_medical_help_path
  end

  def and_does_not_need_urgent_medical_help
    visit urgent_medical_help_path
    expect(page.body).to have_content(I18n.t("coronavirus_form.groups.help.questions.urgent_medical_help.title"))

    within find(".govuk-main-wrapper") do
      choose "No"
      click_on "Continue"
    end
  end

  def and_needs_help_with_all_options
    expect(page.body).to have_content(I18n.t("coronavirus_form.groups.filter_questions.questions.need_help_with.title"))

    check I18n.t("coronavirus_form.groups.feeling_unsafe.title")
    check I18n.t("coronavirus_form.groups.paying_bills.title")
    check I18n.t("coronavirus_form.groups.getting_food.title")
    check I18n.t("coronavirus_form.groups.being_unemployed.title")
    check I18n.t("coronavirus_form.groups.going_in_to_work.title")
    check I18n.t("coronavirus_form.groups.somewhere_to_live.title")
    check I18n.t("coronavirus_form.groups.mental_health.title")
    check I18n.t("coronavirus_form.groups.filter_questions.questions.need_help_with.options").first

    within find(".govuk-main-wrapper") do
      click_on "Continue"
    end
  end

  def and_feels_unsafe_where_they_live
    expect(page.body).to have_content(I18n.t("coronavirus_form.groups.feeling_unsafe.questions.feel_safe.title"))

    within find(".govuk-main-wrapper") do
      choose "No"
      click_on "Continue"
    end
  end

  def and_is_finding_it_hard_to_afford_rent_mortgage_bills
    expect(page.body).to have_content(I18n.t("coronavirus_form.groups.paying_bills.questions.afford_rent_mortgage_bills.title"))

    within find(".govuk-main-wrapper") do
      choose "Yes"
      click_on "Continue"
    end
  end

  def and_is_finding_it_hard_to_afford_food
    expect(page.body).to have_content(I18n.t("coronavirus_form.groups.getting_food.questions.afford_food.title"))

    within find(".govuk-main-wrapper") do
      choose "Yes"
      click_on "Continue"
    end
  end

  def and_is_unable_to_get_food
    expect(page.body).to have_content(I18n.t("coronavirus_form.groups.getting_food.questions.get_food.title"))

    within find(".govuk-main-wrapper") do
      choose "No"
      click_on "Continue"
    end
  end

  def and_has_been_made_unemployed_or_furloughed
    expect(page.body).to have_content(I18n.t("coronavirus_form.groups.being_unemployed.questions.have_you_been_made_unemployed.title"))

    within find(".govuk-main-wrapper") do
      choose "Yes"
      click_on "Continue"
    end
  end

  def and_is_off_work_because_ill_or_self_isolating
    expect(page.body).to have_content(I18n.t("coronavirus_form.groups.being_unemployed.questions.are_you_off_work_ill.title"))

    within find(".govuk-main-wrapper") do
      choose "Yes"
      click_on "Continue"
    end
  end

  def and_is_self_employed_or_a_sole_trader
    expect(page.body).to have_content(I18n.t("coronavirus_form.groups.being_unemployed.questions.self_employed.title"))

    within find(".govuk-main-wrapper") do
      choose "Yes"
      click_on "Continue"
    end
  end

  def and_is_still_going_in_to_work_but_is_not_a_key_worker
    expect(page.body).to have_content(I18n.t("coronavirus_form.groups.going_in_to_work.questions.still_working.title"))

    within find(".govuk-main-wrapper") do
      choose "Yes"
      click_on "Continue"
    end
  end

  def and_is_worried_about_going_to_work_because_of_living_with_someone_vulnerable
    expect(page.body).to have_content(I18n.t("coronavirus_form.groups.going_in_to_work.questions.living_with_vulnerable.title"))

    within find(".govuk-main-wrapper") do
      choose "Yes"
      click_on "Continue"
    end
  end

  def and_has_nowhere_to_live
    expect(page.body).to have_content(I18n.t("coronavirus_form.groups.somewhere_to_live.questions.have_somewhere_to_live.title"))

    within find(".govuk-main-wrapper") do
      choose "No"
      click_on "Continue"
    end
  end

  def and_has_been_evicted
    expect(page.body).to have_content(I18n.t("coronavirus_form.groups.somewhere_to_live.questions.have_you_been_evicted.title"))

    within find(".govuk-main-wrapper") do
      choose "Yes"
      click_on "Continue"
    end
  end

  def and_is_worried_about_mental_health
    expect(page.body).to have_content(I18n.t("coronavirus_form.groups.mental_health.questions.mental_health_worries.title"))

    choose "Yes, I am"

    click_on "Continue"
  end

  def and_is_not_able_to_leave_home_if_absolutely_necessary
    expect(page.body).to have_content(I18n.t("coronavirus_form.groups.leave_home.questions.able_to_leave.title"))

    choose "I cannot go out because I have coronavirus, or someone in my household does"

    click_on "Continue"
  end

  def they_view_the_results_page
    expect(page.body).to have_content(I18n.t("coronavirus_form.results.header.title"))
    expect(current_path).to eq "/results"
  end

  def they_are_provided_with_information_about_feeling_unsafe
    expect(page.body).to have_content(I18n.t("results_link.feeling_unsafe.feel_safe.title"))
  end

  def they_are_provided_with_information_about_paying_bills
    expect(page.body).to have_content(I18n.t("results_link.paying_bills.afford_rent_mortgage_bills.title"))
  end

  def they_are_provided_with_information_about_getting_food
    expect(page.body).to have_content(I18n.t("results_link.getting_food.afford_food.title"))
    expect(page.body).to have_content(I18n.t("results_link.getting_food.get_food.title"))
  end

  def they_are_provided_with_information_about_being_unemployed
    expect(page.body).to have_content(I18n.t("results_link.being_unemployed.have_you_been_made_unemployed.title"))
    expect(page.body).to have_content(I18n.t("results_link.being_unemployed.are_you_off_work_ill.title"))
    expect(page.body).to have_content(I18n.t("results_link.being_unemployed.self_employed.title"))
  end

  def they_are_provided_with_information_about_going_in_to_work
    expect(page.body).to have_content(I18n.t("results_link.going_in_to_work.still_working.title"))
    expect(page.body).to have_content(I18n.t("results_link.going_in_to_work.living_with_vulnerable.title"))
  end

  def they_are_provided_with_information_about_having_somewhere_to_live
    expect(page.body).to have_content(I18n.t("results_link.somewhere_to_live.have_somewhere_to_live.title"))
    expect(page.body).to have_content(I18n.t("results_link.somewhere_to_live.have_you_been_evicted.title"))
  end

  def they_are_provided_with_information_about_mental_health
    expect(page.body).to have_content(I18n.t("results_link.mental_health.mental_health_worries.title"))
  end

  def they_are_given_a_link_for_providing_feedback
    expect(page.body).to have_content(I18n.t("coronavirus_form.results.feedback.link_text"))
  end
end
