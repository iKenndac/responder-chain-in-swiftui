// This source code is licensed under the MIT license. See LICENSE.md for details.

import SwiftUI

struct SwiftUIView: View {

    @State var imageRating: Int = 0

    var ratingText: String {
        if imageRating == 0 {
            return "Rating: None"
        } else {
            let stars = String(repeating: "★", count: imageRating)
            return "Rating: \(stars)"
        }
    }

    var body: some View {
        VStack(alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/, spacing: 0.0) {
            Spacer(minLength: 0.0)

            Image("Mountain")
                .resizable()
                .aspectRatio(contentMode: .fit)

            Spacer(minLength: 20.0)

            VStack(alignment: .center, spacing: 20.0) {
                Text(ratingText)
                    .font(.headline)
                    .multilineTextAlignment(.center)

                Text("Press ⌘0-5 to rate, or use the Rating menu.")
                    .font(.body)
                    .multilineTextAlignment(.center)
            }
        }
        .padding(20.0)

        // These are the menu item handlers. The validation handlers are optional, but we're using them here
        // to put a checkmark next to the rating menu item that matches our current rating.
        .actionHandler(for: #selector(RatingMenuActions.removeRating(_:)),
                       validationHandler: { $0.state = (imageRating == 0 ? .on : .off) },
                       actionHandler: { _ in imageRating = 0 })
        .actionHandler(for: #selector(RatingMenuActions.rateOneStar(_:)),
                       validationHandler: { $0.state = (imageRating == 1 ? .on : .off) },
                       actionHandler: { _ in imageRating = 1 })
        .actionHandler(for: #selector(RatingMenuActions.rateTwoStars(_:)),
                       validationHandler: { $0.state = (imageRating == 2 ? .on : .off) },
                       actionHandler: { _ in imageRating = 2 })
        .actionHandler(for: #selector(RatingMenuActions.rateThreeStars(_:)),
                       validationHandler: { $0.state = (imageRating == 3 ? .on : .off) },
                       actionHandler: { _ in imageRating = 3 })
        .actionHandler(for: #selector(RatingMenuActions.rateFourStars(_:)),
                       validationHandler: { $0.state = (imageRating == 4 ? .on : .off) },
                       actionHandler: { _ in imageRating = 4 })
        .actionHandler(for: #selector(RatingMenuActions.rateFiveStars(_:)),
                       validationHandler: { $0.state = (imageRating == 5 ? .on : .off) },
                       actionHandler: { _ in imageRating = 5 })
    }
}

#Preview {
    SwiftUIView()
}
