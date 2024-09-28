// This source code is licensed under the MIT license. See LICENSE.md for details.

import UIKit

// Swift doesn't like creating selectors with #selector that it can't "see" somewhere. This protocol defines our rating
// actions for the menu items. The responder chain works on a per-selector basis, though, and nothing needs to actually
// conform to this protocol to respond to menu items using these selectors.
@objc protocol RatingMenuActions {
    func rateOneStar(_ sender: UICommand)
    func rateTwoStars(_ sender: UICommand)
    func rateThreeStars(_ sender: UICommand)
    func rateFourStars(_ sender: UICommand)
    func rateFiveStars(_ sender: UICommand)
    func removeRating(_ sender: UICommand)
}

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    override func buildMenu(with builder: UIMenuBuilder) {
        guard builder.system == .main else { return }

        // This is a particularly verbose way of making these menu items, but are here to make the point that we
        // can work with a bunch of different selectors. We could have all these items use the same action
        // (like applyRating(_:)) then give a different rating value on each command's propertyList value.
        let fiveStarMenuItem = UIKeyCommand(title: "★★★★★", action: #selector(RatingMenuActions.rateFiveStars(_:)),
                                            input: "5", modifierFlags: .command)

        let fourStarMenuItem = UIKeyCommand(title: "★★★★", action: #selector(RatingMenuActions.rateFourStars(_:)),
                                            input: "4", modifierFlags: .command)

        let threeStarMenuItem = UIKeyCommand(title: "★★★", action: #selector(RatingMenuActions.rateThreeStars(_:)),
                                             input: "3", modifierFlags: .command)

        let twoStarMenuItem = UIKeyCommand(title: "★★", action: #selector(RatingMenuActions.rateTwoStars(_:)),
                                           input: "2", modifierFlags: .command)

        let oneStarMenuItem = UIKeyCommand(title: "★", action: #selector(RatingMenuActions.rateOneStar(_:)),
                                           input: "1", modifierFlags: .command)

        let noStarsMenuItem = UIKeyCommand(title: "No Rating", action: #selector(RatingMenuActions.removeRating(_:)),
                                           input: "0", modifierFlags: .command)

        let ratingMenuItems = [noStarsMenuItem, oneStarMenuItem, twoStarMenuItem, threeStarMenuItem, fourStarMenuItem, fiveStarMenuItem]
        builder.insertSibling(UIMenu(title: "Rating", children: ratingMenuItems), afterMenu: .edit)
    }

    // MARK: App Lifecycle Boilerplate

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        return true
    }

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {}
}

