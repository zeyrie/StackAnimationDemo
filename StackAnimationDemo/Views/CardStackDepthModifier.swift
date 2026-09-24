import SwiftUI

/// Keeps deck-depth animation independent of the front card's finger tracking.
struct CardStackDepthModifier: ViewModifier {
    let position: Int
    let swipeState: SwipeInteractionState

    func body(content: Content) -> some View {
        content
            .scaleEffect(1 - depth * 0.045)
            .offset(y: depth * 17)
            .animation(
                CardMotion.overlappingDeckAdvance,
                value: swipeState.isDeckAdvancing
            )
    }

    private var depth: CGFloat {
        guard position > 0 else { return CGFloat(position) }
        // Anticipate the drag, then finish the rise while the front card exits.
        let advance = swipeState.isDeckAdvancing ? 1 : swipeState.interaction.progress * 0.25
        return max(0, CGFloat(position) - advance)
    }

}
