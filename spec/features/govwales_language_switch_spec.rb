# frozen_string_literal: true

require "spec_helper"

RSpec.feature "GovWales language switch" do
  context "English to Welsh" do
    scenario "Switch from start page" do
      visit "/start"

      expect(current_path).to eq "/need-help-with"
      expect(page).to have_text("Find help if you’re struggling because of coronavirus")

      within "header .header__components__language" do
        click_link "Cymraeg"
      end

      expect(current_path).to eq "/angen-help-gyda" # angen-help-gyda = need-help-with

      expect(page).to have_css("header .header__components__language", text: "English")

      expect(page).to have_text(
        "Dod o hyd i help os ydych yn cael pethau'n anodd oherwydd y coronafeirws",
      )
    end

    scenario "Switch whilst in the journey" do
      visit "/start"
      check "Paying bills"
      click_on "Continue"

      expect(current_path).to eq "/afford-rent-mortgage-bills"

      within "header .header__components__language" do
        click_link "Cymraeg"
      end

      # When switching to Welsh, the user is taken back to the start of the journey
      expect(current_path).to eq "/angen-help-gyda"
    end

    scenario "Switch whilst on the Privacy page" do
      visit "/cookies"

      expect(current_path).to eq "/cookies"
      expect(page).to have_css("h1", text: "Cookies")

      within "header .header__components__language" do
        click_link "Cymraeg"
      end

      expect(current_path).to eq "/cwcis"
      expect(page).to have_css("h1", text: "Cwcis")
    end

    scenario "Switch whilst on the Privacy page" do
      visit "/privacy"

      expect(current_path).to eq "/privacy"
      expect(page).to have_css("h1", text: "Website privacy notice")

      within "header .header__components__language" do
        click_link "Cymraeg"
      end

      expect(current_path).to eq "/preifatrwydd"
      expect(page).to have_css("h1", text: "Hysbysiad preifatrwydd gwefan")
    end
  end

  context "Welsh to English" do
    scenario "Switch from start page" do
      visit "/dechrau" # dechrau = start

      expect(current_path).to eq "/angen-help-gyda" # angen-help-gyda = need-help-with
      expect(page).to have_text(
        "Dod o hyd i help os ydych yn cael pethau'n anodd oherwydd y coronafeirws",
      )

      within "header .header__components__language" do
        click_link "English"
      end

      expect(current_path).to eq "/need-help-with"
      expect(page).to have_css("header .header__components__language", text: "Cymraeg")

      expect(page).to have_text("Find help if you’re struggling because of coronavirus")
    end

    scenario "Switch whilst in the journey" do
      visit "/dechrau"
      check "Talu biliau"
      click_on "Parhau"

      expect(current_path).to eq "/fforddio-rhent-morgais-biliau" # afford-rent-mortgage-bills

      within "header .header__components__language" do
        click_link "English"
      end

      # When switching to English, the user is taken back to the start of the journey
      expect(current_path).to eq "/need-help-with"
    end

    scenario "Switch whilst on the cookies page" do
      visit "/cwcis" # cookies

      expect(current_path).to eq "/cwcis"
      expect(page).to have_css("h1", text: "Cwcis")

      within "header .header__components__language" do
        click_link "English"
      end

      expect(current_path).to eq "/cookies"
      expect(page).to have_css("h1", text: "Cookies")
    end

    scenario "Switch whilst on the Privacy page" do
      visit "/preifatrwydd"

      expect(current_path).to eq "/preifatrwydd"
      expect(page).to have_css("h1", text: "Hysbysiad preifatrwydd gwefan")

      within "header .header__components__language" do
        click_link "English"
      end

      expect(current_path).to eq "/privacy"
      expect(page).to have_css("h1", text: "Website privacy notice")
    end
  end
end
