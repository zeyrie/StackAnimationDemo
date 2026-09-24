import SwiftUI

struct DemoCardView: View {
    let card: DemoCard
    let activeDirection: SwipeDirection?
    let indicatorOpacity: Double

    var body: some View {
        ZStack(alignment: .bottomLeading) {
            LinearGradient(
                colors: card.colors,
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )

            Image(systemName: card.symbol)
                .font(.system(size: 170, weight: .ultraLight))
                .foregroundStyle(.white.opacity(0.2))
                .rotationEffect(.degrees(-10))
                .offset(x: 110, y: -90)

            LinearGradient(
                colors: [.clear, .black.opacity(0.78)],
                startPoint: .center,
                endPoint: .bottom
            )

            DemoCardDetailsView(
                title: card.title,
                subtitle: card.subtitle,
                category: card.category
            )

            SwipeDirectionIndicatorView(
                direction: activeDirection,
                opacity: indicatorOpacity
            )
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
}

private struct DemoCardDetailsView: View {
    let title: String
    let subtitle: String
    let category: String

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            Label(category.uppercased(), systemImage: "location.fill")
                .font(.caption.bold())
                .tracking(1.5)
                .foregroundStyle(.white.opacity(0.8))

            Text(title)
                .font(.system(size: 40, weight: .bold, design: .rounded))

            Text(subtitle)
                .font(.body)
                .foregroundStyle(.white.opacity(0.78))
                .lineLimit(2)
        }
        .padding(28)
    }
}

private struct SwipeDirectionIndicatorView: View {
    let direction: SwipeDirection?
    let opacity: Double

    var body: some View {
        ZStack {
            if let direction {
                VStack {
                    if direction != .up {
                        Spacer()
                    }

                    HStack {
                        if direction == .right {
                            Spacer()
                        }

                        Label(direction.label, systemImage: direction.symbol)
                            .font(.title3.bold())
                            .padding(.horizontal, 16)
                            .padding(.vertical, 10)
                            .foregroundStyle(direction.color)
                            .background(.black.opacity(0.35), in: Capsule())
                            .overlay {
                                Capsule()
                                    .stroke(direction.color, lineWidth: 2)
                            }

                        if direction == .left {
                            Spacer()
                        }
                    }

                    if direction == .up {
                        Spacer()
                    }
                }
                .padding(24)
                .opacity(opacity)
            }
        }
    }
}
