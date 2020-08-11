//
//  AppState.swift
//  Landmarks
//
//  Created by Ingun Jon on 2020/08/11.
//  Copyright © 2020 Apple. All rights reserved.
//

import Foundation
import Combine
import ReSwift

// First, you create the middleware, which needs to know the type of your `State`.

fileprivate func reducer(action: Action, state: AppState?) -> AppState {
    var state = state ?? AppState()
    if let innerAct = action as? InnerActions {
        switch innerAct {
        case let .UpdateLandmarks(newLandmarks): state.landmarks = newLandmarks
        }
    } else if let act = action as? PublicAction {
        switch act {
        case let .ToggleFavorite(id):
            if state.favorites.contains(id) {
                state.favorites.removeAll { $0 == id }
            } else {
                state.favorites.append(id)
            }
        case .FetchLandmarks:
            MockServer.fetchLandmarks().sink { (landmarks) in
                store.dispatch(InnerActions.UpdateLandmarks(landmarks))
            }.store(in: &cancelBag)
        }
    }
    return state
}
// Note that it can perfectly live with other middleware in the chain.
fileprivate let store = Store<AppState>(reducer: reducer, state: nil, middleware: [])

public struct AppState: StateType {
    var landmarks = [Landmark]()
    var favorites = [Int]()
}

private var cancelBag = Set<AnyCancellable>()

public class AppStateManager {
    public static func dispatchAction(action:PublicAction) {
        store.dispatch(action)
    }
    public static func selectListener<T>(initialValue:T, transform:@escaping (AppState)->T)->SelectionPublisher<T> {
        return SelectionPublisher(store: store, transform: transform, initialValue: initialValue)
    }
}

fileprivate enum InnerActions:Action {
    case UpdateLandmarks([Landmark])
}
public enum PublicAction:Action {
    case FetchLandmarks
    case ToggleFavorite(Int)
}

public class SelectionPublisher<T>:StoreSubscriber, ObservableObject {
    @Published public var state:T
    init(store:Store<AppState>, transform:@escaping (AppState)->T, initialValue:T) {
        state = initialValue
        store.subscribe(self) { $0.select(transform) }
    }
    public func newState(state: T) {
        self.state = state
    }
}
