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
    var id: String
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
        if let url = makeUrl(from: file?.pathProof),
           url.pathExtension == "jpg" || url.pathExtension == "png" {
            return url
        }
        return nil
    }
    
    var videoUrl: URL? {
        if let url = makeUrl(from: file?.pathProof), url.pathExtension == "mp4" {
            return url
        }
        return nil
    }
    
    var soundUrl: URL? {
        if let url = makeUrl(from: file?.pathProof), url.pathExtension == "mp3" {
            return url
        }
        return nil
    }
    
    private func makeUrl(from path: String?) -> URL? {
        guard let path = path else { return nil }
        var urlComps = NetworkService.shared.baseUrlComponents // URLComponents(string: NetworkConfiguration.prod.host)
        urlComps.path = path
        return urlComps.url
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
        answers = []
        for (index, answer) in answerArray.enumerated() {
            answers.append(WarmupAnswer(value: answer, id: index))
        }
        file = try container.decode(String.self, forKey: .file)
        id = try container.decode(String.self, forKey: .id)
    }
}
