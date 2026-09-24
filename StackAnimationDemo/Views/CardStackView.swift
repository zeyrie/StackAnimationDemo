import SwiftUI

struct CardStackView: View {
    let cards: [DemoCard]
    let departingCards: [DepartingCard]
    let dismissRequest: DismissRequest?
    let swipeState: SwipeInteractionState
    let onCommit: (DemoCard.ID, SwipeDirection, CGSize) -> Void
    let onFlightFinished: (DepartingCard.ID) -> Void
    let onReset: () -> Void

    var body: some View {
        GeometryReader { proxy in
            ZStack {
                if cards.isEmpty {
                    EmptyDeckView(onReset: onReset)
                        .transition(.scale(scale: 0.96).combined(with: .opacity))
                } else {
                    ForEach(
                        Array(cards.prefix(4).enumerated()).reversed(),
                        id: \.element.id
                    ) { index, card in
                        SwipeableCardView(
                            card: card,
                            isTopCard: index == 0,
                            stackPosition: index,
                            dismissRequest: index == 0 ? dismissRequest : nil,
                            swipeState: swipeState,
                            onCommit: { direction, translation in
                                onCommit(card.id, direction, translation)
                            }
                        )
                        .transition(.asymmetric(insertion: .opacity, removal: .identity))
                        .zIndex(Double(cards.count - index))
                    }
                }

                ForEach(Array(departingCards.enumerated()), id: \.element.id) { index, departure in
                    DepartingCardView(
                        departure: departure,
                        containerSize: proxy.size,
                        onFinished: onFlightFinished
                    )
                    .transition(.identity)
                    .zIndex(Double(100 + index))
                }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
        }
        .frame(maxHeight: 560)
    }
}
