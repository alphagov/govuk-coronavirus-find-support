namespace :content do
  desc "Exports results link content from en.yml to a csv"
  task export_results_to_csv: :environment do
    csv_data = ContentExporter.generate_results_link_csv
    File.open("tmp/results_links.csv", "w") { |file| file.write(csv_data) }
  end

  desc "Imports results link content from en.yml to a csv"
  task :import_locale_links, [:file_path] => :environment do |_, args|
    new_result_links = ContentImporter.import_results_links(args.fetch(:file_path))
    ContentImporter.overwrite_locale_links("config/locales/en.yml", new_result_links)
  rescue KeyError
    puts "Please provoide a file path"
  end
end
