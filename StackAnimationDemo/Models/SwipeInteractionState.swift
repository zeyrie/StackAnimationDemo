import Observation

@MainActor
@Observable
final class SwipeInteractionState {
    var interaction = SwipeInteraction.inactive
    var isDeckAdvancing = false
}
