import SwiftUI

struct ContentView: View {
    @State private var cards = DemoCard.samples
    @State private var dismissRequest: DismissRequest?

    var body: some View {
        ZStack {
            background

            VStack(spacing: 20) {
                header
                cardStack
                controls
            }
            .padding(.horizontal, 24)
            .padding(.vertical, 20)
        }
        .preferredColorScheme(.dark)
    }

    private var background: some View {
        LinearGradient(
            colors: [Color(red: 0.04, green: 0.05, blue: 0.10), Color(red: 0.11, green: 0.08, blue: 0.18)],
            startPoint: .topLeading,
            endPoint: .bottomTrailing
        )
        .ignoresSafeArea()
        .overlay {
            Circle()
                .fill(.purple.opacity(0.16))
                .frame(width: 320)
                .blur(radius: 60)
                .offset(x: 150, y: -280)
        }
    }

    private var header: some View {
        HStack(alignment: .firstTextBaseline) {
            VStack(alignment: .leading, spacing: 4) {
                Text("DISCOVER")
                    .font(.caption.weight(.bold))
                    .tracking(2.4)
                    .foregroundStyle(.white.opacity(0.55))
                Text("Find your next escape")
                    .font(.title2.bold())
            }

            Spacer()

            Text("\(cards.count) left")
                .font(.subheadline.weight(.semibold))
                .foregroundStyle(.white.opacity(0.65))
        }
    }

    private var cardStack: some View {
        GeometryReader { proxy in
            ZStack {
                if cards.isEmpty {
                    emptyState
                        .transition(.scale.combined(with: .opacity))
                } else {
                    ForEach(Array(cards.prefix(4).enumerated()).reversed(), id: \.element.id) { index, card in
                        SwipeableCard(
                            card: card,
                            isTopCard: index == 0,
                            stackPosition: index,
                            containerSize: proxy.size,
                            dismissRequest: index == 0 ? dismissRequest : nil,
                            onDismiss: cardDismissed
                        )
                        .zIndex(Double(cards.count - index))
                    }
                }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
        }
        .frame(maxHeight: 560)
    }

    private var emptyState: some View {
        VStack(spacing: 18) {
            Image(systemName: "checkmark.circle.fill")
                .font(.system(size: 58))
                .foregroundStyle(.mint)
            Text("You saw them all")
                .font(.title2.bold())
            Text("Reset the deck to explore again.")
                .foregroundStyle(.secondary)
            Button("Reset cards", systemImage: "arrow.counterclockwise") {
                resetButtonTapped()
            }
            .buttonStyle(.borderedProminent)
            .tint(.white)
            .foregroundStyle(.black)
        }
        .multilineTextAlignment(.center)
    }

    private var controls: some View {
        VStack(spacing: 16) {
            HStack(spacing: 24) {
                ActionButton(title: "Pass", systemImage: "xmark", tint: .pink) {
                    requestDismissal(.left)
                }
                ActionButton(title: "Save", systemImage: "arrow.up", tint: .cyan) {
                    requestDismissal(.up)
                }
                ActionButton(title: "Like", systemImage: "heart.fill", tint: .green) {
                    requestDismissal(.right)
                }
            }
            .disabled(cards.isEmpty || dismissRequest != nil)

            Text("Swipe left, right, or up")
                .font(.footnote.weight(.medium))
                .foregroundStyle(.white.opacity(0.5))
        }
    }

    private func requestDismissal(_ direction: SwipeDirection) {
        guard !cards.isEmpty, dismissRequest == nil else { return }
        dismissRequest = DismissRequest(direction: direction)
    }

    private func cardDismissed(_ direction: SwipeDirection) {
        guard !cards.isEmpty else { return }
        dismissRequest = nil
        withAnimation(.spring(duration: 0.5, bounce: 0.2)) {
            _ = cards.removeFirst()
        }
    }

    private func resetButtonTapped() {
        withAnimation(.spring(duration: 0.55, bounce: 0.22)) {
            cards = DemoCard.samples
        }
    }
}

private struct SwipeableCard: View {
    let card: DemoCard
    let isTopCard: Bool
    let stackPosition: Int
    let containerSize: CGSize
    let dismissRequest: DismissRequest?
    let onDismiss: (SwipeDirection) -> Void

    @State private var translation: CGSize = .zero
    @State private var isDismissing = false

    private let dismissalThreshold: CGFloat = 105

