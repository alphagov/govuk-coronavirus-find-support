RSpec.describe "get-help-from-nhs" do
  describe "GET /get-help-from-nhs" do
    it "shows the page" do
      visit get_help_from_nhs_path

      expect(page.body).to have_content I18n.t("get_help_from_nhs.title")
      expect(page.body).to have_link I18n.t("get_help_from_nhs.link_text"), href: I18n.t("get_help_from_nhs.link_href")
    end
  end
end
