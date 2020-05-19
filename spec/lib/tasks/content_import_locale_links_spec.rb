RSpec.describe "content:import_locale_links" do
  include_context "rake"

  it "should include environment as a prerequsite" do
    expect(subject.prerequisites).to include("environment")
  end

  before do
    allow(ContentImporter).to receive(:import_results_links)
    allow(ContentImporter).to receive(:overwrite_locale_links)
  end

  it "imports result links from a csv" do
    subject.invoke("spec/fixtures/result_links_test.csv")
    expect(ContentImporter).to have_received(:import_results_links)
  end

  it "imports overwrites the existing file with the results" do
    subject.invoke("spec/fixtures/result_links_test.csv")
    expect(ContentImporter).to have_received(:overwrite_locale_links)
  end

  it "should print warning to the console if no path is provided" do
    expect { subject.invoke }.to output("Please provoide a file path\n").to_stdout
  end
end
