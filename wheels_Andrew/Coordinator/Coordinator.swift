//
//  Coordinator.swift
//  wheels_Andrew
//
//  Created by Andrew on 20.07.21.
//

protocol Coordinator {
    func start()
    func coordinate(to coordinator: Coordinator)
}

extension Coordinator {
    func coordinate(to coordinator: Coordinator) {
        coordinator.start()
    }
}
