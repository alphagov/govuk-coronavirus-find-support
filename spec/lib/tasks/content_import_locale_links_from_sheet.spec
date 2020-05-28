RSpec.describe "content:import_locale_links" do
  include_context "rake"

  it "includes environment as a prerequsite" do
    expect(subject.prerequisites).to include("environment")
  end

  before do
    allow(ENV).to receive(:fetch).with("GOOGLE_SHEET_ID")
    allow(ContentImporter::FromSheet).to receive(:new)
  end

  it "gets the GOOGLE SHEET ID from a local env file" do
    subject.invoke
    expect(ENV).to have_received(:fetch).with("GOOGLE_SHEET_ID") { "abc123" }
  end

  it "creates a new instance of ContentImporter::FromSheet" do
    subject.invoke
    expect(ContentImporter::FromSheet).to have_received(:new).with(
      "abc123",
      "tmp/result_links_sheet_import.csv",
    )
  end

  it "calls .download on the FromSheet instance" do
    subject.invoke
    expect(ContentImporter::FromSheet).to have_received(:download)
  end
end
