//
//  WarmupQuestion.swift
//  QuizPlease
//
//  Created by Владислав on 28.08.2020.
//  Copyright © 2020 Владислав. All rights reserved.
//

import UIKit

// MARK: - MediaConfiguration

private enum MediaConfiguration {

    /// Known image formats
    static let knownImageFormats: Set<String> = {
        let fileExtensions = (CGImageSourceCopyTypeIdentifiers() as? [String])?
            .compactMap { URL(string: $0)?.pathExtension } ?? []
        return Set(fileExtensions)
    }()

    /// Known audio formats
    static let knownAudioFormats: Set<String> = {
        return Set(["aac", "adts", "ac3",
                   "aif", "aiff", "aifc", "caf", "mp3",
                   "m4a", "snd", "au", "sd2", "wav"])
    }()

    /// Known video formats
    static let knownVideoFormats: Set<String> = {
        return Set(["mp4", "mov", ".m4v", ".3gp"])
    }()
}

// MARK: - WarmupQuestionType

enum WarmupQuestionType: Int, CaseIterable, Decodable {
    case image, imageWithText, text, soundWithText, videoWithText
}

// MARK: - WarmupQuestion

struct WarmupQuestion {
    let id: String
    let question: String?
    let answers: [WarmupAnswer]

    private let file: String?

    private lazy var fileUrl: URL? = {
        guard let filePath = file?.pathProof, !filePath.isEmpty else {
            return nil
        }
        var urlComps = NetworkService.shared.baseUrlComponents
        urlComps.path = filePath
        return urlComps.url
    }()

    lazy var type: WarmupQuestionType = {
        guard fileUrl != nil else {
            return .text
        }
        if imageUrl != nil {
            return .imageWithText
        }
        if videoUrl != nil {
            return .videoWithText
        }
        if soundUrl != nil {
            return .soundWithText
        }
        return .text
    }()

    lazy var imageUrl: URL? = {
        if let url = fileUrl,
           MediaConfiguration.knownImageFormats.contains(url.pathExtension) {
            return url
        }
        return nil
    }()

    lazy var videoUrl: URL? = {
        if let url = fileUrl,
           MediaConfiguration.knownVideoFormats.contains(url.pathExtension) {
            return url
        }
        return nil
    }()

    lazy var soundUrl: URL? = {
        if let url = fileUrl,
           MediaConfiguration.knownAudioFormats.contains(url.pathExtension) {
            return url
        }
        return nil
    }()
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
