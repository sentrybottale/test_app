# Currency Converter Test Automation

This repository contains the test automation setup for the **Currency Converter** Android app, including both manual and automated tests. The project uses the Karate framework for automated testing and includes manual test plans and bug reports to ensure comprehensive testing of the app's functionality. Grok 3 is used as an AI tool to help generate tests, writeup bugs and debug of the automation suite. It is used also for data generation (current exchange rates and currency validator)

## Project Structure

### Testplan
The `testplan/` directory contains all manual test plans and reports for the Currency Converter app. This includes:

- **Manual Test Plans**: Detailed test cases for manual testing of the app's features, such as currency conversion, balance updates, and error handling.
- **Bugreports**: Reports generated from manual test executions, documenting pass/fail results, observations, and any issues found during testing.

This directory serves as the primary location for manual testing documentation, which complements the automated tests - tests are written for ease in Gherkin, so they can be later adapted into automation tests.

### Automation
The `automation/` directory contains automated test scripts written using the **Karate** framework, a powerful tool for API and UI test automation. Karate scripts are written in Gherkin syntax, making them readable and maintainable. The automation suite is divided into subfolders based on test types:

#### Automation Subfolders
  
- **`android_karate_automation(smoketest_regression).feature`**: This script covers smoke and regression tests for the app’s core functionality. Key scenarios include:
  - **S0**: Verifying the initial balance (1000 EUR).
  - **S1-S2**: Converting valid amounts (100 EUR and 500 EUR) from EUR to USD, checking confirmation messages and balance updates.
  - **S3**: Attempting to convert 0 EUR, ensuring no confirmation dialog appears.
  - **S4**: Attempting to convert more EUR than available, verifying the error message.
  - **S5**: Verifying balance updates after multiple conversions.
  - **S6**: Verifying dropdown selection for currencies.
- The execution karate report can be found in test_execution_report

  - **`android_karate_automation(multicurrency_test).feature`**: This script showcases how AI tools can be used to supercharge(with automation) the conversion functionality of the app. It includes:
  - Tests for converting a fixed amount (500 EUR) to a wide range of currencies (123 active currencies as of the latest update).
  - Verification of conversion confirmation messages and balance updates.
  - Handling of discontinued currencies (e.g., BYR, HRK) by marking them for removal (see bug reports in `bugreports/`).
  - The execution karate report can be found in test_execution_report, all tests are FAILED since our app is not having CURRENT correct exchange rates functionality - which is a complete showstopper

#### Karate Setup
- **Karate Version**: The project uses Karate 1.5.0 (see `karate-1.5.0.jar`). The chosen setup is standalone, that is why the .jar file is in the project directory. Make sure to go to https://github.com/karatelabs/karate - to get to know more about the awesome and versatile Karate Framework
- **Configuration**: The `karate-config.js` file contains global configurations for the Karate tests, such as desired capabilities for the Android emulator.
- **Requirement**: Karate is the most versalite automation framework, which can drive even Android apps like our apps of testing. However, you need to fulfill certain steps, to be able to run this suite locally:
        - Java 11 installed, Appium Server, Android Studio with properly setup Emulator, for our automation test setup. 
- **Execution**: Tests are executed using the Karate JAR file. To run the tests, use a command like the below. Again, you will not be able to just run the command, without properly setting up emulator(android studio), apium and java
  java -jar karate-1.5.0.jar automation/android_karate_automation(multicurrency_test).feature