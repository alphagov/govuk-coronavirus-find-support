Feature: Filling in the form
  In order to complete the form
  As a user
  I want to be able to answer questions

Scenario: Visits the start of the form
    When I visit "/live-in-england"
    Then I can see the live_in_england page content
    And I can see the live_in_england radio button options
    And I choose Yes
    And I click the Continue button
    Then I will be redirected to "/nhs-letter"

Scenario: Visits an intermediate question
    When I visit "/essential-supplies"
    Then I will be redirected to "/live-in-england" 
