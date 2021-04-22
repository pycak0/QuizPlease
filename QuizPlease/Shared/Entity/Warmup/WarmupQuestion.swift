//
//  WarmupQuestion.swift
//  QuizPlease
//
//  Created by Владислав on 28.08.2020.
//  Copyright © 2020 Владислав. All rights reserved.
//

import Foundation

enum WarmupQuestionType: Int, CaseIterable, Decodable {
    case image, imageWithText, text, soundWithText, videoWithText
}

struct WarmupQuestion {
    var id: Double
    var question: String?
    var answers: [WarmupAnswer]
    
    private var file: String?
    
    var type: WarmupQuestionType {
        guard file != nil, file != "" else {
            return .text
        }
        if imageUrl != nil {
            return .imageWithText
        }
        if soundUrl != nil {
            return .soundWithText
        }
        if videoUrl != nil {
            return .videoWithText
        }
        return .text
    }
    
    var imageUrl: URL? {
        if let url = buildUrl(from: file?.pathProof),
           url.pathExtension == "jpg" || url.pathExtension == "png" {
            return url
        }
        return nil
    }
    
    var videoUrl: URL? {
        if let url = buildUrl(from: file?.pathProof), url.pathExtension == "mp4" {
            return url
        }
        return nil
    }
    
    var soundUrl: URL? {
        if let url = buildUrl(from: file?.pathProof), url.pathExtension == "mp3" {
            return url
        }
        return nil
    }
    
    ///Returns `true` if the given answer was correct
    func isAnswerCorrect(_ answer: String) -> Bool {
        return answers.contains(where: { $0.value == answer && $0.correct })
    }
    
    private func buildUrl(from path: String?) -> URL? {
        guard let path = path else { return nil }
        var urlComps = NetworkService.shared.baseUrlComponents // URLComponents(string: Configuration.prod.host)
        urlComps.path = path
        return urlComps.url
    }
}

//MARK:- Decodable
extension WarmupQuestion: Decodable {
    private enum CodingKeys: String, CodingKey {
        case question, answers, file, id
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        question = try container.decode(String.self, forKey: .question)
        
        let answerString = try container.decode(String.self, forKey: .answers)
        answers = try JSONDecoder().decode([WarmupAnswer].self, from: Data(answerString.utf8))
        file = try container.decode(String.self, forKey: .file)
        id = try container.decode(Double.self, forKey: .id)
    }
}
