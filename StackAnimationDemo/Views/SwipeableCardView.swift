import SwiftUI

struct SwipeableCardView: View {
    let card: DemoCard
    let isTopCard: Bool
    let stackPosition: Int
    let dismissRequest: DismissRequest?
    let swipeState: SwipeInteractionState
    let onCommit: (SwipeDirection, CGSize) -> Void

    @GestureState private var isDragging = false
    @State private var translation: CGSize = .zero
    @State private var isDismissing = false

    private let dismissalThreshold: CGFloat = 105
    private let feedbackThreshold: CGFloat = 18

    var body: some View {
        DemoCardView(card: card)
            .modifier(CardStackDepthModifier(position: stackPosition, swipeState: swipeState))
            .rotationEffect(.degrees(rotation))
            .offset(translation)
            .allowsHitTesting(isTopCard && !isDismissing)
            .accessibilityHidden(!isTopCard || isDismissing)
            .gesture(isTopCard ? dragGesture : nil)
            .onChange(of: dismissRequest) { _, request in
                dismissRequestChanged(request)
            }
            .onChange(of: isDragging) { _, dragging in
                dragActivityChanged(dragging)
            }
            .accessibilityAction(named: "Pass") { dismiss(.left) }
            .accessibilityAction(named: "Save") { dismiss(.up) }
            .accessibilityAction(named: "Like") { dismiss(.right) }
    }

    private var dragGesture: some Gesture {
        DragGesture(minimumDistance: 8)
            .updating($isDragging) { _, dragging, _ in dragging = true }
            .onChanged { value in dragChanged(value) }
            .onEnded { value in dragEnded(value) }
    }

    private var rotation: Double {
        Double(min(18, max(-18, translation.width / 22)))
    }

    private func dragChanged(_ value: DragGesture.Value) {
        guard !isDismissing else { return }
        // Tracking stays directly attached to the finger, even when a return spring is interrupted.
        var transaction = Transaction()
        transaction.disablesAnimations = true
        withTransaction(transaction) {
            translation = value.translation
        }
        swipeState.interaction = interaction(for: value.translation)
    }

    private func dragEnded(_ value: DragGesture.Value) {
        guard !isDismissing else { return }
        if let direction = direction(for: value.predictedEndTranslation, threshold: dismissalThreshold) {
            dismiss(direction)
        } else {
            returnToRest()
        }
    }

    private func dragActivityChanged(_ dragging: Bool) {
        // GestureState also resets on system cancellation, when onEnded may not run.
        guard !dragging, !isDismissing, translation != .zero else { return }
        returnToRest()
    }

    private func dismissRequestChanged(_ request: DismissRequest?) {
        guard let request, !isDismissing else { return }
        dismiss(request.direction)
    }

    private func returnToRest() {
        withAnimation(CardMotion.cardReturn) {
            translation = .zero
            swipeState.interaction = .inactive
        }
    }

    private func interaction(for translation: CGSize) -> SwipeInteraction {
        guard let direction = direction(for: translation, threshold: feedbackThreshold) else {
            return .inactive
        }

        let distance = max(abs(translation.width), -translation.height)
        let fraction = min(1, max(0, (distance - feedbackThreshold) / (dismissalThreshold - feedbackThreshold)))
        // Smoothstep begins at zero and settles gently at full emphasis.
        let progress = fraction * fraction * (3 - 2 * fraction)
        return SwipeInteraction(direction: direction, progress: progress)
    }

    private func direction(for translation: CGSize, threshold: CGFloat) -> SwipeDirection? {
        let horizontal = translation.width
        let vertical = translation.height

        if vertical < -threshold, abs(vertical) > abs(horizontal) {
            return .up
        }
        if abs(horizontal) > threshold, abs(horizontal) >= abs(vertical) {
            return horizontal < 0 ? .left : .right
        }
        return nil
    }

    private func dismiss(_ direction: SwipeDirection) {
        guard isTopCard, !isDismissing else { return }
        isDismissing = true
        onCommit(direction, translation)
    }
}
