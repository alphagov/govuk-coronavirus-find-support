module WriteResponsesHelper
  def write_responses
    unwanted_fields = %w[_csrf_token check_answers_seen current_path previous_path session_id]
    redacted_session = session.to_hash.without(*unwanted_fields)
    unless smoke_tester?
      FormResponse.create(
        form_response: redacted_session,
        created_at: time_hour_floor,
      )
    end
  end

private

  def smoke_tester?
    smoke_test_header = request.env["HTTP_SMOKE_TEST"]
    smoke_test_header.present? && smoke_test_header == "true"
  end

  # We're using this method to reduce the precision of timekeeping so that
  # responses cannot be correlated with analytics data
  def time_hour_floor
    Time.current.beginning_of_hour
  end
end
