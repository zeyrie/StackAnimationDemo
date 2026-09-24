import SwiftUI

struct CardStackView: View {
    let cards: [DemoCard]
    let dismissRequest: DismissRequest?
    let swipeState: SwipeInteractionState
    let onDismiss: (SwipeDirection) -> Void
    let onReset: () -> Void

    @Environment(\.accessibilityReduceMotion) private var reduceMotion

    var body: some View {
        GeometryReader { proxy in
            ZStack {
                if cards.isEmpty {
                    EmptyDeckView(onReset: onReset)
                        .transition(reduceMotion ? .opacity : .scale(scale: 0.96).combined(with: .opacity))
                } else {
                    ForEach(
                        Array(cards.prefix(4).enumerated()).reversed(),
                        id: \.element.id
                    ) { index, card in
                        SwipeableCardView(
                            card: card,
                            isTopCard: index == 0,
                            stackPosition: index,
                            containerSize: proxy.size,
                            dismissRequest: index == 0 ? dismissRequest : nil,
                            swipeState: swipeState,
                            onDismiss: onDismiss
                        )
                        .transition(.asymmetric(insertion: .opacity, removal: .identity))
                        .zIndex(Double(cards.count - index))
                    }
                }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
        }
        .frame(maxHeight: 560)
    }
}
