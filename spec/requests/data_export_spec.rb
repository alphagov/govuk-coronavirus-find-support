RSpec.describe "data-export", type: :request do
  let(:start_date) { "2020-04-11" }
  let(:end_date) { "2020-04-13" }

  before do
    FormResponse.create(
      form_response: {
        get_food: I18n.t("coronavirus_form.groups.getting_food.questions.get_food.options.option_yes.label"),
      },
      created_at: "2020-04-10 10:00:00",
    )
    FormResponse.create(
      form_response: {
        get_food: I18n.t("coronavirus_form.groups.getting_food.questions.get_food.options.option_no.label"),
      },
      created_at: "2020-04-10 10:00:00",
    )
    FormResponse.create(
      form_response: {
        get_food: I18n.t("coronavirus_form.groups.getting_food.questions.get_food.options.option_yes.label"),
      },
      created_at: "2020-04-12 10:00:00",
    )
    FormResponse.create(
      form_response: {
        get_food: I18n.t("coronavirus_form.groups.getting_food.questions.get_food.options.option_no.label"),
      },
      created_at: "2020-04-12 10:00:00",
    )
  end

  describe "GET /data-export" do
    context "with basic auth enabled" do
      it "rejects unauthenticated users" do
        get data_export_path,
            headers: {
              "HTTP_ACCEPT" => "text/csv",
            }
        expect(response).to have_http_status(401)
      end

      it "permits authenticated users" do
        username = ENV["DATA_EXPORT_BASIC_AUTH_USERNAME"]
        password = ENV["DATA_EXPORT_BASIC_AUTH_PASSWORD"]
        get data_export_path,
            headers: {
              "HTTP_ACCEPT" => "text/csv",
              "HTTP_AUTHORIZATION" => ActionController::HttpAuthentication::Basic.encode_credentials(username, password),
            }
        expect(response).to have_http_status(200)
      end
    end

    let(:expected_partial) do
      [
        "question|answer|date|count",
        "#{I18n.t('coronavirus_form.groups.getting_food.questions.get_food.title')}|" \
          "#{I18n.t('coronavirus_form.groups.getting_food.questions.get_food.options.option_yes.label')}|" \
          "2020-04-12|" \
          "1",
        "#{I18n.t('coronavirus_form.groups.getting_food.questions.get_food.title')}|" \
          "#{I18n.t('coronavirus_form.groups.getting_food.questions.get_food.options.option_no.label')}|" \
          "2020-04-12|" \
          "1",
      ]
    end

    let(:expected_all_time) do
      [
        "question|answer|date|count",
        "#{I18n.t('coronavirus_form.groups.getting_food.questions.get_food.title')}|" \
          "#{I18n.t('coronavirus_form.groups.getting_food.questions.get_food.options.option_yes.label')}|" \
          "2020-04-10|" \
          "1",
        "#{I18n.t('coronavirus_form.groups.getting_food.questions.get_food.title')}|" \
          "#{I18n.t('coronavirus_form.groups.getting_food.questions.get_food.options.option_no.label')}|" \
          "2020-04-10|" \
          "1",
        "#{I18n.t('coronavirus_form.groups.getting_food.questions.get_food.title')}|" \
          "#{I18n.t('coronavirus_form.groups.getting_food.questions.get_food.options.option_yes.label')}|" \
          "2020-04-12|" \
          "1",
        "#{I18n.t('coronavirus_form.groups.getting_food.questions.get_food.title')}|" \
          "#{I18n.t('coronavirus_form.groups.getting_food.questions.get_food.options.option_no.label')}|" \
          "2020-04-12|" \
          "1",
      ]
    end

    it "shows all expected responses in CSV format for all available dates" do
      username = ENV["DATA_EXPORT_BASIC_AUTH_USERNAME"]
      password = ENV["DATA_EXPORT_BASIC_AUTH_PASSWORD"]
      get data_export_path,
          headers: {
            "HTTP_ACCEPT" => "text/csv",
            "HTTP_AUTHORIZATION" => ActionController::HttpAuthentication::Basic.encode_credentials(username, password),
          }
      expected_all_time.each do |line|
        expect(response.body).to have_content(line)
      end
    end

    it "shows all expected responses in CSV format for a given date range" do
      username = ENV["DATA_EXPORT_BASIC_AUTH_USERNAME"]
      password = ENV["DATA_EXPORT_BASIC_AUTH_PASSWORD"]
      get data_export_path,
          params: { start_date: start_date, end_date: end_date },
          headers: {
            "HTTP_ACCEPT" => "text/csv",
            "HTTP_AUTHORIZATION" => ActionController::HttpAuthentication::Basic.encode_credentials(username, password),
          }

      expected_partial.each do |line|
        expect(response.body).to have_content(line)
      end

      expect(response.body).not_to have_content("2020-04-10|")
    end
  end
end
