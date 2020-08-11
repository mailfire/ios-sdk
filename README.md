# Mailfire SDK for iOS apps
Email Marketing and Push platform for your key product metrics https://mailfire.io

- [Using Mailfire](#using-mailfire)
- [Introduction](#introduction)
- [Installation](#installation)
- [Adding Credentials](#adding-credentials)
- [Push Notifications](#push-notifications)
  - [Analytics features](##analytics-features)
  - [iOS Push Prompting](##ios-push-prompting)
  - [Firebase Platform](##firebase-platform)
  - [APNS Platform](##apns-platform)
  - [Notification Service Extension](##notification-service-extension)
  - [Push tracking](##push-tracking)
  - [Unseen push tracking](##unseen-push-tracking)
  - [Log user(optional)](##log-user)
  - [Subscription](##subscription)

# Introduction
Use the Mailfire SDK to design and send push notifications, track and report events occurred in your application.
Developers using the Mailfire SDK with their app are required to register for a credential, and to specify the credential (apiKey) in their application. Failure to do so results in blocked access to certain features and degradation in the quality of other services.
To obtain these credentials, visit the developer portal at https://mailfire.io and register for a license.
Credentials are unique to your application's bundle identifier. Do not reuse credentials across multiple applications.

# Installation

## Requirements
- iOS 10.0+
- Xcode 10.2+
- Swift 5+

## CocoaPods

[CocoaPods](https://cocoapods.org) is a dependency manager for Cocoa projects. For usage and installation instructions, visit their website. To integrate Mailfire into your Xcode project using CocoaPods, specify it in your `Podfile`:

```ruby
pod 'Mailfire'
```

## Embedded Framework

If you prefer not to use any of the aforementioned dependency managers, you can integrate Mailfire into your project manually.

- Download SDK for iOS package from this repo: Mailfire.framework folder.
- Add the Mailfire dynamic framework to your Xcode project. Click on your app target and choose the "General" tab. Find the section called "Embedded Binaries", click the plus (+) sign, and then click the "Add Other" button. From the file dialog box select "Mailfire.framework" folder. Ensure that "Copy items if needed" and "Create folder reference" options are selected, then click Finish.
- Ensure that Mailfire.framework appears in "Embedded Binaries" and the "Linked Frameworks and Libraries" sections.
- Run the application. Ensure that the project runs in iOS without errors.
SDK for iOS is now ready for use in your Xcode project. Now that you have your project configured to work with Mailfire SDK


## Adding Credentials

Ensure that you have provided the apiKey, appId and clientId before using the Mailfire SDK.
For example, set them in your app delegate:

```swift
import Mailfire

func application(_ application: UIApplication,
didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
   Mailfire.initializeWithLaunchOptions(launchOptions, appId: 'YOUR_APP_ID', clientId: 'YOUR_CLIENT_ID',  appCode: 'YOUR_APP_CODE')
}
```
# Push Notifications

## iOS Push Prompting
iOS Apps have a native prompt that users click "Allow" to subscribe to push. You can use the below methods to trigger that prompt in your app.

```
Warning: Use that method if no other third party or native lib do not invoke method to prompt for push permissions
If Firebase is used for instance, just skip that section and move to [Firebase platform](https://github.com/mailfire/ios-sdk/blob/master/Documentation/Usage.md#firebase-platform)
```

```swift
import Mailfire

func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
  ...
  Mailfire.promptForPushNotifications { granted in
    if granted {
      ...
    } else {
      ...
    }
  }
  ...
}

// Within native UIApplicationDelegate callback pass apns token to Mailfire server
func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
  let tokenParts = deviceToken.map { data in String(format: "%02.2hhx", data) }
  let token = tokenParts.joined()
  Mailfire.shared.pushToken(.apns(token))
}

```

## Analytics features

Mailfire's analytics features require [Notification Service Extension](https://github.com/mailfire/ios-sdk/blob/master/Documentation/Usage.md#notification-service-extension), [Push tracking]("https://github.com/mailfire/ios-sdk/blob/master/Documentation/Usage.md#push-tracking"), [Unseen push tracking]("https://github.com/mailfire/ios-sdk/blob/master/Documentation/Usage.md#unseen-push-tracking"), [Log user(optional)](#"https://github.com/mailfire/ios-sdk/blob/master/Documentation/Usage.md#log-user")


## Firebase Platform

Pass a Firebase registration token to Mailfire beckend by using
```swift
Mailfire.shared.pushToken(.firebase(token))
```
Note: Make sure that you have passed Firebase server key to Mailfire team, otherwise no pushes are going to be delivered.


## APNS Platform

Pass an APSN registration token to Mailfire beckend by using

```swift
Mailfire.shared.pushToken(.apns(token))
```

## Notification Service Extension

The Mailfire allows your iOS application to receive rich notifications with images, and badges. It's also required for Mailfire's analytics features.

All that have to be done is introduce Notification Service Extension and invoke corresponding Mailfire methods.

```swift
import UserNotifications
import Mailfire

class NotificationService: UNNotificationServiceExtension {

    var contentHandler: ((UNNotificationContent) -> Void)?
    var bestAttemptContent: UNMutableNotificationContent?

    var receivedRequest: UNNotificationRequest!

    override func didReceive(_ request: UNNotificationRequest, withContentHandler contentHandler: @escaping (UNNotificationContent) -> Void) {
        self.receivedRequest = request
        self.contentHandler = contentHandler
        bestAttemptContent = (request.content.mutableCopy() as? UNMutableNotificationContent)

        if let bestAttemptContent = bestAttemptContent {
            // Modify the notification content here...
            bestAttemptContent.title = "\(bestAttemptContent.title) [modified]"
            Mailfire.didReceiveNotificationExtensionRequest(self.receivedRequest, with: bestAttemptContent)

            contentHandler(bestAttemptContent)
        }
    }

    override func serviceExtensionTimeWillExpire() {
        // Called just before the extension will be terminated by the system.
        // Use this as an opportunity to deliver your "best attempt" at modified content, otherwise the original push payload will be used.
        if let contentHandler = contentHandler, let bestAttemptContent =  bestAttemptContent {
            Mailfire.serviceExtensionTimeWillExpire(self.receivedRequest, with: bestAttemptContent)
            contentHandler(bestAttemptContent)
        }
    }
}

```

## Push tracking

It's required for Mailfire's analytics features.
Log a push info of recieved payload.

```swift
extension PushNotificationHelper : UNUserNotificationCenterDelegate {

    func userNotificationCenter(_ center: UNUserNotificationCenter,
                                didReceive response: UNNotificationResponse,
                                withCompletionHandler completionHandler: @escaping () -> Void) {
        let userInfo = response.notification.request.content.userInfo
        Mailfire.logPush(pushPayload: userInfo)

        completionHandler()
    }
}

```


## Unseen push tracking

It's required for Mailfire's analytics features.
If there is any impl of UNUserNotificationCenterDelegate.userNotificationCenter(\_:willPresent:withCompletionHandler:) and a push notification won't be shown as an app in foreground then use the method inside the callback to notify about the push notification being recieved but unseen.

```swift
extension PushNotificationService : UNUserNotificationCenterDelegate {

    // foreground
    func userNotificationCenter(_ center: UNUserNotificationCenter,
                                willPresent notification: UNNotification,
                                withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        ....
        // log push info code if push won't be shown
        ApproverEngine.shared.logUnseenPush(pushPayload: notification.request.content.userInfo)

        completionHandler([])
    }

```

## Log user

Log a user's email and unique id if any.
The data is requred to help to optimize an app experience
by making it easy to analyze and scale product and marketing experiments

```swift
Mailfire.logUser(email: "some@gmail.com", id: customID)
```

## Subscription

The user must first subscribe through the native prompt or app settings. It does not officially subscribe or unsubscribe them from the app settings, it unsubscribes them from receiving push from Mailfire.
You can only call this method with false to opt out users from receiving notifications through Mailfire. You can pass true later to opt users back into notifications.

```swift
Mailfire.subscription = true
```