    var body: some View {
        cardContent
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

    private var cardContent: some View {
        ZStack(alignment: .bottomLeading) {
            LinearGradient(colors: card.colors, startPoint: .topLeading, endPoint: .bottomTrailing)

            Image(systemName: card.symbol)
                .font(.system(size: 170, weight: .ultraLight))
                .foregroundStyle(.white.opacity(0.2))
                .rotationEffect(.degrees(-10))
                .offset(x: 110, y: -90)

            LinearGradient(colors: [.clear, .black.opacity(0.78)], startPoint: .center, endPoint: .bottom)

            VStack(alignment: .leading, spacing: 10) {
                Label(card.category.uppercased(), systemImage: "location.fill")
                    .font(.caption.bold())
                    .tracking(1.5)
                    .foregroundStyle(.white.opacity(0.8))

                Text(card.title)
                    .font(.system(size: 40, weight: .bold, design: .rounded))

                Text(card.subtitle)
                    .font(.body)
                    .foregroundStyle(.white.opacity(0.78))
                    .lineLimit(2)
            }
            .padding(28)

            directionIndicator
        }
        .clipShape(.rect(cornerRadius: 32))
        .overlay {
            RoundedRectangle(cornerRadius: 32)
                .stroke(.white.opacity(0.18), lineWidth: 1)
        }
        .shadow(color: .black.opacity(0.35), radius: 24, y: 16)
        .accessibilityElement(children: .combine)
        .accessibilityLabel("\(card.title), \(card.subtitle)")
        .accessibilityHint("Swipe left to pass, right to like, or up to save")
    }

    @ViewBuilder
    private var directionIndicator: some View {
        if let direction = activeDirection {
            VStack {
                if direction != .up { Spacer() }
                HStack {
                    if direction == .right { Spacer() }
                    Label(direction.label, systemImage: direction.symbol)
                        .font(.title3.bold())
                        .padding(.horizontal, 16)
                        .padding(.vertical, 10)
                        .foregroundStyle(direction.color)
                        .background(.black.opacity(0.35), in: Capsule())
                        .overlay { Capsule().stroke(direction.color, lineWidth: 2) }
                    if direction == .left { Spacer() }
                }
                if direction == .up { Spacer() }
            }
            .padding(24)
            .opacity(indicatorOpacity)
        }
    }

    private var dragGesture: some Gesture {
        DragGesture(minimumDistance: 8)
            .onChanged { value in
                guard !isDismissing else { return }
                translation = value.translation
            }
            .onEnded { value in
                let projected = value.predictedEndTranslation
                if let direction = dismissalDirection(for: projected) {
                    dismiss(direction)
                } else {
                    withAnimation(.spring(duration: 0.42, bounce: 0.28)) {
                        translation = .zero
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

    private var activeDirection: SwipeDirection? {
        guard abs(translation.width) > 18 || translation.height < -18 else { return nil }
        if translation.height < -abs(translation.width) { return .up }
        return translation.width < 0 ? .left : .right
    }

    private var indicatorOpacity: Double {
        min(1, max(abs(translation.width), -translation.height) / dismissalThreshold)
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

private struct ActionButton: View {
    let title: LocalizedStringKey
    let systemImage: String
    let tint: Color
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            VStack(spacing: 7) {
                Image(systemName: systemImage)
                    .font(.title3.bold())
                    .frame(width: 54, height: 54)
                    .background(tint.opacity(0.16), in: Circle())
                    .overlay { Circle().stroke(tint.opacity(0.45), lineWidth: 1) }
                Text(title)
                    .font(.caption.weight(.semibold))
            }
            .foregroundStyle(tint)
        }
        .buttonStyle(.plain)
    }
}

private struct DemoCard: Identifiable {
    let id: Int
    let title: String
    let subtitle: String
    let category: String
    let symbol: String
    let colors: [Color]

    static let samples = [
        DemoCard(id: 1, title: "Santorini", subtitle: "Whitewashed villages above the deep blue Aegean.", category: "Greece", symbol: "sun.horizon.fill", colors: [.indigo, .cyan]),
        DemoCard(id: 2, title: "Kyoto", subtitle: "Quiet temples, lantern-lit lanes, and autumn color.", category: "Japan", symbol: "leaf.fill", colors: [.orange, .pink]),
        DemoCard(id: 3, title: "Reykjavík", subtitle: "Northern lights and wild landscapes at the edge of the world.", category: "Iceland", symbol: "mountain.2.fill", colors: [.teal, .blue]),
        DemoCard(id: 4, title: "Marrakesh", subtitle: "Vivid markets, hidden gardens, and warm desert nights.", category: "Morocco", symbol: "sparkles", colors: [.red, .orange]),
        DemoCard(id: 5, title: "Banff", subtitle: "Turquoise lakes framed by the Canadian Rockies.", category: "Canada", symbol: "tree.fill", colors: [.green, .mint])
    ]
}

private struct DismissRequest: Equatable {
    let id = UUID()
    let direction: SwipeDirection
}

private enum SwipeDirection {
    case left
    case right
    case up

    var label: LocalizedStringKey {
        switch self {
        case .left: "PASS"
        case .right: "LIKE"
        case .up: "SAVE"
        }
    }

    var symbol: String {
        switch self {
        case .left: "xmark"
        case .right: "heart.fill"
        case .up: "arrow.up"
        }
    }

    var color: Color {
        switch self {
        case .left: .pink
        case .right: .green
        case .up: .cyan
        }
    }
}

#Preview {
    ContentView()
}
