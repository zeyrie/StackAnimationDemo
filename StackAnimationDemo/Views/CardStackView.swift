import SwiftUI

struct CardStackView: View {
    let cards: [DemoCard]
    let dismissRequest: DismissRequest?
    let onDismiss: (SwipeDirection) -> Void
    let onReset: () -> Void

    var body: some View {
        GeometryReader { proxy in
            ZStack {
                if cards.isEmpty {
                    EmptyDeckView(onReset: onReset)
                        .transition(.scale.combined(with: .opacity))
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
                            onDismiss: onDismiss
                        )
                        .zIndex(Double(cards.count - index))
                    }
                }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
        }
        .frame(maxHeight: 560)
    }
}
