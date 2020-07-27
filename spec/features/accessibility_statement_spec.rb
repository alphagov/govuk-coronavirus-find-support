# frozen_string_literal: true

require "spec_helper"

RSpec.feature "Access the accessibility statement" do
  include FillInTheFormSteps

  scenario "Access accessibility statement directly and return" do
    visit accessibility_statement_path
    expect_to_be_on_accessibility_statement_page
    click_on_back_link
    expect_to_be_on_start_page
  end

  scenario "Access accessibility statement via link on form and return" do
    given_a_user_is_struggling_because_of_coronavirus
    and_they_live_in_england
    expect_to_be_on_need_help_page
    click_on_accessibility_statement_link
    expect_to_be_on_accessibility_statement_page
    click_on_back_link
    expect_to_be_on_need_help_page
  end

  def expect_to_be_on_accessibility_statement_page
    expect(page).to have_content(I18n.t("accessibility_statement.title"))
  end

  def click_on_accessibility_statement_link
    click_on I18n.t("accessibility_statement.title")
  end
end
