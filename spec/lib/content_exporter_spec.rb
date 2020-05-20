locale_results_link_fixture = {
  group_one: {
    subgroup_one: {
      title: "I am the title for Group one subgroup one",
      items: [
        {
          id: "0001",
          text: "This is a row that only has text, it will appear like a paragraph",
        },
        {
          id: "0002",
          text: "This is a row and has text and an href, it will appear as an anchor tag",
          href: "http://test.stubbed.gov.uk",
        },
        {
          id: "0003",
          text: "This is a row and has text, an href and group criteria, it will appear as an anchor tag if the user's answers match the criteria",
          href: "http://test.stubbed.llyw.cymru",
          show_to_nations: %w[Wales],
        },
      ],
      support_and_advice_items: [
        {
          id: "0004",
          text: "This is a row and has text, an href and multiple group criteria, it will appear as an anchor tag if the user's answers match the more complex criteria",
          href: "http://test.stubbed.gb.gov.uk",
          show_to_nations: %w[Wales Scotland England],
        },
      ],
    },
    subgroup_two: {
      title: "I am the title for Group one subgroup two",
      items: [{ id: "0005", text: "This is a row that only has text, it will appear like a paragraph" }],
    },
  },
  group_two: {
    subgroup_one: {
      title: "I am the title for Group two subgroup one",
      items: [{ id: "0006", text: "This is a row that only has text, it will appear like a paragraph" }],
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
      {
        id: "0001",
        status: "Live",
        group_and_subgroup: "I am the title for Group one | I am the title for Group one subgroup one",
        href: "",
        show_to_nations: "",
        support_and_advice: false,
        text: "This is a row that only has text, it will appear like a paragraph",
        group_key: "group_one",
        subgroup_key: "subgroup_one",
      },
      {
        id: "0002",
        status: "Live",
        group_and_subgroup: "I am the title for Group one | I am the title for Group one subgroup one",
        href: "http://test.stubbed.gov.uk",
        show_to_nations: "",
        support_and_advice: false,
        text: "This is a row and has text and an href, it will appear as an anchor tag",
        group_key: "group_one",
        subgroup_key: "subgroup_one",
      },
      {
        id: "0003",
        status: "Live",
        group_and_subgroup: "I am the title for Group one | I am the title for Group one subgroup one",
        href: "http://test.stubbed.llyw.cymru",
        show_to_nations: "Wales",
        support_and_advice: false,
        text: "This is a row and has text, an href and group criteria, it will appear as an anchor tag if the user's answers match the criteria",
        group_key: "group_one",
        subgroup_key: "subgroup_one",
      },
      {
        id: "0004",
        status: "Live",
        group_and_subgroup: "I am the title for Group one | I am the title for Group one subgroup one | Support and Advice",
        href: "http://test.stubbed.gb.gov.uk",
        show_to_nations: "Wales OR Scotland OR England",
        support_and_advice: true,
        text: "This is a row and has text, an href and multiple group criteria, it will appear as an anchor tag if the user's answers match the more complex criteria",
        group_key: "group_one",
        subgroup_key: "subgroup_one",
      },
      {
        id: "0005",
        status: "Live",
        group_and_subgroup: "I am the title for Group one | I am the title for Group one subgroup two",
        href: "",
        show_to_nations: "",
        support_and_advice: false,
        text: "This is a row that only has text, it will appear like a paragraph",
        group_key: "group_one",
        subgroup_key: "subgroup_two",
      },
      {
        id: "0006",
        status: "Live",
        group_and_subgroup: "I am the title for Group two | I am the title for Group two subgroup one",
        href: "",
        show_to_nations: "",
        support_and_advice: false,
        text: "This is a row that only has text, it will appear like a paragraph",
        group_key: "group_two",
        subgroup_key: "subgroup_one",
      },
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

    it "returns a single string when a link has a single :show_to_nations criteria" do
      expect(results_rows[2][:show_to_nations]).to eq("Wales")
    end

    it "returns a single string with joined with OR when a link has multiple :show_to_nations criteria" do
      expect(results_rows[3][:show_to_nations]).to eq("Wales OR Scotland OR England")
    end

    it "returns a href URL string when a link has a href value" do
      expect(results_rows[1][:href]).to eq("http://test.stubbed.gov.uk")
    end

    it "returns an empty string when a link has no href value" do
      expect(results_rows[0][:href]).to eq("")
    end

    it "returns a concatianted heading string if there is a group and subgroup title" do
      expect(results_rows[0][:group_and_subgroup]).to eq("I am the title for Group one | I am the title for Group one subgroup one")
    end

    it "returns a concatinated heading string with Support and Advice on the end if it's a support and advice link" do
      expect(results_rows[3][:group_and_subgroup]).to eq("I am the title for Group one | I am the title for Group one subgroup one | Support and Advice")
    end

    it "returns a text string when a link has a text value" do
      expect(results_rows[0][:text]).to eq("This is a row that only has text, it will appear like a paragraph")
    end

    it "returns a boolean support_and_advice true when the link is under support_and_advice" do
      expect(results_rows[3][:support_and_advice]).to be(true)
    end

    it "returns a boolean support_and_advice false when the link is under items" do
      expect(results_rows[0][:support_and_advice]).to be(false)
    end

    it "returns raises an error when a link does not have a id value" do
      broken_result_fixture = { group_one: { subgroup_one: { title: "Title", items: [{ text: "bloop" }] } } }
      allow(I18n).to receive(:t).with("results_link") { broken_result_fixture }
      expect { results_rows }.to raise_error(KeyError, "key not found: :id")
    end

    it "returns raises an error when a link does not have a text value" do
      broken_result_fixture = { group_one: { subgroup_one: { title: "Title", items: [{ id: "0001" }] } } }
      allow(I18n).to receive(:t).with("results_link") { broken_result_fixture }
      expect { results_rows }.to raise_error(KeyError, "key not found: :text")
    end

    it "returns raises an error when a link does not have a group.title value" do
      broken_group_fixture = { group_one: {} }
      allow(I18n).to receive(:t).with("coronavirus_form.groups") { broken_group_fixture }
      expect { results_rows }.to raise_error(KeyError, "key not found: :title")
    end

    it "returns raises an error when a link does not have a subgroup :title value" do
      broken_result_fixture = { group_one: { subgroup_one: { items: [{ id: "0001", text: "bloop" }] } } }
      allow(I18n).to receive(:t).with("results_link") { broken_result_fixture }
      expect { results_rows }.to raise_error(KeyError, "key not found: :title")
    end
  end

  describe "#generate_results_link_csv" do
    csv_fixture = "id,status,group_and_subgroup,text,href,show_to_nations,group_key,subgroup_key,support_and_advice\n"\
    "0001,Live,I am the title for Group one | I am the title for Group one subgroup one,\"This is a row that only has text, it will appear like a paragraph\",\"\",\"\",group_one,subgroup_one,false\n"\
    "0002,Live,I am the title for Group one | I am the title for Group one subgroup one,\"This is a row and has text and an href, it will appear as an anchor tag\",http://test.stubbed.gov.uk,\"\",group_one,subgroup_one,false\n"\
    "0003,Live,I am the title for Group one | I am the title for Group one subgroup one,\"This is a row and has text, an href and group criteria, it will appear as an anchor tag if the user's answers match the criteria\",http://test.stubbed.llyw.cymru,Wales,group_one,subgroup_one,false\n"\
    "0004,Live,I am the title for Group one | I am the title for Group one subgroup one | Support and Advice,\"This is a row and has text, an href and multiple group criteria, it will appear as an anchor tag if the user's answers match the more complex criteria\",http://test.stubbed.gb.gov.uk,Wales OR Scotland OR England,group_one,subgroup_one,true\n"\
    "0005,Live,I am the title for Group one | I am the title for Group one subgroup two,\"This is a row that only has text, it will appear like a paragraph\",\"\",\"\",group_one,subgroup_two,false\n"\
    "0006,Live,I am the title for Group two | I am the title for Group two subgroup one,\"This is a row that only has text, it will appear like a paragraph\",\"\",\"\",group_two,subgroup_one,false\n"

    let(:csv) { ContentExporter.generate_results_link_csv }

    before do
      allow(I18n).to receive(:t).with("results_link") { locale_results_link_fixture }
      allow(I18n).to receive(:t).with("coronavirus_form.groups") { locale_form_groups_fixture }
    end

    it "outputs a csv with correct headers" do
      expect(csv.split("\n").first).to eql("id,status,group_and_subgroup,text,href,show_to_nations,group_key,subgroup_key,support_and_advice")
    end

    it "outputs a well formatted csv" do
      expect(csv).to eql(csv_fixture)
    end
  end
end
