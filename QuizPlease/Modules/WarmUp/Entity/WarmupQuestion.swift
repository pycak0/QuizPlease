//
//  WarmupQuestion.swift
//  QuizPlease
//
//  Created by Владислав on 28.08.2020.
//  Copyright © 2020 Владислав. All rights reserved.
//

import UIKit

// MARK: - WarmupQuestion

struct WarmupQuestion {
    /// Question identifier
    let id: String
    /// Question text
    let question: String?
    /// Answer options
    let answers: [WarmupAnswer]

    private let file: String?

    /// Media attachment URL
    lazy var fileUrl: URL? = {
        guard let filePath = file?.pathProof, !filePath.isEmpty else {
            return nil
        }
        var urlComps = NetworkService.shared.baseUrlComponents
        urlComps.path = filePath
        return urlComps.url
    }()

    init(
        id: String,
        question: String?,
        answers: [WarmupAnswer],
        file: String?
    ) {
        self.id = id
        self.question = question
        self.answers = answers
        self.file = file
    }
}

// MARK: - Decodable

extension WarmupQuestion: Decodable {

    private enum CodingKeys: String, CodingKey {
        case question, answers, file, id
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        question = try container.decode(String.self, forKey: .question)

        let answerString = try container.decode(String.self, forKey: .answers)
        let answerArray = try JSONDecoder().decode([String].self, from: Data(answerString.utf8))
        answers = answerArray.enumerated().map { (index, answer) in
            WarmupAnswer(value: answer, id: index)
        }
        file = try container.decode(String.self, forKey: .file)
        id = try container.decode(String.self, forKey: .id)
    }
}
