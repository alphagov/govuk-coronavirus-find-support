module AnswersHelper
  def questions
    questions ||= YAML.load_file(Rails.root.join("config/locales/en.yml"))
    questions["en"]["coronavirus_form"]["questions"].keys
  end
end
