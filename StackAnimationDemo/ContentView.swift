import SwiftUI

struct ContentView: View {
    @State private var cards = DemoCard.samples
    @State private var dismissRequest: DismissRequest?
    @State private var swipeState = SwipeInteractionState()

    var body: some View {
        ZStack {
            DiscoverBackgroundView()

            VStack(spacing: 20) {
                DiscoverHeaderView(cardCount: cards.count)

                CardStackView(
                    cards: cards,
                    dismissRequest: dismissRequest,
                    swipeState: swipeState,
                    onDismiss: cardDismissed,
                    onReset: resetButtonTapped
                )

                CardControlsView(
                    isDisabled: cards.isEmpty || dismissRequest != nil,
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

    private func cardDismissed(_ direction: SwipeDirection) {
        guard !cards.isEmpty else { return }
        dismissRequest = nil

        withAnimation(CardMotion.deckAdvance) {
            swipeState.interaction = .inactive
            swipeState.isDeckAdvancing = false
            _ = cards.removeFirst()
        }
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
