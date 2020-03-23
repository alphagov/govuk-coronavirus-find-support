Feature: Filling in the form
  In order to complete the form
  As a user
  I want to be able to answer questions

Scenario: Visits the live in England page
    When I visit the live in England page
    Then I can see the live_in_england page content
    And I can see the live_in_england radio button options
    And I choose Yes
    And I click the Continue button
    Then I will be redirected to the NHS letter page
