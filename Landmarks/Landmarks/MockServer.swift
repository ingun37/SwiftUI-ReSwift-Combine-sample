//
//  MockServer.swift
//  Landmarks
//
//  Created by Ingun Jon on 2020/08/11.
//  Copyright © 2020 Apple. All rights reserved.
//

import Foundation
import Combine

class MockServer {
    static func fetchLandmarks()-> AnyPublisher<[Landmark], Never> {
        return Timer.publish(every: 1, on: RunLoop.main, in: RunLoop.Mode.default).autoconnect().first().map { (_) in
            landmarkData
        }.eraseToAnyPublisher()
    }
}
