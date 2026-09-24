import SwiftUI

struct DismissRequest: Equatable {
    let id = UUID()
    let direction: SwipeDirection
}

struct SwipeInteraction: Equatable {
    let direction: SwipeDirection?
    let progress: CGFloat

    static let inactive = SwipeInteraction(direction: nil, progress: 0)
}

enum SwipeDirection {
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
