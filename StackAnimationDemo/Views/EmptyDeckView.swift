import SwiftUI

struct EmptyDeckView: View {
    let onReset: () -> Void

    var body: some View {
        VStack(spacing: 18) {
            Image(systemName: "checkmark.circle.fill")
                .font(.system(size: 58))
                .foregroundStyle(.mint)
            Text("You saw them all")
                .font(.title2.bold())
            Text("Reset the deck to explore again.")
                .foregroundStyle(.secondary)
            Button("Reset cards", systemImage: "arrow.counterclockwise", action: onReset)
                .buttonStyle(.borderedProminent)
                .tint(.white)
                .foregroundStyle(.black)
        }
        .multilineTextAlignment(.center)
    }
}
