# frozen_string_literal: true

Rails.application.routes.draw do
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  get "/healthcheck", to: proc { [200, {}, %w[OK]] }

  get "/", to: redirect("https://www.gov.uk/")

  scope module: "coronavirus_form" do
    get "/privacy", to: "privacy#show"
    get "/accessibility-statement", to: "accessibility_statement#show"

    # Question: Do you need urgent medical help?
    get "/urgent-medical-help", to: "urgent_medical_help#show"
    post "/urgent-medical-help", to: "urgent_medical_help#submit"

    # Question: Have you been made unemployed or put on temporary leave (furloughed)?
    get "/have-you-been-made-unemployed", to: "have_you_been_made_unemployed#show"
    post "/have-you-been-made-unemployed", to: "have_you_been_made_unemployed#submit"

    # Question: Are you still going in to work even though you're not a key worker?
    get "/still-working", to: "still_working#show"
    post "/still-working", to: "still_working#submit"

    get "/living-with-vulnerable", to: "living_with_vulnerable#show"
    post "/living-with-vulnerable", to: "living_with_vulnerable#submit"

    get "/session-expired", to: "session_expired#show"
  end

  mount GovukPublishingComponents::Engine, at: "/component-guide"
end
