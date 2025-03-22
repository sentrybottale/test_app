function fn() {
  var env = karate.env;  //  <set this only when set for CI execution - karate parameter e=locale
  karate.log('karate.env system property was:', env);
  
  if (!env) {
    env = 'dev'; // a custom 'intelligent' default
  }
    //Default defaults (dev environment + bg market)
    var config = {baseURL: 'https://google.com'}; 
    function getResourcePath(resource) {
      var File = Java.type('java.io.File');
      var Paths = Java.type('java.nio.file.Paths');
      var path = Paths.get('util', resource).toAbsolutePath().toString();
      return path;
    }
    var extensionPath = getResourcePath('chrome-extension');
  
  
    //Website
    if (env == 'dev') {
      config.baseURL = 'https://google.com'
      
     }
     
    // don't waste time waiting for a connection or if servers don't respond within 15 seconds
    karate.configure('retry', { count: 6, interval: 3000 });
    karate.configure('connectTimeout', 25000);
    karate.configure('readTimeout', 20000);

    //Locally Chrome:
    karate.configure('driver', { type: 'chrome', addOptions: ["--remote-allow-origins=*", '--disable-search-engine-choice-screen', '--disable-infobars','--no-first-run','--disable-notifications', '--disable-features=PasswordLeakDetection'], showDriverLog: false });

 


  // Resolve the classpath:app-release.apk to an absolute path
  var ClassLoader = Java.type('java.lang.ClassLoader');
  var classLoader = ClassLoader.getSystemClassLoader();
  var apkResource = classLoader.getResource('app-release.apk');
  if (!apkResource) {
    throw new Error('app-release.apk not found in classpath! Ensure it is in src/test/resources.');
  }
  var apkPath = apkResource.getPath();
  // On Windows, the path might start with "file:/", which needs to be cleaned up
  if (apkPath.startsWith('file:')) {
    apkPath = apkPath.substring(5); // Remove "file:" prefix
  }
  karate.log('Resolved APK path:', apkPath);

  var android = {};
  android["desiredConfig"] = {
    alwaysMatch: {
      "appium:app": apkPath, // Use the resolved absolute path
        "appium:newCommandTimeout": 300,
        "appium:platformVersion": "14.0",
        "appium:platformName": "Android",
        "appium:connectHardwareKeyboard": true,
        "appium:deviceName": "emulator-5554",
        "appium:avd": "Pixel_6a_API_34",
        "appium:automationName": "UiAutomator2"
      },
      firstMatch: [{}]
    };
    config["android"] = android;
    return config;
  }    
