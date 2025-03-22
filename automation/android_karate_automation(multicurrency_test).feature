Feature: Multicurrency Tests

Background: App Preset
  * configure driver = { type: 'android', webDriverPath: "/", start: true, httpConfig: { readTimeout: 120000 } }

Scenario Outline: Convert a valid amount from EUR to <ReceiveCurrency> (ISO 4217:2015)
  Given driver { webDriverSession: { capabilities: { alwaysMatch: "#(android.desiredConfig.alwaysMatch)", firstMatch: "#(android.desiredConfig.firstMatch)" } } }
  # Verify initial balance (1000 EUR)
  * match driver.text('//android.widget.TextView[@resource-id="com.serheniuk.currencyconversion:id/balance"]') == '1000 EUR'

  # Set the "Sell" currency to EUR using search
  * driver.click('//android.widget.TextView[@resource-id="com.serheniuk.currencyconversion:id/fromCurrency"]')
  * delay(1000)
  * driver.click('//android.widget.Button[@content-desc="Search"]')
  * delay(1000)
  * driver.input('//android.widget.AutoCompleteTextView[@resource-id="com.serheniuk.currencyconversion:id/search_src_text"]', 'EUR')
  * delay(1000)
  * driver.click('//android.widget.TextView[@resource-id="com.serheniuk.currencyconversion:id/currency"]')
  * delay(1000)
  * match driver.text('//android.widget.TextView[@resource-id="com.serheniuk.currencyconversion:id/fromCurrency"]') == 'EUR'

  # Set the "Receive" currency to <ReceiveCurrency> using search
  * driver.click('//android.widget.TextView[@resource-id="com.serheniuk.currencyconversion:id/toCurrency"]')
  * delay(1000)
  * driver.click('//android.widget.Button[@content-desc="Search"]')
  * delay(1000)
  * driver.input('//android.widget.AutoCompleteTextView[@resource-id="com.serheniuk.currencyconversion:id/search_src_text"]', '<ReceiveCurrency>')
  * delay(1000)
  * driver.click('//android.widget.TextView[@resource-id="com.serheniuk.currencyconversion:id/currency"]')
  * delay(1000)
  * match driver.text('//android.widget.TextView[@resource-id="com.serheniuk.currencyconversion:id/toCurrency"]') == '<ReceiveCurrency>'

  # Enter amount to sell (500 EUR)
  * driver.input('//android.widget.EditText[@resource-id="com.serheniuk.currencyconversion:id/amountInput"]', '500')
  * match driver.text('//android.widget.EditText[@resource-id="com.serheniuk.currencyconversion:id/amountInput"]') == '500'

  # Submit the conversion
  * driver.click('//android.widget.Button[@resource-id="com.serheniuk.currencyconversion:id/submitButton"]')
  * delay(3000)

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
    | ALL             | 49850.00                |
    | AMD             | 211250.00               |
    | ANG             | 975.00                  |
    | AOA             | 451250.00               |
    | ARS             | 521250.00               |
    | AUD             | 810.00                  |
    | AWG             | 975.00                  |
    | AZN             | 925.00                  |
    | BAM             | 975.00                  |
    | BBD             | 1087.50                 |
    | BDT             | 65000.00                |
    | BGN             | 975.00                  |
    | BHD             | 205.00                  |
    | BIF             | 1575000.00              |
    | BMD             | 543.75                  |
    | BND             | 725.00                  |
    | BOB             | 3750.00                 |
    | BRL             | 2975.00                 |
    | BSD             | 543.75                  |
    | BTC             | 0.01                    |
    | BTN             | 45500.00                |
    | BWP             | 7250.00                 |
    | BYN             | 1750.00                 |
    | BYR             | 10650000.00             |
    | BZD             | 1100.00                 |