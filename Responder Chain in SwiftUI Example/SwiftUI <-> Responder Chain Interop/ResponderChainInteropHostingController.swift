// This source code is licensed under the MIT license. See LICENSE.md for details.

import SwiftUI
import ObjectiveC

class ResponderChainInteropHostingController<Content: View>: UIHostingController<ResponderChainInteropHostingController.ContentInteropWrapper> {

    // This coordinator stores the action handlers registered by the SwiftUI view, and is queried by our
    // action forwarding mechanics from UIKit.
    let menuItemCoordinator = MenuItemCoordinator()

    init(content: Content) {
        super.init(rootView: ContentInteropWrapper(content: content, menuItemCoordinator: menuItemCoordinator))
    }

    @objc required dynamic init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // This wrapper is here so we can pass the MenuItemCoordinator object to SwiftUI via the environment and still
    // keep a nicely-typed generic on the view controller (i.e., we can avoid AnyView).
    struct ContentInteropWrapper: View {
        let content: Content
        let menuItemCoordinator: MenuItemCoordinator

        var body: some View {
            content
                .environmentObject(menuItemCoordinator)
        }
    }

    // So we don't have to explicitly implement every possible menu item selector here as a method, we take
    // advantage of Objective-C's message forwarding functionality. If our SwiftUI content registered a hander for
    // a particular action's selector, we forward that invocation along for dynamic handling at runtime.
    override func target(forAction action: Selector, withSender sender: Any?) -> Any? {
        if menuItemCoordinator.hasHandler(for: action) {
            return menuItemCoordinator.actionHandler
        } else {
            return super.target(forAction: action, withSender: sender)
        }
    }
}
