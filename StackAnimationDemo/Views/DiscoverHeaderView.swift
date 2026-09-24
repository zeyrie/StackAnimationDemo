import SwiftUI

struct DiscoverHeaderView: View {
    let cardCount: Int

    var body: some View {
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

            Text("\(cardCount) left")
                .font(.subheadline.weight(.semibold))
                .foregroundStyle(.white.opacity(0.65))
        }
    }
}
