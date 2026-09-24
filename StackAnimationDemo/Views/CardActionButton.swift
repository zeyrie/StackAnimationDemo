import SwiftUI

struct CardActionButton: View {
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
                    .overlay {
                        Circle()
                            .stroke(tint.opacity(0.45), lineWidth: 1)
                    }
                Text(title)
                    .font(.caption.weight(.semibold))
            }
            .foregroundStyle(tint)
        }
        .buttonStyle(.plain)
    }
}
