import SwiftUI

/// Keeps deck-depth animation independent of the front card's finger tracking.
struct CardStackDepthModifier: ViewModifier {
    let position: Int
    let swipeState: SwipeInteractionState

    @Environment(\.accessibilityReduceMotion) private var reduceMotion

    func body(content: Content) -> some View {
        content
            .scaleEffect(1 - depth * 0.045)
            .offset(y: depth * 17)
            .opacity(max(0.55, 1 - Double(depth) * 0.12))
            .animation(
                CardMotion.overlappingDeckAdvance(reduceMotion: reduceMotion),
                value: swipeState.isDeckAdvancing
            )
    }

    private var depth: CGFloat {
        guard position > 0, !reduceMotion else { return CGFloat(position) }
        // Anticipate the drag, then finish the rise while the front card exits.
        let advance = swipeState.isDeckAdvancing ? 1 : swipeState.interaction.progress * 0.25
        return max(0, CGFloat(position) - advance)
    }

}
