# Mailfire App Push ios-sdk

Use the Mailfire App Push SDK to  to design and send push notifications, track and report events occurred in your application.

- [Features](#features)
- [Requirements](#Requirements)
- [Installation](#installation)
- [Usage](https://github.com/mailfire/ios-sdk/blob/master/Documentation/Usage.md#using-mailfire)
- [Credits](#credits)
- [License](#license)

## Features

- [x] Track events
- [x] Report events
- [x] Push notifications

## Requirements

- iOS 10.0+
- Xcode 10.2+
- Swift 5+

## Installation

### CocoaPods

[CocoaPods](https://cocoapods.org) is a dependency manager for Cocoa projects. For usage and installation instructions, visit their website. To integrate Mailfire into your Xcode project using CocoaPods, specify it in your `Podfile`:

```ruby
pod 'Mailfire'
```

### Manually

If you prefer not to use any of the aforementioned dependency managers, you can integrate Mailfire into your project manually.

#### Embedded Framework

- Download SDK for iOS package from https://api.mailfire.io/dev and extract it to somewhere in your local file system.

- Add the Mailfire dynamic framework to your Xcode project. Click on your app target and choose the "General" tab. Find the section called "Embedded Binaries", click the plus (+) sign, and then click the "Add Other" button. From the file dialog box select "Mailfire.framework" folder. Ensure that "Copy items if needed" and "Create folder reference" options are selected, then click Finish.

- Ensure that Mailfire.framework appears in "Embedded Binaries" and the "Linked Frameworks and Libraries" sections.

- Run the application. Ensure that the project runs in iOS without errors.
SDK for iOS is now ready for use in your Xcode project. Now that you have your project configured to work with Mailfire SDK

## Credits

Mailfire is owned and maintained by the [Mailfire](http://mailfire.org). You can follow them on Twitter at [@MailfireSF](https://twitter.com/MailfireSF) for project updates and releases.

## License

Mailfire is released under the MIT license. [See LICENSE](https://github.com/mailfire/ios-sdk/blob/master/LICENSE) for details.
