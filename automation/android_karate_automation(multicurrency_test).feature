Feature: Multicurrency Tests

Background: App Preset
  * configure driver = { type: 'android', webDriverPath: "/", start: true, httpConfig: { readTimeout: 120000 } }

Scenario Outline: Convert a valid amount from EUR to <ReceiveCurrency> (ISO 4217:2015)
  Given driver { webDriverSession: { capabilities: { alwaysMatch: "#(android.desiredConfig.alwaysMatch)", firstMatch: "#(android.desiredConfig.firstMatch)" } } }
  # Verify initial balance (1000 EUR)
  * match driver.text('//android.widget.TextView[@resource-id="com.serheniuk.currencyconversion:id/balance"]') == '1000 EUR'

  # Set the "Sell" currency to EUR using search
  * driver.click('//android.widget.TextView[@resource-id="com.serheniuk.currencyconversion:id/fromCurrency"]')
  * delay(500)
  * driver.click('//android.widget.Button[@content-desc="Search"]')
  * delay(500)
  * driver.input('//android.widget.AutoCompleteTextView[@resource-id="com.serheniuk.currencyconversion:id/search_src_text"]', 'EUR')
  * delay(500)
  * driver.click('//android.widget.TextView[@resource-id="com.serheniuk.currencyconversion:id/currency"]')
  * delay(500)
  * match driver.text('//android.widget.TextView[@resource-id="com.serheniuk.currencyconversion:id/fromCurrency"]') == 'EUR'

  # Set the "Receive" currency to <ReceiveCurrency> using search
  * driver.click('//android.widget.TextView[@resource-id="com.serheniuk.currencyconversion:id/toCurrency"]')
  * delay(500)
  * driver.click('//android.widget.Button[@content-desc="Search"]')
  * delay(500)
  * driver.input('//android.widget.AutoCompleteTextView[@resource-id="com.serheniuk.currencyconversion:id/search_src_text"]', '<ReceiveCurrency>')
  * delay(500)
  * driver.click('//android.widget.TextView[@resource-id="com.serheniuk.currencyconversion:id/currency"]')
  * delay(500)
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



  # Discontinued currency, or Non-circulating (commodity) rate set to 99999999 on purpose, these are bugs - described in the M1A - discontinued currencies.csv bug report. 
  Examples:
    | ReceiveCurrency | ExpectedReceiveAmount   |
    | AED             | 1997.02                 |
    | AFN             | 38250.75                |
    | ALL             | 49850.00                |
    | AMD             | 211250.00               |
    | ANG             | 975.00                  |
    | AOA             | 451250.00               |
    | ARS             | 521250.00               |
    | AUD             | 732.41                  |
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
    | BRL             | 2974.31                 |
    | BSD             | 543.75                  |
    | BTN             | 45500.00                |
    | BWP             | 7250.00                 |
    | BYN             | 1750.00                 |
    | BYR             | 99999999                |
    | BZD             | 1100.00                 |
    | CAD             | 735.00                  |
    | CDF             | 1500000.00              |
    | CHF             | 465.00                  |
    | CLP             | 500000.00               |
    | CNY             | 3950.00                 |
    | CRC             | 275000.00               |
    | CUC             | 543.75                  |
    | CUP             | 13000.00                |
    | CVE             | 55000.00                |
    | CZK             | 12250.00                |
    | DJF             | 95000.00                |
    | DKK             | 3730.00                 |
    | DOP             | 32500.00                |
    | DZD             | 72500.00                |
    | EGP             | 25000.00                |
    | ERN             | 8000.00                 |
    | ETB             | 60000.00                |
    | FJD             | 1200.00                 |
    | FKP             | 415.00                  |
    | GBP             | 415.00                  |
    | GEL             | 1450.00                 |
    | GGP             | 415.00                  |
    | GHS             | 7000.00                 |
    | GIP             | 415.00                  |
    | GMD             | 37500.00                |
    | GNF             | 4750000.00              |
    | GTQ             | 4200.00                 |
    | GYD             | 112500.00               |
    | HKD             | 4200.00                 |
    | HNL             | 13500.00                |
    | HRK             | 99999999                |
    | HTG             | 70000.00                |
    | HUF             | 197500.00               |
    | IDR             | 8250000.00              |
    | ILS             | 2050.00                 |
    | IMP             | 415.00                  |
    | INR             | 46000.00                |
    | IQD             | 700000.00               |
    | IRR             | 22500000.00             |
    | ISK             | 72500.00                |
    | JEP             | 415.00                  |
    | JMD             | 85000.00                |
    | JOD             | 385.00                  |
    | KES             | 70000.00                |
    | KGS             | 45000.00                |
    | KHR             | 2200000.00              |
    | KMF             | 245000.00               |
    | KPW             | 490000.00               |
    | KRW             | 735000.00               |
    | KWD             | 165.00                  |
    | KYD             | 450.00                  |
    | KZT             | 260000.00               |
    | LAK             | 11500000.00             |
    | LBP             | 47500000.00             |
    | LKR             | 160000.00               |
    | LRD             | 105000.00               |
    | LSL             | 10000.00                |
    | MGA             | 2400000.00              |
    | MKD             | 30000.00                |
    | MMK             | 1150000.00              |
    | MNT             | 1850000.00              |
    | MOP             | 4350.00                 |
    | MRO             | 99999999                |
    | MUR             | 25000.00                |
    | MVR             | 8250.00                 |
    | MWK             | 925000.00               |
    | MXN             | 10500.00                |
    | MYR             | 2450.00                 |
    | MZN             | 35000.00                |
    | NAD             | 10000.00                |
    | NGN             | 850000.00               |
    | OMR             | 210.00                  |
    | PAB             | 543.75                  |
    | PEN             | 2050.00                 |
    | PGK             | 2100.00                 |
    | PHP             | 31000.00                |
    | PLN             | 2125.00                 |
    | PYG             | 4100000.00              |
    | QAR             | 1975.00                 |
    | RON             | 2475.00                 |
    | RSD             | 58500.00                |
    | RUB             | 52500.00                |
    | RWF             | 700000.00               |
    | SAR             | 2040.00                 |
    | SOS             | 310000.00               |
    | SRD             | 17500.00                |
    | STD             | 99999999                |
    | SVC             | 4750.00                 |
    | SYP             | 6750000.00              |
    | SZL             | 10000.00                |
    | THB             | 18500.00                |
    | TJS             | 5750.00                 |
    | TMT             | 1900.00                 |
    | TND             | 1650.00                 |
    | TOP             | 1250.00                 |
    | TRY             | 19000.00                |
    | TTD             | 3700.00                 |
    | TZS             | 1450000.00              |
    | UAH             | 22500.00                |
    | UGX             | 2000000.00              |
    | USD             | 543.75                  |
    | UYU             | 21500.00                |
    | UZS             | 6750000.00              |
    | VEF             | 99999999                |
    | VND             | 13500000.00             |
    | VUV             | 65000.00                |
    | WST             | 1500.00                 |
    | XAF             | 327500.00               |
    | XAG             | 99999999                |
    | XAU             | 99999999                |
    | XCD             | 1475.00                 |
    | XDR             | 99999999                |
    | XOF             | 327500.00               |
    | XPF             | 59500.00                |
    | YER             | 135000.00               |
    | ZAR             | 10000.00                |
    | ZMK             | 99999999                |
    | ZMW             | 13500.00                |
    | ZWL             | 175000.00               |