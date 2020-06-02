# frozen_string_literal: true

require "spec_helper"

RSpec.feature "GovWales furniture" do
  context "English language" do
    before do
      visit "/start"
    end

    scenario "header is rendered" do
      within "body > header" do
        expect(page).to have_css("a[href='https://gov.wales/'][title='Welsh Government']")
        expect(page).to have_css("a img[alt='Welsh Government']")
      end
    end

    scenario "beta-bar is rendered" do
      within ".beta-bar" do
        expect(page).to have_css(".beta-bar__label", text: "BETA")
        expect(page).to have_text("This is a new service.")
        expect(page).to have_text("Give feedback to help improve it.")
        expect(page).to have_css("a[href^='mailto:']", text: "Give feedback")
      end
    end

    scenario "secondary-header is rendered" do
      within "body > .govwales-width-container" do\
        expect(page).to have_css("a.govuk-back-link[href='/']", text: "Back")
        expect(page).to have_text("Finder")
        expect(page).to have_text("Find help if you’re struggling because of coronavirus")
      end
    end

    scenario "footer is rendered" do
      within "body > footer" do
        expect(page).to have_text("Accessibility Cookies Privacy Copyright statement")
        expect(page).to have_css("a[href='https://gov.wales/']")
        expect(page).to have_css("a img[alt='Welsh Government']")
      end
    end
  end

  context "Welsh language" do
    before do
      visit "/dechrau" # dechrau = start
    end

    scenario "header is rendered" do
      within "body > header" do
        expect(page).to have_css("a[href='https://llyw.cymru/'][title='Llywodraeth Cymru']")
        expect(page).to have_css("a img[alt='Llywodraeth Cymru']")
      end
    end

    scenario "beta-bar is rendered" do
      within ".beta-bar" do
        expect(page).to have_css(".beta-bar__label", text: "BETA")
        expect(page).to have_text("Gwasanaeth newydd yw hwn.")
        expect(page).to have_text("Rhowch adborth i'n helpu i'w wella")
        expect(page).to have_css("a[href^='mailto:']", text: "Rhowch adborth")
      end
    end

    scenario "secondary-header is rendered" do
      within "body > .govwales-width-container" do\
        expect(page).to have_css("a.govuk-back-link[href='/']", text: "Yn ôl")
        expect(page).to have_text("Chwiliwr")
        expect(page).to have_text(
          "Dod o hyd i help os ydych yn cael pethau'n anodd oherwydd y coronafeirws",
        )
      end
    end

    scenario "footer is rendered" do
      within "body > footer" do
        expect(page).to have_text("Hygyrchedd Cwcis Preifatrwydd Datganiad hawlfraint")
        expect(page).to have_css("a[href='https://llyw.cymru/']")
        expect(page).to have_css("a img[alt='Llywodraeth Cymru']")
      end
    end
  end
end
