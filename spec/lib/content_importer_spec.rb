require "tempfile"
require "csv"

RSpec.describe "ContentImporter" do
  include FixturesHelper

  describe "#import_results_links" do
    let(:test_csv_path) { Rails.root.join("spec/fixtures/result_links_test.csv").to_s }
    let(:output_locale) { ContentImporter.import_results_links(test_csv_path) }

    it "outputs result links nested under the correct groups" do
      expect(output_locale.keys).to eql(locale_import_data_fixture.keys)
    end

    it "outputs results links nested under the correct subgroups" do
      output_subgroups = output_locale.keys.map { |group_key| output_locale[group_key].keys }
      expected_subgroups = locale_import_data_fixture.keys.map { |group_key| locale_import_data_fixture[group_key].keys }

      expect(output_subgroups).to eql(expected_subgroups)
    end

    it "outputs text only items with id and text key value pairs" do
      output_item = output_locale["group_one"]["subgroup_one"]["items"].first
      expected_item = locale_import_data_fixture["group_one"]["subgroup_one"]["items"].first
      expect(output_item.keys).to match_array(%w[id text])
      expect(output_item.values).to eql(expected_item.values)
    end

    it "outputs hyperlink text with id, href and text key value pairs" do
      output_item = output_locale["group_one"]["subgroup_one"]["items"][1]
      expected_item = locale_import_data_fixture["group_one"]["subgroup_one"]["items"][1]
      expect(output_item.keys).to match_array(%w[id text href])
      expect(output_item.values).to match_array(expected_item.values)
    end

    it "outputs conditional hyperlink text with id, href, text key, national criteria value pairs" do
      output_item = output_locale["group_one"]["subgroup_one"]["items"][2]
      expect(output_item.keys).to match_array(%w[id text href show_to_nations])
      expect(output_item["show_to_nations"]).to match_array(%w[Wales])
    end

    it "outputs support and advice link as a sibling of items" do
      output_item = output_locale["group_one"]["subgroup_one"]
      expected_item = locale_import_data_fixture["group_one"]["subgroup_one"]
      expect(output_item.keys).to match_array(%w[items support_and_advice])
      expect(output_item["support_and_advice"]).to match_array(expected_item["support_and_advice"])
    end

    it "outputs multiple OR conditional hyperlink text with id, href, text key, national criteria value pairs" do
      output_item = output_locale["group_one"]["subgroup_one"]["support_and_advice"].first
      expect(output_item.keys).to match_array(%w[id text href show_to_nations])
      expect(output_item["show_to_nations"]).to match_array(%w[Wales Scotland England])
    end

    it "outputs a show_to_vulnerable_person true toggle if true in csv" do
      output_item = output_locale["group_two"]["subgroup_one"]["items"].first
      expect(output_item["show_to_vulnerable_person"]).to be(true)
    end

    it "should prune show_to_vulnerable_person keys that are empty" do
      output_item = output_locale["group_one"]["subgroup_two"]["items"].first
      expect(output_item["show_to_vulnerable_person"]).to be(nil)
    end
  end

  describe "#overwrite_locale_links" do
    let(:test_input_file) { "spec/fixtures/en.test.yml" }
    let(:temp_test_output_file) { Tempfile.new("en.temp_test.yml") }
    let(:test_csv_path) { Rails.root.join("spec/fixtures/result_links_test.csv").to_s }

    after(:each) do
      temp_test_output_file.delete
    end

    it "writes out to a YAML file" do
      lines_written = ContentImporter.overwrite_locale_links(
        test_input_file,
        locale_import_data_fixture,
        temp_test_output_file,
      )
      expect(lines_written).to be > 1 # check we write more than 1 line, amount varies as we add to locale
    end

    it "changes the YAML file that is already there" do
      expect(YAML.load_file(temp_test_output_file)).to eql(false)
      ContentImporter.overwrite_locale_links(
        test_input_file,
        locale_import_data_fixture,
        temp_test_output_file,
      )
      expect(YAML.load_file(temp_test_output_file)).not_to eql(YAML.load_file(test_input_file))
    end

    it "other parts of the locale file remain unchanged" do
      expect(YAML.load_file(temp_test_output_file)).to eql(false)
      ContentImporter.overwrite_locale_links(
        test_input_file,
        locale_import_data_fixture,
        temp_test_output_file,
      )
      expect(YAML.load_file(temp_test_output_file)["en"]["other_stuff"]["key"]).to eql("This never changes")
    end
  end
end
