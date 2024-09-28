// This source code is licensed under the MIT license. See LICENSE.md for details.

import Foundation
import Combine
import SwiftUI

/// This class is a coordinator to facilitate handling responder chain-based actions (from menu items etc)
/// in SwiftUI. SwiftUI views can register handlers for action selectors (with optional validation), and this
/// class will connect the responder chain invocations with the registered handlers.
class MenuItemCoordinator: NSObject, ObservableObject, MenuActionForwarderTarget {

    private struct HandlerBox {
        let token: MenuItemHandlerToken
        let validationHandler: MenuItemValidationHandler
        let actionHandler: MenuItemActionHandler
    }

    override init() {
        super.init()
        actionHandler = MenuActionForwarder(fowardingActionsTo: self)
    }

    // Swift doesn't let us at NSInvocation (booooo!) so the actual method redirection is written in Objective-C.
    private(set) var actionHandler: MenuActionForwarder!
    private var handlers: [Selector: HandlerBox] = [:]

    // MARK: - Forwarder Delegates

    @objc(canPerformActionWithSelector:) func canPerformAction(with selector: Selector) -> Bool {
        return hasHandler(for: selector)
    }

    @objc(performActionForCommand:) func performAction(for command: UICommand) {
        guard let box = handlers[command.action] else { return }
        box.actionHandler(command)
    }

    @objc(performValidationForCommand:) func performValidation(for command: UICommand) {
        guard let box = handlers[command.action] else { return }
        box.validationHandler(command)
    }

    // MARK: - API

    typealias MenuItemValidationHandler = (UICommand) -> Void
    typealias MenuItemActionHandler = (UICommand) -> Void
    typealias MenuItemHandlerToken = String

    /// Register the given handlers for the given responder chain action.
    func registerHandlers(for selector: Selector,
                          validationHandler: @escaping MenuItemValidationHandler,
                          actionHandler: @escaping MenuItemActionHandler) -> MenuItemHandlerToken {

        let token = UUID().uuidString
        handlers[selector] = HandlerBox(token: token, validationHandler: validationHandler, actionHandler: actionHandler)
        return token
    }
    
    /// Remove an existing set of handlers.
    func removeHandlers(with token: MenuItemHandlerToken) {
        let keys = handlers.filter({ $0.value.token == token }).keys
        for key in keys { handlers.removeValue(forKey: key) }
    }

    /// Returns `true` if the reciever has a registered handler for the given command.
    func hasHandler(for command: UICommand) -> Bool {
        return hasHandler(for: command.action)
    }

    /// Returns `true` if the reciever has a registered handler for the responder chain action.
    func hasHandler(for selector: Selector) -> Bool {
        return (handlers[selector] != nil)
    }
}

extension View {

    /// Register a handler for the given responder chain action.
    ///
    /// - Parameters:
    ///   - selector: The selector for the action. Must be in the form `action:`, taking a single parameter
    ///               of type `UICommand`.
    ///   - validationHandler: The (optional) handler to validate the action.
    ///   - actionHandler: The handler to be called when the action is taken.
    func actionHandler(for selector: Selector,
                       validationHandler: @escaping MenuItemCoordinator.MenuItemValidationHandler = { _ in },
                       actionHandler: @escaping MenuItemCoordinator.MenuItemActionHandler) -> some View {
        modifier(MenuItemHandlerViewModifier(handling: selector,
                                             with: validationHandler,
                                             actionHandler: actionHandler))
    }
}

struct MenuItemHandlerViewModifier: ViewModifier {

    @EnvironmentObject var menuItemCoordinator: MenuItemCoordinator
    @StateObject private var tokenStorage: TokenStorage = TokenStorage()

    // This is a @StateObject-appropriate storage object for our registered action handlers' token.
    // When it's deallocated, it'll automatically de-register the handlers from the menu item coordinator.
    class TokenStorage: ObservableObject {

        private(set) weak var coordinator: MenuItemCoordinator? = nil
        @Published private(set) var token: MenuItemCoordinator.MenuItemHandlerToken? = nil

        func setToken(_ token: MenuItemCoordinator.MenuItemHandlerToken, registeredWith coordinator: MenuItemCoordinator) {
            if let outgoingToken = self.token { self.coordinator?.removeHandlers(with: outgoingToken) }
            self.coordinator = coordinator
            self.token = token
        }

        deinit {
            if let token { coordinator?.removeHandlers(with: token) }
        }
    }

    let selector: Selector
    let validationHandler: MenuItemCoordinator.MenuItemValidationHandler
    let actionHandler: MenuItemCoordinator.MenuItemActionHandler

    init(handling selector: Selector,
         with validationHandler: @escaping MenuItemCoordinator.MenuItemValidationHandler,
         actionHandler: @escaping MenuItemCoordinator.MenuItemActionHandler) {
        self.selector = selector
        self.validationHandler = validationHandler
        self.actionHandler = actionHandler
    }

    func body(content: Content) -> some View {
        content.task(id: selector, {
            let token = menuItemCoordinator.registerHandlers(for: selector,
                                                             validationHandler: validationHandler,
                                                             actionHandler: actionHandler)
            tokenStorage.setToken(token, registeredWith: menuItemCoordinator)
        })
    }
}
