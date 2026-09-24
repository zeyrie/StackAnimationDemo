import SwiftUI

struct CardControlsView: View {
    let isDisabled: Bool
    let onPass: () -> Void
    let onSave: () -> Void
    let onLike: () -> Void

    var body: some View {
        VStack(spacing: 16) {
            HStack(spacing: 24) {
                CardActionButton(title: "Pass", systemImage: "xmark", tint: .pink, action: onPass)
                CardActionButton(title: "Save", systemImage: "arrow.up", tint: .cyan, action: onSave)
                CardActionButton(title: "Like", systemImage: "heart.fill", tint: .green, action: onLike)
            }
            .disabled(isDisabled)

            Text("Swipe left, right, or up")
                .font(.footnote.weight(.medium))
                .foregroundStyle(.white.opacity(0.5))
        }
    }
}
