//
//  Question.swift
//  wheels_Andrew
//
//  Created by Andrew on 26.07.21.
//

import Foundation

struct PersonalizedQuestions: Decodable {
    let endTime: String
    let questions: [Question]
}

struct QuestionDictionary: Decodable {
    let questions: [Question]
    let endTime: String
}

struct Question: Decodable {
    let id: Int
    let text: String
    let imageURL: URL?
    let topicID: Int
    let paragraph: Paragraph?
    let answers: [Answer]

    enum CodingKeys: String, CodingKey {
        case id, text
        case imageURL = "linkToImage"
        case topicID = "topicId"
        case paragraph, answers
    }
}

// MARK: - Answer
struct Answer: Decodable {
    let id: Int
    let text: String
    let correct: Bool
}

// MARK: - Paragraph
struct Paragraph: Decodable {
    let id: Int
    let text: String
    let chapter: Chapter
    let articles: [Article]?
}

// MARK: - Article
struct Article: Decodable {
    let id: Int
    let text: String
}

// MARK: - Chapter
struct Chapter: Decodable {
    let id: Int
    let name: String
}
