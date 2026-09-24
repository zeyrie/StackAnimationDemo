import SwiftUI

/// A committed swipe that can finish animating after the next card becomes active.
struct DepartingCard: Identifiable {
    let id = UUID()
    let card: DemoCard
    let direction: SwipeDirection
    let initialTranslation: CGSize
}

struct DepartingCardView: View {
    let departure: DepartingCard
    let containerSize: CGSize
    let onFinished: (DepartingCard.ID) -> Void

    @State private var translation: CGSize

    init(
        departure: DepartingCard,
        containerSize: CGSize,
        onFinished: @escaping (DepartingCard.ID) -> Void
    ) {
        self.departure = departure
        self.containerSize = containerSize
        self.onFinished = onFinished
        _translation = State(initialValue: departure.initialTranslation)
    }

    var body: some View {
        DemoCardView(card: departure.card)
            .rotationEffect(.degrees(Double(min(18, max(-18, translation.width / 22)))))
            .offset(translation)
            .allowsHitTesting(false)
            .accessibilityHidden(true)
            .onAppear { flightAppeared() }
    }

    private func flightAppeared() {
        withAnimation(CardMotion.dismiss, completionCriteria: .removed) {
            translation = destination
        } completion: {
            onFinished(departure.id)
        }
    }

    private var destination: CGSize {
        switch departure.direction {
        case .left:
            CGSize(
                width: -max(containerSize.width * 1.45, abs(translation.width) + containerSize.width),
                height: 80
            )
        case .right:
            CGSize(
                width: max(containerSize.width * 1.45, abs(translation.width) + containerSize.width),
                height: 80
            )
        case .up:
            CGSize(
                width: translation.width,
                height: -max(containerSize.height * 1.35, abs(translation.height) + containerSize.height)
            )
        }
    }
}
