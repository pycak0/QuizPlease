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
        if let file = file, file != "" {
            return .imageWithText
        }
        return .text
    }
    
    var imageUrl: URL? {
        let filePath = file?.removingPercentEncoding ?? ""
        if filePath == "" {
            return nil
        }
        var urlComps = Globals.baseUrl // URLComponents(string: Globals.mainDomain)
        urlComps.path = filePath.pathProof
        return urlComps.url
    }
    
    var videoUrl: URL? {
        nil
    }
    
    var soundUrl: URL? { nil }
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
