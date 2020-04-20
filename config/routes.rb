# frozen_string_literal: true
    
Rails.application.routes.draw do
  scope "(:locale)", locale: /#{I18n.available_locales.join("|")}/ do

      # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
      get "/healthcheck", to: proc { [200, {}, %w[OK]] }
    
      get "/", to: redirect("/urgent-medical-help")
    
      scope module: "coronavirus_form" do
        get "/privacy", to: "privacy#show"
        get "/cookies", to: "cookies#show"
        get "/accessibility-statement", to: "accessibility_statement#show"
    
        # Question: Do you need urgent medical help?
        get "/urgent-medical-help", to: "urgent_medical_help#show"
        post "/urgent-medical-help", to: "urgent_medical_help#submit"
    
        # NHS Triage: Get urgent help from the NHS now
        get "/get-help-from-nhs", to: "get_help_from_nhs#show"
    
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
    
        # Question: Are you off work because you’re ill or self-isolating?
        get "/are-you-off-work-ill", to: "are_you_off_work_ill#show"
        post "/are-you-off-work-ill", to: "are_you_off_work_ill#submit"
    
        # Question: Are you self-employed or a sole trader?
        get "/self-employed", to: "self_employed#show"
        post "/self-employed", to: "self_employed#submit"
    
        # Question: Are you worried about going into work because you live with someone vulnerable to coronavirus?
        get "/living-with-vulnerable", to: "living_with_vulnerable#show"
        post "/living-with-vulnerable", to: "living_with_vulnerable#submit"
    
        # Question: Have you got somewhere to live?
        get "/have-somewhere-to-live", to: "have_somewhere_to_live#show"
        post "/have-somewhere-to-live", to: "have_somewhere_to_live#submit"
    
        # Question: Have you been evicted?
        get "/have-you-been-evicted", to: "have_you_been_evicted#show"
        post "/have-you-been-evicted", to: "have_you_been_evicted#submit"
    
        # Question: Are you worried about your mental health or someone else's mental health?
        get "/mental-health-worries", to: "mental_health_worries#show"
        post "/mental-health-worries", to: "mental_health_worries#submit"
    
        # Question: Are you able to leave your home if absolutely necessary?
        get "/able-to-leave", to: "able_to_leave#show"
        post "/able-to-leave", to: "able_to_leave#submit"
    
        # Question: What do you need to find help with?
        get "/need-help-with", to: "need_help_with#show"
        post "/need-help-with", to: "need_help_with#submit"
    
        # Results
        get "/results", to: "results#show"
    
        get "/clear-session", to: "session#delete"
    
        get "/session-expired", to: "session_expired#show"
    
        get "/data-export", to: "data_export#show"
      end
    
      mount GovukPublishingComponents::Engine, at: "/component-guide"
  end

end
