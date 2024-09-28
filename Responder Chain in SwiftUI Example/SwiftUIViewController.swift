// This source code is licensed under the MIT license. See LICENSE.md for details.

import UIKit

class SwiftUIViewController: UIViewController {

    override func viewDidLoad() {
        // This is very basic code that adds a UIHostingController containing our SwiftUI view to this view controller.
        // This "correct" view controller child relationship is required for the responder chain to function correctly.
        let hostingController = ResponderChainInteropHostingController(content: SwiftUIView())
        hostingController.willMove(toParent: self)
        hostingController.view.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(hostingController.view)
        NSLayoutConstraint.activate([
            hostingController.view.topAnchor.constraint(equalTo: view.topAnchor),
            hostingController.view.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            hostingController.view.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            hostingController.view.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
        addChild(hostingController)
        super.viewDidLoad()
    }
}
