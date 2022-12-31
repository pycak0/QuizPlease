//
//  WarmupQuestionTypeResolver.swift
//  QuizPlease
//
//  Created by Владислав on 30.12.2022.
//  Copyright © 2022 Владислав. All rights reserved.
//

import UIKit

// MARK: - MediaConfiguration

private enum MediaConfiguration {

    /// Known image formats
    static let knownImageFormats: Set<String> = {
        var fileExtensions = (CGImageSourceCopyTypeIdentifiers() as? [String])?
            .compactMap { URL(string: $0)?.pathExtension } ?? []
        fileExtensions += ["jpg"]

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
        return Set(["mp4", "mov", "m4v", "3gp"])
    }()
}

/// Warmup question type resolver
protocol WarmupQuestionTypeResolver {

    /// Resolve WarmupQuestionType from given question model.
    /// - Parameter question: `WarmupQuestion` instance
    /// - Returns: `WarmupQuestionType`. If could not resolve the type,
    /// will return `WarmupQuestionType.text`.
    func resolve(question: WarmupQuestion) -> WarmupQuestionType
}

/// Class that implements warmup question type resolver
final class WarmupQuestionTypeResolverImpl: WarmupQuestionTypeResolver {

    func resolve(question: WarmupQuestion) -> WarmupQuestionType {
        var question = question
        guard let url = question.fileUrl else {
            return .text
        }
        let mediaFormat = url.pathExtension

        if MediaConfiguration.knownImageFormats.contains(mediaFormat) {
            return .imageWithText
        }
        if MediaConfiguration.knownVideoFormats.contains(mediaFormat) {
            return .videoWithText
        }
        if MediaConfiguration.knownAudioFormats.contains(mediaFormat) {
            return .soundWithText
        }
        return .text
    }
}
