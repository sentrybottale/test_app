Feature: Currency Converter Smoke Test Automation

Background: App Preset
  * configure driver = { type: 'android', webDriverPath: "/", start: true, httpConfig: { readTimeout: 120000 } }

Scenario: S0 Verify initial balance

  #Debug info
  * print 'Desired Config:', android.desiredConfig
  Given driver { webDriverSession: { capabilities: { alwaysMatch: "#(android.desiredConfig.alwaysMatch)", firstMatch: "#(android.desiredConfig.firstMatch)" } } }
  #Ensure app is loaded
  * delay(10000)
  # Verify initial balance
  * match driver.text('//android.widget.TextView[@resource-id="com.serheniuk.currencyconversion:id/balance"]') == '1000 EUR'


Scenario: S1 Convert a valid amount from EUR to USD
# Enter amount to sell (100 EUR)
  Given driver { webDriverSession: { capabilities: { alwaysMatch: "#(android.desiredConfig.alwaysMatch)", firstMatch: "#(android.desiredConfig.firstMatch)" } } }
  * driver.input('//android.widget.EditText[@resource-id="com.serheniuk.currencyconversion:id/amountInput"]', '100')
  * match driver.text('//android.widget.EditText[@resource-id="com.serheniuk.currencyconversion:id/amountInput"]') == '100'

  # Verify currency dropdowns (EUR to USD)
  * match driver.text('//android.widget.TextView[@resource-id="com.serheniuk.currencyconversion:id/fromCurrency"]') == 'EUR'
  * match driver.text('//android.widget.TextView[@resource-id="com.serheniuk.currencyconversion:id/toCurrency"]') == 'USD'

  # Submit the conversion
  * driver.click('//android.widget.Button[@resource-id="com.serheniuk.currencyconversion:id/submitButton"]')
  * delay(3000)

  # Verify confirmation message
  * match driver.text('//android.widget.TextView[@resource-id="android:id/message"]') == 'You have converted 100.00 EUR to 112.90 USD. Commission Fee - 0.00 EUR.'
  * driver.click('//android.widget.Button[@resource-id="android:id/button1"]')
  * delay(1000)


  # Verify updated balance (using locate to find elements by text)
  * def eurBalance = locate('//android.widget.TextView[@resource-id="com.serheniuk.currencyconversion:id/balance" and @text="900 EUR"]')
  * def usdBalance = locate('//android.widget.TextView[@resource-id="com.serheniuk.currencyconversion:id/balance" and @text="112.9 USD"]')
  * match eurBalance.text == '900 EUR'
  * match usdBalance.text == '112.9 USD'


Scenario: S2 Convert a larger valid amount from EUR to USD
  Given driver { webDriverSession: { capabilities: { alwaysMatch: "#(android.desiredConfig.alwaysMatch)", firstMatch: "#(android.desiredConfig.firstMatch)" } } }
  # Verify initial balance
  * match driver.text('//android.widget.TextView[@resource-id="com.serheniuk.currencyconversion:id/balance"]') == '1000 EUR'

  # Enter amount to sell (500 EUR)
  * driver.input('//android.widget.EditText[@resource-id="com.serheniuk.currencyconversion:id/amountInput"]', '500')
  * match driver.text('//android.widget.EditText[@resource-id="com.serheniuk.currencyconversion:id/amountInput"]') == '500'

  # Verify currency dropdowns (EUR to USD)
  * match driver.text('//android.widget.TextView[@resource-id="com.serheniuk.currencyconversion:id/fromCurrency"]') == 'EUR'
  * match driver.text('//android.widget.TextView[@resource-id="com.serheniuk.currencyconversion:id/toCurrency"]') == 'USD'

  # Submit the conversion
  * driver.click('//android.widget.Button[@resource-id="com.serheniuk.currencyconversion:id/submitButton"]')
  * delay(3000)

  # Verify confirmation message (500 EUR → 564.5 USD, since 500 * 1.129 = 564.5)
  * match driver.text('//android.widget.TextView[@resource-id="android:id/message"]') == 'You have converted 500.00 EUR to 564.50 USD. Commission Fee - 0.00 EUR.'
  * driver.click('//android.widget.Button[@resource-id="android:id/button1"]')
  * delay(1000)

  # Verify updated balance
  * def eurBalance = locate('//android.widget.TextView[@resource-id="com.serheniuk.currencyconversion:id/balance" and @text="500 EUR"]')
  * def usdBalance = locate('//android.widget.TextView[@resource-id="com.serheniuk.currencyconversion:id/balance" and @text="564.5 USD"]')
  * match eurBalance.text == '500 EUR'
  * match usdBalance.text == '564.5 USD'


