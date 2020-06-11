require "csv"
require "google/apis/drive_v3"
require "googleauth/stores/file_token_store"

module ContentImporter
module_function

  class FromSheet
    attr_reader :sheet_id, :download_destination

    CREDENTIALS_PATH = "credentials.json".freeze
    # The file token.yaml stores the user's access and refresh tokens, and is
    # created automatically when the authorization flow completes for the first
    # time.
    TOKEN_PATH = "token.yaml".freeze
    AUTH_SCOPE = Google::Apis::DriveV3::AUTH_DRIVE_READONLY
    OOB_URI = "urn:ietf:wg:oauth:2.0:oob".freeze

    def initialize(sheet_id, download_destination)
      @sheet_id = sheet_id
      @download_destination = download_destination
    end

    def download
      drive_service = Google::Apis::DriveV3::DriveService.new
      drive_service.authorization = authorize
      drive_service.export_file(sheet_id,
                                "text/csv",
                                download_dest: download_destination)
      puts "> CSV downloaded to #{download_destination}"
    end

  private

    def authorize
      client_id = Google::Auth::ClientId.from_file(CREDENTIALS_PATH)
      token_store = Google::Auth::Stores::FileTokenStore.new(file: TOKEN_PATH)
      authorizer = Google::Auth::UserAuthorizer.new(client_id, AUTH_SCOPE, token_store)
      user_id = "default"
      credentials = authorizer.get_credentials(user_id)

      unless credentials
        url = authorizer.get_authorization_url(base_url: OOB_URI)
        puts "Open the following URL in the browser and enter the " \
            "resulting code after authorization:\n" + url
        code = STDIN.gets
        credentials = authorizer.get_and_store_credentials_from_code(
          user_id: user_id, code: code, base_url: OOB_URI,
        )
      end
      credentials
    end
  end

  def import_results_links(csv_path)
    csv = CSV.read(csv_path, { headers: true })
    output = csv.each_with_object({}) do |csv_row, results_links|
      next if blank_row?(csv_row)
      next if csv_row.fetch("change_status") == "Withdrawn"

      support_and_advice_items = csv_row.fetch("support_and_advice")
      group_key = csv_row.fetch("group_key").to_sym
      subgroup_key = csv_row.fetch("subgroup_key").to_sym

      link_type = support_and_advice_items.downcase == "true" ? "support_and_advice_items" : "items"
      results_links[group_key] = {} if results_links.dig(group_key).nil?
      results_links[group_key][subgroup_key] = {} if results_links.dig(group_key, subgroup_key).nil?
      if results_links.dig(group_key, subgroup_key, link_type).nil?
        results_links[group_key][subgroup_key][link_type] = []
      end

      show_to_nations = csv_row.fetch("show_to_nations")
      nations = show_to_nations.split(" OR ") if show_to_nations.present?

      show_to_vulnerable_person = csv_row.fetch("show_to_vulnerable_person")
      show_vulnerable_link = show_to_vulnerable_person.downcase == "true" if show_to_vulnerable_person.present?

      results_links[group_key][subgroup_key][link_type] << {
        id: sprintf("%04d", csv_row.fetch("id")), # Zero pad it!
        text: csv_row.fetch("text"),
        href: csv_row.fetch("href"),
        show_to_nations: nations,
        show_to_vulnerable_person: show_vulnerable_link,
      }.reject { |_key, value| value.blank? }
    end
    output.deep_stringify_keys
  end

  def overwrite_locale_links(input_locale_path, locale_hash, output_locale_path = input_locale_path)
    existing_locale_file = YAML.load_file(input_locale_path)
    existing_locale_file["en"]["results_link"].keys.each do |group_key|
      existing_locale_file["en"]["results_link"][group_key].keys.each do |subgroup_key|
        subgroup = existing_locale_file["en"]["results_link"][group_key][subgroup_key]
        subgroup["items"] = [] # Clear out old items in case we removed some on the sheet
        subgroup["support_and_advice_items"] = [] unless subgroup["support_and_advice_items"].nil? # ditto s&a links
        merged_locale = subgroup.merge(locale_hash[group_key][subgroup_key])
        existing_locale_file["en"]["results_link"][group_key][subgroup_key] = merged_locale
      end
    end

    File.open(output_locale_path, "w") do |file|
      file.write(existing_locale_file.to_yaml)
    end
  end

  def blank_row?(row)
    row.fields.all? { |v| [nil, "#N/A"].include?(v) }
  end
end
