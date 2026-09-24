import SwiftUI

/// Timing for the distinct phases of card and control motion.
enum CardMotion {
    static let dismiss: Animation = .timingCurve(0.28, 0.1, 0.58, 1, duration: 0.46)
    static let cardReturn: Animation = .spring(duration: 0.5, bounce: 0.2)
    static let deckAdvance: Animation = .spring(duration: 0.5, bounce: 0.2)
    static let changeDirection: Animation = .spring(duration: 0.24, bounce: 0.08)
    static let reset: Animation = .spring(duration: 0.5, bounce: 0.18)
}