Scenario: S3 Attempt to convert zero amount
  Given driver { webDriverSession: { capabilities: { alwaysMatch: "#(android.desiredConfig.alwaysMatch)", firstMatch: "#(android.desiredConfig.firstMatch)" } } }
  # Verify initial balance
  * match driver.text('//android.widget.TextView[@resource-id="com.serheniuk.currencyconversion:id/balance"]') == '1000 EUR'

  # Enter amount to sell (0 EUR)
  * driver.input('//android.widget.EditText[@resource-id="com.serheniuk.currencyconversion:id/amountInput"]', '0')
  * match driver.text('//android.widget.EditText[@resource-id="com.serheniuk.currencyconversion:id/amountInput"]') == '0'

  # Submit the conversion
  * driver.click('//android.widget.Button[@resource-id="com.serheniuk.currencyconversion:id/submitButton"]')
  * delay(3000)

  # Verify no confirmation message appears
  * def confirmationExists = driver.exists('//android.widget.TextView[@resource-id="android:id/message"]')
  * match confirmationExists == false

  # Verify balance remains unchanged
  * def eurBalance = locate('//android.widget.TextView[@resource-id="com.serheniuk.currencyconversion:id/balance" and @text="1000 EUR"]')
  * def usdBalance = locate('//android.widget.TextView[@resource-id="com.serheniuk.currencyconversion:id/balance" and @text="0 USD"]')
  * match eurBalance.text == '1000 EUR'
  * match usdBalance.text == '0 USD'


Scenario: S4 Attempt to convert more EUR than available balance
  Given driver { webDriverSession: { capabilities: { alwaysMatch: "#(android.desiredConfig.alwaysMatch)", firstMatch: "#(android.desiredConfig.firstMatch)" } } }
  # Verify initial balance
  * match driver.text('//android.widget.TextView[@resource-id="com.serheniuk.currencyconversion:id/balance"]') == '1000 EUR'
  * delay(30000000)

  # Enter amount to sell (1500 EUR)
  * driver.input('//android.widget.EditText[@resource-id="com.serheniuk.currencyconversion:id/amountInput"]', '1500')
  * match driver.text('//android.widget.EditText[@resource-id="com.serheniuk.currencyconversion:id/amountInput"]') == '1500'

  # Submit the conversion
  * driver.click('//android.widget.Button[@resource-id="com.serheniuk.currencyconversion:id/submitButton"]')
  * delay(3000)

  # Verify error message
  * match driver.text('//android.widget.TextView[@resource-id="android:id/message"]') == "You don't have enough money after pay commission 0.00 EUR."
  * driver.click('//android.widget.Button[@resource-id="android:id/button1"]')

  # Verify balance remains unchanged
  * def eurBalance = locate('//android.widget.TextView[@resource-id="com.serheniuk.currencyconversion:id/balance" and @text="1000 EUR"]')
  * match eurBalance.text == '1000 EUR'



Scenario: S5 Verify balance updates after multiple conversions (Blocked by S2A)
  Given driver { webDriverSession: { capabilities: { alwaysMatch: "#(android.desiredConfig.alwaysMatch)", firstMatch: "#(android.desiredConfig.firstMatch)" } } }
  # First conversion: 100 EUR
  * driver.input('//android.widget.EditText[@resource-id="com.serheniuk.currencyconversion:id/amountInput"]', '100')
  * driver.click('//android.widget.Button[@resource-id="com.serheniuk.currencyconversion:id/submitButton"]')
  * delay(3000)
  * driver.click('//android.widget.Button[@resource-id="android:id/button1"]')
  * delay(1000)

  # Verify balance after first conversion
  * def eurBalance = locate('//android.widget.TextView[@resource-id="com.serheniuk.currencyconversion:id/balance" and @text="900 EUR"]')
  * def usdBalance = locate('//android.widget.TextView[@resource-id="com.serheniuk.currencyconversion:id/balance" and @text="112.9 USD"]')
  * match eurBalance.text == '900 EUR'
  * match usdBalance.text == '112.9 USD'

  # Second conversion: 500 EUR
  * driver.input('//android.widget.EditText[@resource-id="com.serheniuk.currencyconversion:id/amountInput"]', '500')
  * driver.click('//android.widget.Button[@resource-id="com.serheniuk.currencyconversion:id/submitButton"]')
  * delay(3000)
  * driver.click('//android.widget.Button[@resource-id="android:id/button1"]')
  * delay(1000)

  # Verify final balance (112.9 + 564.5 = 677.4 USD)
  * def eurBalance = locate('//android.widget.TextView[@resource-id="com.serheniuk.currencyconversion:id/balance" and @text="400 EUR"]')
  * def usdBalance = locate('//android.widget.TextView[@resource-id="com.serheniuk.currencyconversion:id/balance" and @text="677.4 USD"]')
  * match eurBalance.text == '400 EUR'
  * match usdBalance.text == '677.4 USD'