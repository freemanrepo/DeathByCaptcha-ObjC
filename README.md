# DeathByCaptcha-ObjC

[![CI Status](http://img.shields.io/travis/Majd Alfhaily/DeathByCaptcha-ObjC.svg?style=flat)](https://travis-ci.org/Majd Alfhaily/DeathByCaptcha-ObjC)
[![Version](https://img.shields.io/cocoapods/v/DeathByCaptcha-ObjC.svg?style=flat)](http://cocoapods.org/pods/DeathByCaptcha-ObjC)
[![License](https://img.shields.io/cocoapods/l/DeathByCaptcha-ObjC.svg?style=flat)](http://cocoapods.org/pods/DeathByCaptcha-ObjC)
[![Platform](https://img.shields.io/cocoapods/p/DeathByCaptcha-ObjC.svg?style=flat)](http://cocoapods.org/pods/DeathByCaptcha-ObjC)

## Installation

DeathByCaptcha-ObjC is available through [CocoaPods](http://cocoapods.org). To install
it, simply add the following line to your Podfile:

```ruby
pod "DeathByCaptcha-ObjC"
```

## Usage

```objective-c
DeathByCaptcha *sharedInstance = [DeathByCaptcha sharedInstance];
sharedInstance.username = @"dbc_username";
sharedInstance.password = @"dbc_password";

NSDictionary *solvedCaptcha = [DeathByCaptcha solveCaptchaFromFileAtPath@"/path/to/captcha_image" checkInterval:5];
NSLog(@"%@", solvedCaptcha[@"text"]);
```



## Author

Majd Alfhaily, majd@alfhaily.me, [@freemanrepo](https://twitter.com/freemanrepo) on Twitter.

## License

DeathByCaptcha-ObjC is available under the MIT license. See the LICENSE file for more info.
