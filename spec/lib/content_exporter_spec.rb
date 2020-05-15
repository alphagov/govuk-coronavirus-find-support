locale_results_link_fixture = {
  group_one: {
    subgroup_one: {
      title: "I am the title for Group one subgroup one",
      items: [
        {
          text: "This is a row that only has text, it will appaer like a paragraph",
        },
        {
          text: "This is a row has text and an href, it will appaer as an anchor tag",
          href: "http://test.stubbed.gov.uk",
        },
        {
          text: "This is a row has text, an href and group criteira, it will appear as an anchor tag if the user's answers match the criteria",
          href: "http://test.stubbed.llyw.cymru",
          show_to_nations: %w[Wales],
        },
        {
          text: "This is a row has text, an href and multiple group criteira, it will appear as an anchor tag if the user's answers match the more complex criteria",
          href: "http://test.stubbed.gb.gov.uk",
          show_to_nations: %w[Wales Scotland England],
        },
      ],
    },
    subgroup_two: {
      title: "I am the title for Group one subgroup two",
      items: [{ text: "This is a row that only has text, it will appaer like a paragraph" }],
    },
  },
  group_two: {
    subgroup_one: {
      title: "I am the title for Group two subgroup one",
      items: [{ text: "This is a row that only has text, it will appaer like a paragraph" }],
    },
  },
}

locale_form_groups_fixture = {
  group_one: { title: "I am the title for Group one" },
  group_two: { title: "I am the title for Group two" },
}

RSpec.describe "ContentExporter" do
  describe "#extract_results_links" do
    let(:results_rows) { ContentExporter.extract_results_links }

    results_row_fixture = [
      { group_title: "I am the title for Group one",
        href: "",
        show_to_nations: "",
        subgroup_title: "I am the title for Group one subgroup one",
        text: "This is a row that only has text, it will appaer like a paragraph" },
      { group_title: "I am the title for Group one",
        href: "http://test.stubbed.gov.uk",
        show_to_nations: "",
        subgroup_title: "I am the title for Group one subgroup one",
        text: "This is a row has text and an href, it will appaer as an anchor tag" },
      { group_title: "I am the title for Group one",
        href: "http://test.stubbed.llyw.cymru",
        show_to_nations: "Wales",
        subgroup_title: "I am the title for Group one subgroup one",
        text: "This is a row has text, an href and group criteira, it will appear as an anchor tag if the user's answers match the criteria" },
      { group_title: "I am the title for Group one",
        href: "http://test.stubbed.gb.gov.uk",
        show_to_nations: "Wales OR Scotland OR England",
        subgroup_title: "I am the title for Group one subgroup one",
        text: "This is a row has text, an href and multiple group criteira, it will appear as an anchor tag if the user's answers match the more complex criteria" },
      { group_title: "I am the title for Group one",
        href: "",
        show_to_nations: "",
        subgroup_title: "I am the title for Group one subgroup two",
        text: "This is a row that only has text, it will appaer like a paragraph" },
      { group_title: "I am the title for Group two",
        href: "",
        show_to_nations: "",
        subgroup_title: "I am the title for Group two subgroup one",
        text: "This is a row that only has text, it will appaer like a paragraph" },
    ]

    before do
      allow(I18n).to receive(:t).with("results_link") { locale_results_link_fixture }
      allow(I18n).to receive(:t).with("coronavirus_form.groups") { locale_form_groups_fixture }
    end

    it "returns an array of result link rows" do
      expect(results_rows).to eq(results_row_fixture)
    end

    it "returns an empty string value when a link doesn't have :show_to_nations criteria" do
      expect(results_rows[0][:show_to_nations]).to eq("")
    end

    it "returns a single string when a link has a single :show_to_nations criteira" do
      expect(results_rows[2][:show_to_nations]).to eq("Wales")
    end

    it "returns a singe string with joined with OR when a link has multiple :show_to_nations criteira" do
      expect(results_rows[3][:show_to_nations]).to eq("Wales OR Scotland OR England")
    end

    it "returns a href URL string when a link has a href value" do
      expect(results_rows[1][:href]).to eq("http://test.stubbed.gov.uk")
    end

    it "returns an empty string when a link has no href value" do
      expect(results_rows[0][:href]).to eq("")
    end

    it "returns a heading string when a link has a group_title value" do
      expect(results_rows[0][:group_title]).to eq("I am the title for Group one")
    end

    it "returns a heading string when a link has a subgroup_title value" do
      expect(results_rows[0][:subgroup_title]).to eq("I am the title for Group one subgroup one")
    end

    it "returns a text string when a link has a text value" do
      expect(results_rows[0][:text]).to eq("This is a row that only has text, it will appaer like a paragraph")
    end

    it "returns raises an error when a link does not have a text value" do
      broken_result_fixture = { group_one: { subgroup_one: { title: "Title", items: [{}] } } }
      allow(I18n).to receive(:t).with("results_link") { broken_result_fixture }
      expect { results_rows }.to raise_error(KeyError, "key not found: :text")
    end

    it "returns raises an error when a link does not have a group.title value" do
      broken_group_fixture = { group_one: {} }
      allow(I18n).to receive(:t).with("coronavirus_form.groups") { broken_group_fixture }
      expect { results_rows }.to raise_error(KeyError, "key not found: :title")
    end

    it "returns raises an error when a link does not have a subgroup :title value" do
      broken_result_fixture = { group_one: { subgroup_one: { items: [{ text: "bloop" }] } } }
      allow(I18n).to receive(:t).with("results_link") { broken_result_fixture }
      expect { results_rows }.to raise_error(KeyError, "key not found: :title")
    end
  end

  describe "#generate_results_link_csv" do
    csv_fixture = "group_title,subgroup_title,text,href,show_to_nations\n" \
      "I am the title for Group one,I am the title for Group one subgroup one,\"This is a row that only has text, it will appaer like a paragraph\",\"\",\"\"\n" \
      "I am the title for Group one,I am the title for Group one subgroup one,\"This is a row has text and an href, it will appaer as an anchor tag\",http://test.stubbed.gov.uk,\"\"\n" \
      "I am the title for Group one,I am the title for Group one subgroup one,\"This is a row has text, an href and group criteira, it will appear as an anchor tag if the user's answers match the criteria\",http://test.stubbed.llyw.cymru,Wales\n" \
      "I am the title for Group one,I am the title for Group one subgroup one,\"This is a row has text, an href and multiple group criteira, it will appear as an anchor tag if the user's answers match the more complex criteria\",http://test.stubbed.gb.gov.uk,Wales OR Scotland OR England\n" \
      "I am the title for Group one,I am the title for Group one subgroup two,\"This is a row that only has text, it will appaer like a paragraph\",\"\",\"\"\nI am the title for Group two,I am the title for Group two subgroup one,\"This is a row that only has text, it will appaer like a paragraph\",\"\",\"\"\n"
    let(:csv) { ContentExporter.generate_results_link_csv }

    before do
      allow(I18n).to receive(:t).with("results_link") { locale_results_link_fixture }
      allow(I18n).to receive(:t).with("coronavirus_form.groups") { locale_form_groups_fixture }
    end

    it "outputs a csv with correct headers" do
      expect(csv.split("\n").first).to eql("group_title,subgroup_title,text,href,show_to_nations")
    end

    it "outputs a well formatted csv" do
      expect(csv).to eql(csv_fixture)
    end
  end
end
