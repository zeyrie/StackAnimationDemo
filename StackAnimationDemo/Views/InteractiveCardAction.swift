import SwiftUI

struct InteractiveCardAction: View {
    let title: LocalizedStringKey
    let systemImage: String
    let tint: Color
    let direction: SwipeDirection
    let swipeState: SwipeInteractionState
    let action: () -> Void

    var body: some View {
        CardActionButton(title: title, systemImage: systemImage, tint: tint, action: action)
            .scaleEffect(scale)
            .opacity(opacity)
            .shadow(color: tint.opacity(Double(selectedProgress) * 0.3), radius: 12 * selectedProgress)
            .animation(
                CardMotion.changeDirection,
                value: swipeState.interaction.direction
            )
            .zIndex(isSelected ? 1 : 0)
            .allowsHitTesting(!hasActiveInteraction)
            .accessibilityHidden(hasActiveInteraction && !isSelected)
    }

    private var hasActiveInteraction: Bool {
        swipeState.interaction.direction != nil
    }

    private var isSelected: Bool {
        swipeState.interaction.direction == direction
    }

    private var selectedProgress: CGFloat {
        isSelected ? swipeState.interaction.progress : 0
    }

    private var scale: CGFloat {
        isSelected ? 1 + selectedProgress * 0.28 : 1
    }

    private var opacity: Double {
        isSelected || !hasActiveInteraction ? 1 : 1 - Double(swipeState.interaction.progress)
    }
}
