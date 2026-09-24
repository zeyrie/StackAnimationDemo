import SwiftUI

/// Keeps deck-depth animation independent of the front card's finger tracking.
struct CardStackDepthModifier: ViewModifier {
    let position: Int
    let swipeState: SwipeInteractionState

    func body(content: Content) -> some View {
        content
            .scaleEffect(1 - depth * 0.045)
            .offset(y: depth * 17)
    }

    private var depth: CGFloat {
        guard position > 0 else { return CGFloat(position) }
        // The next card anticipates the drag; the deck spring completes its rise on commit.
        return max(0, CGFloat(position) - swipeState.interaction.progress * 0.25)
    }

}
