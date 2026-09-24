import SwiftUI

struct DemoCard: Identifiable {
    let id: Int
    let title: String
    let subtitle: String
    let category: String
    let symbol: String
    let colors: [Color]
}

extension DemoCard {
    static let samples = [
        DemoCard(id: 1, title: "Santorini", subtitle: "Whitewashed villages above the deep blue Aegean.", category: "Greece", symbol: "sun.horizon.fill", colors: [.indigo, .cyan]),
        DemoCard(id: 2, title: "Kyoto", subtitle: "Quiet temples, lantern-lit lanes, and autumn color.", category: "Japan", symbol: "leaf.fill", colors: [.orange, .pink]),
        DemoCard(id: 3, title: "Reykjavík", subtitle: "Northern lights and wild landscapes at the edge of the world.", category: "Iceland", symbol: "mountain.2.fill", colors: [.teal, .blue]),
        DemoCard(id: 4, title: "Marrakesh", subtitle: "Vivid markets, hidden gardens, and warm desert nights.", category: "Morocco", symbol: "sparkles", colors: [.red, .orange]),
        DemoCard(id: 5, title: "Banff", subtitle: "Turquoise lakes framed by the Canadian Rockies.", category: "Canada", symbol: "tree.fill", colors: [.green, .mint])
    ]
}
