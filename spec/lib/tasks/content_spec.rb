RSpec.describe "content:export_results_to_csv" do
  include_context "rake"

  before do
    allow(ContentExporter).to receive(:generate_results_link_csv).and_return("csv\n woop")
  end

  it "should include environment as a prerequsite" do
    expect(subject.prerequisites).to include("environment")
  end

  it "generates a csv with results links" do
    allow(ContentExporter).to receive(:generate_results_link_csv)
    subject.invoke
    expect(ContentExporter).to have_received(:generate_results_link_csv)
  end
end
