# frozen_string_literal: true

require "spec_helper"

RSpec.feature "Access the cookies page" do
  include FillInTheFormSteps

  scenario "Access cookies page directly and return" do
    visit cookies_path
    expect_to_be_on_cookies_page
    click_on_back_link
    expect_to_be_on_start_page
  end

  scenario "Access cookies page via link on form and return" do
    given_a_user_is_struggling_because_of_coronavirus
    expect_to_be_on_need_help_page
    click_on_cookies_link
    expect_to_be_on_cookies_page
    click_on_back_link
    expect_to_be_on_need_help_page
  end

  def expect_to_be_on_cookies_page
    expect(page).to have_content(I18n.t("cookies.title"))
  end

  def click_on_cookies_link
    click_on I18n.t("cookies.title")
  end
end
