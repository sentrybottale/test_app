Feature: Multicurrency Tests

Background: App Preset
  * configure driver = { type: 'android', webDriverPath: "/", start: true, httpConfig: { readTimeout: 120000 } }

Scenario Outline: Convert a valid amount from EUR to <ReceiveCurrency>
  Given driver { webDriverSession: { capabilities: { alwaysMatch: "#(android.desiredConfig.alwaysMatch)", firstMatch: "#(android.desiredConfig.firstMatch)" } } }
  # Verify initial balance (1000 EUR)
  * match driver.text('//android.widget.TextView[@resource-id="com.serheniuk.currencyconversion:id/balance"]') == '1000 EUR'

  # Set the "Sell" currency to EUR
  * driver.click('//android.widget.TextView[@resource-id="com.serheniuk.currencyconversion:id/fromCurrency"]')
  * delay(1000)
  * driver.click('//android.widget.TextView[@text="EUR"]')
  * delay(1000)
  * match driver.text('//android.widget.TextView[@resource-id="com.serheniuk.currencyconversion:id/fromCurrency"]') == 'EUR'

  # Set the "Receive" currency to <ReceiveCurrency>
  * driver.click('//android.widget.TextView[@resource-id="com.serheniuk.currencyconversion:id/toCurrency"]')
  * delay(1000)
  * driver.click('//android.widget.TextView[@text="<ReceiveCurrency>"]')
  * delay(1000)
  * match driver.text('//android.widget.TextView[@resource-id="com.serheniuk.currencyconversion:id/toCurrency"]') == '<ReceiveCurrency>'

  # Enter amount to sell (500 EUR)
  * driver.input('//android.widget.EditText[@resource-id="com.serheniuk.currencyconversion:id/amountInput"]', '500')
  * match driver.text('//android.widget.EditText[@resource-id="com.serheniuk.currencyconversion:id/amountInput"]') == '500'

  # Submit the conversion
  * driver.click('//android.widget.Button[@resource-id="com.serheniuk.currencyconversion:id/submitButton"]')
  * delay(30000000)

  # Verify confirmation message
  * match driver.text('//android.widget.TextView[@resource-id="android:id/message"]') == 'You have converted 500.00 EUR to <ExpectedReceiveAmount> <ReceiveCurrency>. Commission Fee - 0.00 EUR.'
  * driver.click('//android.widget.Button[@resource-id="android:id/button1"]')
  * delay(1000)

  # Verify updated balance
  * def eurBalance = locate('//android.widget.TextView[@resource-id="com.serheniuk.currencyconversion:id/balance" and @text="500 EUR"]')
  * def receiveBalance = locate('//android.widget.TextView[@resource-id="com.serheniuk.currencyconversion:id/balance" and @text="<ExpectedReceiveAmount> <ReceiveCurrency>"]')
  * match eurBalance.text == '500 EUR'
  * match receiveBalance.text == '<ExpectedReceiveAmount> <ReceiveCurrency>'

  Examples:
    | ReceiveCurrency | ExpectedReceiveAmount   |
    | AED             | 1997.02                 |
    | AFN             | 38250.75                |