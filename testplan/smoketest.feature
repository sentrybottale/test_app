Feature: Currency Converter Smoke Test
  As a user of the currency converter app
  I want to convert amounts between different currencies
  So that I can manage my finances in multiple currencies

Background:
    Given the user has a balance of 1000 EUR and 0 USD
    And the exchange rate is 1 EUR = 1.129 USD

  Scenario: S1 Convert a valid amount from EUR to USD
    Given the user is on the currency converter page
    When the user selects to sell 100 EUR
    And the user submits the conversion
    Then the user should receive 112.9 USD
    And the user's balance should be updated to 900 EUR and 112.9 USD
    And a confirmation message should display "You have converted 100.00 EUR to 112.90 USD. Commission Fee - 0.00 EUR."

  Scenario: S2 Convert a larger valid amount from EUR to USD
    Given the user is on the currency converter page
    When the user selects to sell 500 EUR
    And the user submits the conversion
    Then the user should receive 564.5 USD
    And the user's balance should be updated to 500 EUR and 564.5 USD
    And a confirmation message should display "You have converted 500.00 EUR to 564.50 USD. Commission Fee - 0.00 EUR."

  Scenario: S3 Attempt to convert zero amount
    Given the user is on the currency converter page
    When the user selects to sell 0 EUR
    And the user submits the conversion
    Then the user should receive 0 USD
    And the user's balance should remain 1000 EUR and 0 USD
    And no confirmation message should be displayed

  Scenario: S4 Attempt to convert more EUR than available balance
    Given the user is on the currency converter page
    When the user selects to sell 1500 EUR
    And the user submits the conversion
    Then the conversion should fail
    And the user's balance should remain 1000 EUR and 0 USD
    And an error message should display "Insufficient balance to complete the conversion."

  Scenario: S5 Verify balance updates after multiple conversions
    Given the user is on the currency converter page
    When the user selects to sell 100 EUR
    And the user submits the conversion
    And the user selects to sell 500 EUR
    And the user submits the conversion
    Then the user should receive a total of 677.4 USD
    And the user's balance should be updated to 400 EUR and 677.4 USD

  Scenario: S6 Verify dropdown selection for currencies
    Given the user is on the currency converter page
    When the user clicks the "Sell" currency dropdown
    Then the dropdown should display available currencies including "EUR"
    When the user clicks the "Receive" currency dropdown
    Then the dropdown should display available currencies including "USD"