import SwiftUI

/// Timing for the distinct phases of card and control motion.
enum CardMotion {
    static func dismiss(reduceMotion: Bool) -> Animation {
        reduceMotion ? .easeOut(duration: 0.18) : .timingCurve(0.28, 0.1, 0.58, 1, duration: 0.46)
    }

    static func cardReturn(reduceMotion: Bool) -> Animation {
        reduceMotion ? .easeOut(duration: 0.18) : .spring(duration: 0.5, bounce: 0.2)
    }

    static func overlappingDeckAdvance(reduceMotion: Bool) -> Animation {
        reduceMotion ? .easeOut(duration: 0.18) : .spring(duration: 0.36, bounce: 0.15).delay(0.08)
    }

    static func deckAdvance(reduceMotion: Bool) -> Animation {
        reduceMotion ? .easeOut(duration: 0.18) : .spring(duration: 0.5, bounce: 0.2)
    }

    static func changeDirection(reduceMotion: Bool) -> Animation {
        reduceMotion ? .easeOut(duration: 0.12) : .spring(duration: 0.24, bounce: 0.08)
    }

    static func reset(reduceMotion: Bool) -> Animation {
        reduceMotion ? .easeOut(duration: 0.18) : .spring(duration: 0.5, bounce: 0.18)
    }
}
