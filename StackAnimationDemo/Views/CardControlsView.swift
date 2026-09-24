import SwiftUI

struct CardControlsView: View {
    let isDisabled: Bool
    let swipeState: SwipeInteractionState
    let onPass: () -> Void
    let onSave: () -> Void
    let onLike: () -> Void

    private let buttonWidth: CGFloat = 54
    private let buttonSpacing: CGFloat = 24

    var body: some View {
        VStack(spacing: 16) {
            HStack(spacing: buttonSpacing) {
                InteractiveCardAction(
                    title: "Pass",
                    systemImage: "xmark",
                    tint: .pink,
                    direction: .left,
                    swipeState: swipeState,
                    action: onPass
                )
                .frame(width: buttonWidth)
                InteractiveCardAction(
                    title: "Save",
                    systemImage: "arrow.up",
                    tint: .cyan,
                    direction: .up,
                    swipeState: swipeState,
                    action: onSave
                )
                .frame(width: buttonWidth)
                InteractiveCardAction(
                    title: "Like",
                    systemImage: "heart.fill",
                    tint: .green,
                    direction: .right,
                    swipeState: swipeState,
                    action: onLike
                )
                .frame(width: buttonWidth)
            }
            .disabled(isDisabled)
        }
    }
}
