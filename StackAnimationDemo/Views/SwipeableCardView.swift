import SwiftUI

struct SwipeableCardView: View {
    let card: DemoCard
    let isTopCard: Bool
    let stackPosition: Int
    let containerSize: CGSize
    let dismissRequest: DismissRequest?
    let swipeState: SwipeInteractionState
    let onDismiss: (SwipeDirection) -> Void

    @State private var translation: CGSize = .zero
    @State private var isDismissing = false

    private let dismissalThreshold: CGFloat = 105

    var body: some View {
        DemoCardView(card: card)
            .scaleEffect(stackScale)
            .offset(x: translation.width, y: stackOffset + translation.height)
            .rotationEffect(.degrees(Double(translation.width / 22)))
            .opacity(stackOpacity)
            .allowsHitTesting(isTopCard && !isDismissing)
            .gesture(isTopCard ? dragGesture : nil)
            .onChange(of: dismissRequest) { _, request in
                guard let request, !isDismissing else { return }
                dismiss(request.direction)
            }
            .accessibilityAction(named: "Pass") { dismiss(.left) }
            .accessibilityAction(named: "Save") { dismiss(.up) }
            .accessibilityAction(named: "Like") { dismiss(.right) }
    }

    private var dragGesture: some Gesture {
        DragGesture(minimumDistance: 8)
            .onChanged { value in
                guard !isDismissing else { return }
                translation = value.translation
                swipeState.interaction = interaction(for: value.translation)
            }
            .onEnded { value in
                let projectedTranslation = value.predictedEndTranslation

                if let direction = dismissalDirection(for: projectedTranslation) {
                    dismiss(direction)
                } else {
                    withAnimation(.spring(duration: 0.42, bounce: 0.28)) {
                        translation = .zero
                        swipeState.interaction = .inactive
                    }
                }
            }
    }

    private var stackScale: CGFloat {
        1 - CGFloat(stackPosition) * 0.045
    }

    private var stackOffset: CGFloat {
        CGFloat(stackPosition) * 17
    }

    private var stackOpacity: Double {
        max(0.55, 1 - Double(stackPosition) * 0.12)
    }

    private func interaction(for translation: CGSize) -> SwipeInteraction {
        guard let direction = activeDirection(for: translation) else {
            return .inactive
        }

        let distance = max(abs(translation.width), -translation.height)
        let progress = min(1, distance / dismissalThreshold)
        return SwipeInteraction(direction: direction, progress: progress)
    }

    private func activeDirection(for translation: CGSize) -> SwipeDirection? {
        guard abs(translation.width) > 18 || translation.height < -18 else {
            return nil
        }

        if translation.height < -abs(translation.width) {
            return .up
        }

        if abs(translation.width) >= abs(translation.height) {
            return translation.width < 0 ? .left : .right
        }

        return nil
    }

    private func dismissalDirection(for projectedTranslation: CGSize) -> SwipeDirection? {
        let horizontal = projectedTranslation.width
        let vertical = projectedTranslation.height

        if vertical < -dismissalThreshold, abs(vertical) > abs(horizontal) {
            return .up
        }

        if abs(horizontal) > dismissalThreshold, abs(horizontal) >= abs(vertical) {
            return horizontal < 0 ? .left : .right
        }

        return nil
    }

    private func dismiss(_ direction: SwipeDirection) {
        guard isTopCard, !isDismissing else { return }
        isDismissing = true

        withAnimation(.easeIn(duration: 0.28)) {
            swipeState.interaction = SwipeInteraction(direction: direction, progress: 1)

            switch direction {
            case .left:
                translation = CGSize(width: -containerSize.width * 1.45, height: 80)
            case .right:
                translation = CGSize(width: containerSize.width * 1.45, height: 80)
            case .up:
                translation = CGSize(width: 0, height: -containerSize.height * 1.35)
            }
        } completion: {
            onDismiss(direction)
        }
    }
}
