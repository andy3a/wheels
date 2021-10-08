//
//  TestMode.swift
//  wheels_Andrew
//
//  Created by Andrew on 28.07.21.
//

import Foundation

enum TestMode {
    case topics
    case chapters
    case random
    case personalized
    
    var title: String {
        switch self {
        case .chapters:
            return "Главы ПДД"
        case .topics:
            return "Темы ПДД"
        case .random:
            return ""
        case .personalized:
            return ""
        }
        
    }
    
    var pathComponent: String {
        switch self {
        case .topics:
            return "topic"
        case .chapters:
            return "chapter"
        case .random:
            return ""
        case .personalized:
            return ""
        }
    }
}
