import SwiftUI

struct DiscoverBackgroundView: View {
    var body: some View {
        LinearGradient(
            colors: [
                Color(red: 0.04, green: 0.05, blue: 0.10),
                Color(red: 0.11, green: 0.08, blue: 0.18)
            ],
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
}
