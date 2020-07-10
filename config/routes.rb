# frozen_string_literal: true

Rails.application.routes.draw do
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  get "/healthcheck", to: proc { [200, {}, %w[OK]] }

  get "/", to: redirect("https://www.gov.uk/find-coronavirus-support")

  scope module: "coronavirus_form" do
    first_question = "/nation"

    get "/start", to: redirect(path: first_question)

    get "/privacy", to: "privacy#show"
    get "/cookies", to: "cookies#show"
    get "/accessibility-statement", to: "accessibility_statement#show"

    # Redirect for deleted question and page (301 is default)
    get "/urgent-medical-help", to: redirect(first_question)
    get "/get-help-from-nhs", to: redirect(first_question)

    # Redirect for old route (301 is default)
    get "/where-live", to: redirect("/nation")

    # Redirect for old route (301 is default)
    get "/living-with-vulnerable", to: redirect("worried-about-work")

    # Question: Where do you live
    get "/nation", to: "nation#show"
    post "/nation", to: "nation#submit"

    # Question: What do you need to find help with?
    get "/need-help-with", to: "need_help_with#show"
    post "/need-help-with", to: "need_help_with#submit"

    # Question: "Do you feel safe where you live?"
    get "/feel-safe", to: "feel_safe#show"
    post "/feel-safe", to: "feel_safe#submit"

    # Question: Are you finding it hard to afford rent, your mortgage or bills?
    get "/afford-rent-mortgage-bills", to: "afford_rent_mortgage_bills#show"
    post "/afford-rent-mortgage-bills", to: "afford_rent_mortgage_bills#submit"

    # Question: "Are you finding it hard to afford food?"
    get "/afford-food", to: "afford_food#show"
    post "/afford-food", to: "afford_food#submit"

    # Question: Are you able to get food?
    get "/get-food", to: "get_food#show"
    post "/get-food", to: "get_food#submit"

    # Question: Have you been made unemployed or put on temporary leave (furloughed)?
    get "/have-you-been-made-unemployed", to: "have_you_been_made_unemployed#show"
    post "/have-you-been-made-unemployed", to: "have_you_been_made_unemployed#submit"

    # Question: Are you off work because you're ill or self-isolating?
    get "/are-you-off-work-ill", to: "are_you_off_work_ill#show"
    post "/are-you-off-work-ill", to: "are_you_off_work_ill#submit"

    # Question: Are you self-employed or a sole trader?
    get "/self-employed", to: "self_employed#show"
    post "/self-employed", to: "self_employed#submit"

    # Question: Are you worried about going into work?
    get "/worried-about-work", to: "worried_about_work#show"
    post "/worried-about-work", to: "worried_about_work#submit"

    # Question: Have you got somewhere to live?
    get "/have-somewhere-to-live", to: "have_somewhere_to_live#show"
    post "/have-somewhere-to-live", to: "have_somewhere_to_live#submit"

    # Question: Have you been evicted?
    get "/have-you-been-evicted", to: "have_you_been_evicted#show"
    post "/have-you-been-evicted", to: "have_you_been_evicted#submit"

    # Question: Are you worried about your mental health or someone else's mental health?
    get "/mental-health-worries", to: "mental_health_worries#show"
    post "/mental-health-worries", to: "mental_health_worries#submit"

    # Are you able to go out for food, medicine, or health reasons?
    get "/able-to-go-out", to: "able_to_go_out#show"
    post "/able-to-go-out", to: "able_to_go_out#submit"

    # Results
    get "/results", to: "results#show"

    get "/clear-session", to: "session#delete"

    get "/session-expired", to: "session_expired#show"

    get "/data-export", to: "data_export#show"
    get "/data-export-results-links", to: "data_export_results_links#show"

    get "/data-export-checkbox", to: "data_export_checkbox#show"
  end

  mount GovukPublishingComponents::Engine, at: "/component-guide" if Rails.env.development?
  mount JasmineRails::Engine => "/specs" if defined?(JasmineRails)
end
