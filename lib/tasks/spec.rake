namespace :spec do
  desc "Run Javascript specs using Jasmine"
  task javascript: :environment do
    Rake::Task["jasmine:ci"].invoke
  end
end
