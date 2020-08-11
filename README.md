# Mailfire SDK for iOS apps
Email Marketing and Push platform for your key product metrics https://mailfire.io

- [Introduction](#introduction)
- [Installation](#installation)
- [Adding Credentials](#adding-credentials)
- [Init SDK](#init-sdk)
- [Attach User](#attach-user)
- [Push Notifications](#push-notifications)
  - [iOS Push Prompting](#ios-push-prompting)
  - [Push Token](#push-token)
  - [Rich Push for images and delivered](#rich-push)
  - [Click tracking](#click-tracking)
  - [Unseen tracking](#unseen-tracking)
  - [Unsubscribe in app](#unsubscribe)

# Introduction
Use the Mailfire SDK to design and send push notifications, track and report events occurred in your application.
Developers using the Mailfire SDK with their app are required to register for a credential, and to specify the credential (apiKey) in their application. Failure to do so results in blocked access to certain features and degradation in the quality of other services.
To obtain these credentials, visit the developer portal at https://mailfire.io and register for a license.
Credentials are unique to your application's bundle identifier. Do not reuse credentials across multiple applications.

# Installation
Requirements
```
- iOS 10.0+
- Xcode 10.2+
- Swift 5+
```

By dependency manager *CocoaPods* (https://cocoapods.org)
To integrate Mailfire into your Xcode project using CocoaPods, specify it in your `Podfile`:
```ruby
pod 'Mailfire'
```

If you prefer integrate manually:
- Download SDK for iOS package from this repo: Mailfire.framework folder.
- Add the Mailfire dynamic framework to your Xcode project. Click on your app target and choose the "General" tab. Find the section called "Embedded Binaries", click the plus (+) sign, and then click the "Add Other" button. From the file dialog box select "Mailfire.framework" folder. Ensure that "Copy items if needed" and "Create folder reference" options are selected, then click Finish.
- Ensure that Mailfire.framework appears in "Embedded Binaries" and the "Linked Frameworks and Libraries" sections.
- Run the application. Ensure that the project runs in iOS without errors.
SDK for iOS is now ready for use in your Xcode project. Now that you have your project configured to work with Mailfire SDK


# Adding Credentials
For using Mailfire platform you must provide credentials of your account and current app.
You can find them at admin panel or request them from your account manager.
Example:
```
clientId: 7345
clientToken: uawhvnkaeuvyagbwyeuvgbayw
appId: 837465 (aka projectId)
```
Next provide this credentials at library launch:

# Init SDK
Also creates session in analytics

```swift
import Mailfire

func application(_ application: UIApplication,
didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
   Mailfire.initializeWithLaunchOptions(launchOptions, appId: 'YOUR_APP_ID', clientId: 'YOUR_CLIENT_ID',  clientToken: 'YOUR_CLIENT_TOKEN')
}
```

# Attach User
For all methods in SDK we match user by [IDFV](https://developer.apple.com/documentation/uikit/uidevice/1620059-identifierforvendor)<br>
Additional you can provide more product information for analytics and etc.
- you aren't required to provide PushToken before that method

- **email** - better provide after validation https://github.com/mailfire/php-sdk#check-email
- **userId** - id on your product

```swift
Mailfire.logUser(email: "some@gmail.com", userId: userId)
```


# Push Notifications

## iOS Push Prompting
iOS Apps have a native prompt that users click "Allow" to subscribe to push. You can use the below methods to trigger that prompt in your app.

```
Warning: Use that method if no other third party or native lib do not invoke method to prompt for push permissions.
If Firebase is used for instance, just skip that section.
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

## Push Token

Pass a **Firebase** registration token to Mailfire beckend by using
```swift
Mailfire.shared.pushToken(.firebase(token))
```
Note: Make sure that you have passed Firebase server key to Mailfire team, otherwise no pushes are going to be delivered.

Pass an **APNS** registration token to Mailfire beckend by using
```swift
Mailfire.shared.pushToken(.apns(token))
```

## Rich Push
The Mailfire allows your iOS application to receive rich notifications with images, and badges.<br>
It's also sends **delivered** event to analytics by didReceiveNotificationExtensionRequest.<br>

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

## Click tracking

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

## Unseen tracking
If there is any impl of UNUserNotificationCenterDelegate.userNotificationCenter(\_:willPresent:withCompletionHandler:) and a push notification won't be shown as an app in foreground then use the method inside the callback to notify about the push notification being recieved but unseen.

```swift
extension PushNotificationService : UNUserNotificationCenterDelegate {
    // foreground
    func userNotificationCenter(_ center: UNUserNotificationCenter,
                                willPresent notification: UNNotification,
                                withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        ....
        // log push info code if push won't be shown
        Mailfire.logUnseenPush(pushPayload: notification.request.content.userInfo)
        completionHandler([])
    }
```

## Unsubscribe

The user must first subscribe through the native prompt or app settings. It does not officially subscribe or unsubscribe them from the app settings, it unsubscribes them from receiving push from Mailfire.
You can only call this method with false to opt out users from receiving notifications through Mailfire. You can pass true later to opt users back into notifications.

```swift
Mailfire.subscription = false
```
