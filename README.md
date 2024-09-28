#  Responder Chain in SwiftUI Example

This project is a simple example of handling responder chain actions in SwiftUI views, implemented in the form of handling menu items registered elsewhere in the application. This is particularly useful when introducing SwiftUI into an existing app.

**Note:** This example is designed to work with UIKit and UICommand instances along the responder chain. However, there's no reason it won't work with AppKit with a bit of adaptation. 

For more information on this example, see my blog post: [Handling Responder Chain Actions in SwiftUI (With A 'Lil Help From Objective-C)](https://ikennd.ac/blog/2024/09/handling-responder-chain-actions-in-swiftui/).

For more information on the responder chain, see Apple's documentation here: [Using responders and the responder chain to handle events](https://developer.apple.com/documentation/uikit/touches_presses_and_gestures/using_responders_and_the_responder_chain_to_handle_events).

The sample is a basic app for rating an image. It displays an image to you, and you can apply a star rating to that image via the menu or the keyboard shortcuts ⌘0-5. The structure of the app is put together in a basic storyboard with tabs for a UIKit view controller and a SwiftUI view, each of which handles the menu items.

There are four main areas of interest in the sample code:

1. `AppDelegate.swift` contains UIKit code for building a simple menu. On macOS, it'll be placed up in the menu bar. On iOS/iPadOS, it'll be available in the form of keyboard shortcuts and the menu overlay.

2. `UIKitViewController.swift` contains UIKit code for handling the menu items and updating the image's rating, and `SwiftUIView.swift` contains an equivalent SwiftUI view that also handles the menu items using our new view modifier.

3. `ResponderChainInteropHostingController.swift` is a UIKit `UIHostingController` subclass that hosts our SwiftUI view and provides a bit of glue to get the responder chain into SwiftUI via a UIKit action forwarding method and a SwiftUI environment object.

4. This is where the meat of the example is: `SwiftUIResponderChainInterop.swift` and `CBLMenuActionForwarder.h/.m` contain a "coordinator" object that links responder chain actions registered in SwiftUI to incoming responder chain actions from UIKit, as well as a SwiftUI view modifier for making such registrations. Finally, the Objective-C code allows us to "catch" responder chain actions dynamically at runtime and forward them along to SwiftUI without having to explicitly implement them in Swift. Unfortunately, this forwarding functionality isn't available in Swift, hence the need to dip out to to Objective-C.

This allows us to build a menu in a storyboard or in code like this:

```swift
let fiveStarRatingItem = UIKeyCommand(title: "★★★★★",
                                      action: #selector(applyFiveStarRating(_:)),
                                      input: "5")
```

…then handle it in SwiftUI like this:

```swift
Text("IOU 1x UI")
    .actionHandler(for: #selector(applyFiveStarRating(_:))) { command in
        selectedImage?.rating = 5
    }
```

…without having to write explicit menu item handlers in between. Pretty neat!
