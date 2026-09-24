import SwiftUI

struct ContentView: View {
    @State private var cards = DemoCard.samples
    @State private var departingCards: [DepartingCard] = []
    @State private var dismissRequest: DismissRequest?
    @State private var swipeState = SwipeInteractionState()

    var body: some View {
        ZStack {
            DiscoverBackgroundView()

            VStack(spacing: 20) {
                DiscoverHeaderView(cardCount: cards.count)

                CardStackView(
                    cards: cards,
                    departingCards: departingCards,
                    dismissRequest: dismissRequest,
                    swipeState: swipeState,
                    onCommit: cardCommitted,
                    onFlightFinished: cardFlightFinished,
                    onReset: resetButtonTapped
                )

                CardControlsView(
                    isDisabled: cards.isEmpty,
                    swipeState: swipeState,
                    onPass: { requestDismissal(.left) },
                    onSave: { requestDismissal(.up) },
                    onLike: { requestDismissal(.right) }
                )
                .padding(.top, 24)
            }
            .padding(.horizontal, 24)
            .padding(.vertical, 20)
        }
        .preferredColorScheme(.dark)
    }

    private func requestDismissal(_ direction: SwipeDirection) {
        guard !cards.isEmpty, dismissRequest == nil else { return }
        dismissRequest = DismissRequest(direction: direction)
    }

    private func cardCommitted(
        id: DemoCard.ID,
        direction: SwipeDirection,
        translation: CGSize
    ) {
        guard let card = cards.first, card.id == id else { return }
        let departure = DepartingCard(
            card: card,
            direction: direction,
            initialTranslation: translation
        )

        withAnimation(CardMotion.deckAdvance) {
            dismissRequest = nil
            swipeState.interaction = .inactive
            departingCards.append(departure)
            _ = cards.removeFirst()
        }
    }

    private func cardFlightFinished(_ id: DepartingCard.ID) {
        departingCards.removeAll { $0.id == id }
    }

    private func resetButtonTapped() {
        withAnimation(CardMotion.reset) {
            cards = DemoCard.samples
        }
    }
}

#Preview {
    ContentView()
}
