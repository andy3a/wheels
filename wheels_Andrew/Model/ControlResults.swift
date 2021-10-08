//
//  ControlResults.swift
//  wheels_Andrew
//
//  Created by Andrew on 9.08.21.
//

import Foundation

struct ControlResults: Encodable {
    var durationInSeconds: Int
    var userAnswers: [UserAnswers]
}

struct UserAnswers: Encodable {
    var answerId: Int
    var questionId: Int
}
