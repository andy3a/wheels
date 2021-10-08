//
//  CacheManager.swift
//  wheels_Andrew
//
//  Created by Andrew_Alekseyuk on 25.08.21.
//

import Foundation

class CacheManager {

    static let chapterCache = Cache<String, [RuleUnitItem]>()
    static let topicCache = Cache<String, [RuleUnitItem]>()
}
