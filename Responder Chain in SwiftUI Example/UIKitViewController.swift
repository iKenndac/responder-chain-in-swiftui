// This source code is licensed under the MIT license. See LICENSE.md for details.

import UIKit

class UIKitViewController: UIViewController {

    @IBOutlet var ratingLabel: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()
        updateLabel()
    }

    var imageRating: Int = 0 {
        didSet { updateLabel() }
    }

    func updateLabel() {
        if imageRating == 0 {
            ratingLabel.text = "Rating: None"
        } else {
            let stars = String(repeating: "★", count: imageRating)
            ratingLabel.text = "Rating: \(stars)"
        }
    }

    // MARK: - Menu Item Validation

    override func validate(_ command: UICommand) {
        // This will be called every time a menu is displayed. We can modify the items on-the-fly to update the title,
        // or, as in this case, put a checkmark next to the item that matches the current rating.
        let menuItemMatchesCurrentRating: Bool = {
            switch command.action {
            case #selector(RatingMenuActions.removeRating(_:)): return (imageRating == 0)
            case #selector(RatingMenuActions.rateOneStar(_:)): return (imageRating == 1)
            case #selector(RatingMenuActions.rateTwoStars(_:)): return (imageRating == 2)
            case #selector(RatingMenuActions.rateThreeStars(_:)): return (imageRating == 3)
            case #selector(RatingMenuActions.rateFourStars(_:)): return (imageRating == 4)
            case #selector(RatingMenuActions.rateFiveStars(_:)): return (imageRating == 5)
            default: return false
            }
        }()

        if menuItemMatchesCurrentRating {
            command.state = .on
        } else {
            command.state = .off
        }
    }

    // MARK: - Menu Handlers

    // Note: Since the responder chain uses Objective-C runtime features, action methods need to be marked `@objc`.
    @objc func removeRating(_ sender: UICommand) { imageRating = 0 }
    @objc func rateOneStar(_ sender: UICommand) { imageRating = 1 }
    @objc func rateTwoStars(_ sender: UICommand) { imageRating = 2 }
    @objc func rateThreeStars(_ sender: UICommand) { imageRating = 3 }
    @objc func rateFourStars(_ sender: UICommand) { imageRating = 4 }
    @objc func rateFiveStars(_ sender: UICommand) { imageRating = 5 }
}

