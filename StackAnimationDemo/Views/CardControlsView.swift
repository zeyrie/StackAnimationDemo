import SwiftUI

struct CardControlsView: View {
    let isDisabled: Bool
    let swipeState: SwipeInteractionState
    let onPass: () -> Void
    let onSave: () -> Void
    let onLike: () -> Void

    var body: some View {
        VStack(spacing: 16) {
            HStack(spacing: 24) {
                InteractiveCardAction(
                    title: "Pass",
                    systemImage: "xmark",
                    tint: .pink,
                    direction: .left,
                    swipeState: swipeState,
                    action: onPass
                )
                InteractiveCardAction(
                    title: "Save",
                    systemImage: "arrow.up",
                    tint: .cyan,
                    direction: .up,
                    swipeState: swipeState,
                    action: onSave
                )
                InteractiveCardAction(
                    title: "Like",
                    systemImage: "heart.fill",
                    tint: .green,
                    direction: .right,
                    swipeState: swipeState,
                    action: onLike
                )
            }
            .disabled(isDisabled)

            Text("Swipe left, right, or up")
                .font(.footnote.weight(.medium))
                .foregroundStyle(.white.opacity(0.5))
        }
    }
}

private struct InteractiveCardAction: View {
    let title: LocalizedStringKey
    let systemImage: String
    let tint: Color
    let direction: SwipeDirection
    let swipeState: SwipeInteractionState
    let action: () -> Void

    private let distanceToCenter: CGFloat = 78

    var body: some View {
        CardActionButton(
            title: title,
            systemImage: systemImage,
            tint: tint,
            action: action
        )
        .frame(width: 54)
        .scaleEffect(scale)
        .offset(x: horizontalOffset, y: verticalOffset)
        .opacity(opacity)
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

    private var progress: CGFloat {
        isSelected ? swipeState.interaction.progress : 0
    }

    private var scale: CGFloat {
        if isSelected {
            return 1 + progress * 0.28
        }
        return 1 - swipeState.interaction.progress * 0.12
    }

    private var horizontalOffset: CGFloat {
        guard isSelected else { return 0 }

        switch direction {
        case .left:
            return distanceToCenter * progress
        case .right:
            return -distanceToCenter * progress
        case .up:
            return 0
        }
    }

    private var verticalOffset: CGFloat {
        isSelected ? -10 * progress : 0
    }

    private var opacity: Double {
        isSelected || !hasActiveInteraction
            ? 1
            : 1 - Double(swipeState.interaction.progress)
    }
}
