RSpec.describe "data-export-results-links", type: :request do
  let(:csv_fixture) do
    "id,status,group_and_subgroup,text,href,show_to_nations,group_key,subgroup_key,support_and_advice\n"\
    "0001,Live,I am the title for Group one | I am the title for Group one subgroup one,\"This is a row that only has text, it will appear like a paragraph\",\"\",\"\",group_one,subgroup_one,false\n"\
    "0002,Live,I am the title for Group one | I am the title for Group one subgroup one,\"This is a row and has text and an href, it will appear as an anchor tag\",http://test.stubbed.gov.uk,\"\",group_one,subgroup_one,false\n"\
    "0003,Live,I am the title for Group one | I am the title for Group one subgroup one,\"This is a row and has text, an href and group criteria, it will appear as an anchor tag if the user's answers match the criteria\",http://test.stubbed.llyw.cymru,Wales,group_one,subgroup_one,false\n"\
    "0004,Live,I am the title for Group one | I am the title for Group one subgroup one | Support and Advice,\"This is a row and has text, an href and multiple group criteria, it will appear as an anchor tag if the user's answers match the more complex criteria\",http://test.stubbed.gb.gov.uk,Wales OR Scotland OR England,group_one,subgroup_one,true\n"\
    "0005,Live,I am the title for Group one | I am the title for Group one subgroup two,\"This is a row that only has text, it will appear like a paragraph\",\"\",\"\",group_one,subgroup_two,false\n"\
    "0006,Live,I am the title for Group two | I am the title for Group two subgroup one,\"This is a row that only has text, it will appear like a paragraph\",\"\",\"\",group_two,subgroup_one,false\n"
  end

  before do
    allow(ContentExporter).to receive(:generate_results_link_csv) { csv_fixture }
  end

  describe "GET /data-export-results-links" do
    context "with basic auth enabled" do
      it "rejects unauthenticated users" do
        get data_export_results_links_path,
            headers: {
              "HTTP_ACCEPT" => "text/csv",
            }
        expect(response).to have_http_status(401)
      end

      it "permits authenticated users" do
        username = ENV["DATA_EXPORT_BASIC_AUTH_USERNAME"]
        password = ENV["DATA_EXPORT_BASIC_AUTH_PASSWORD"]
        get data_export_results_links_path,
            headers: {
              "HTTP_ACCEPT" => "text/csv",
              "HTTP_AUTHORIZATION" => ActionController::HttpAuthentication::Basic.encode_credentials(username, password),
            }
        expect(response).to have_http_status(200)
      end
    end

    it "returns all results links in CSV format" do
      username = ENV["DATA_EXPORT_BASIC_AUTH_USERNAME"]
      password = ENV["DATA_EXPORT_BASIC_AUTH_PASSWORD"]
      get data_export_results_links_path,
          headers: {
            "HTTP_ACCEPT" => "text/csv",
            "HTTP_AUTHORIZATION" => ActionController::HttpAuthentication::Basic.encode_credentials(username, password),
          }
      csv_fixture.split("\n").each { |line| expect(response.body).to have_content(line) }
    end
  end
end
