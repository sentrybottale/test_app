Feature: Currency Converter Smoke Test Automation

Background: App Preset
  * configure driver = { type: 'android', webDriverPath: "/", start: true, httpConfig: { readTimeout: 120000 } }

Scenario: S0 Berify initial balance

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
  # Verify initial balance
  * def eurBalance = locate('//android.widget.TextView[@resource-id="com.serheniuk.currencyconversion:id/balance" and @text="1000 EUR"]')
  * def usdBalance = locate('//android.widget.TextView[@resource-id="com.serheniuk.currencyconversion:id/balance" and @text="0 USD"]')
  * match eurBalance.text == '1000 EUR'
  * match usdBalance.text == '0 USD'

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
