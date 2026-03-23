//
//  SpecialCondition.swift
//  QuizPlease
//
//  Created by Владислав on 17.06.2021.
//  Copyright © 2021 Владислав. All rights reserved.
//

import Foundation

final class SpecialCondition {
    var value: String?
    var discountInfo: DiscountInfo?
    var conditionId: Int?
}

extension SpecialCondition {
    enum Kind: String, Decodable {
        case promocode = "promo", certificate
    }

    struct DiscountInfo {
        let kind: Kind?
        let discount: DiscountKind?
    }

    struct Response: Decodable {
        let success: Bool
        let message: String
        let id: Int?
        private let kind: SpecialCondition.Kind?
        private let discount: DiscountKind?

        private enum CodingKeys: String, CodingKey {
            case success
            case message
            case type
            case promoType = "promo_type"
            case percent
            case certificateType = "certificate_type"
            case promocode
            case certificate
        }

        init(from decoder: Decoder) throws {
            let container = try decoder.container(keyedBy: CodingKeys.self)

            success = try container.decode(Bool.self, forKey: .success)
            message = try container.decode(String.self, forKey: .message)

            let legacyKind = try container.decodeIfPresent(SpecialCondition.Kind.self, forKey: .type)
            let legacyPromoType = try container.decodeIfPresent(Int.self, forKey: .promoType)
            let legacyPercent = try container.decodeIfPresent(Double.self, forKey: .percent)
            let legacyCertificateType = try container.decodeIfPresent(Int.self, forKey: .certificateType)

            if let promocode = try container.decodeIfPresent(Promocode.self, forKey: .promocode) {
                id = promocode.id
                kind = .promocode
                discount = Self.makePromocodeDiscount(
                    freeMembers: promocode.freeMembers,
                    promoType: legacyPromoType,
                    percentFraction: promocode.percentFraction ?? legacyPercent
                )
                return
            }

            if let certificate = try container.decodeIfPresent(Certificate.self, forKey: .certificate) {
                id = certificate.id
                kind = .certificate
                discount = Self.makeCertificateDiscount(
                    value: certificate.value,
                    certificateType: legacyCertificateType
                )
                return
            }

            id = nil
            kind = legacyKind ?? Self.inferKind(
                promoType: legacyPromoType,
                percent: legacyPercent,
                certificateType: legacyCertificateType
            )
            discount = Self.makeDiscount(
                kind: kind,
                promoType: legacyPromoType,
                percent: legacyPercent,
                certificateType: legacyCertificateType
            )
        }
    }
}

extension SpecialCondition.Response {
    private struct Promocode: Decodable {
        let id: Int?
        let freeMembers: Int?
        let percentFraction: Double?

        private enum CodingKeys: String, CodingKey {
            case id
            case freeMembers = "free_members"
            case percent
        }

        init(from decoder: Decoder) throws {
            let container = try decoder.container(keyedBy: CodingKeys.self)

            if let id = try container.decodeIfPresent(Int.self, forKey: .id) {
                self.id = id
            } else if let id = try container.decodeIfPresent(String.self, forKey: .id) {
                self.id = Int(id)
            } else {
                self.id = nil
            }

            if let freeMembers = try container.decodeIfPresent(Int.self, forKey: .freeMembers) {
                self.freeMembers = freeMembers
            } else if let freeMembers = try container.decodeIfPresent(String.self, forKey: .freeMembers) {
                self.freeMembers = Int(freeMembers)
            } else {
                self.freeMembers = nil
            }

            if let percent = try container.decodeIfPresent(Double.self, forKey: .percent) {
                self.percentFraction = percent / 100
            } else {
                self.percentFraction = nil
            }
        }
    }

    private struct Certificate: Decodable {
        let id: Int?
        let value: String?

        private enum CodingKeys: String, CodingKey {
            case id
            case value
        }

        init(from decoder: Decoder) throws {
            let container = try decoder.container(keyedBy: CodingKeys.self)

            if let id = try container.decodeIfPresent(Int.self, forKey: .id) {
                self.id = id
            } else if let id = try container.decodeIfPresent(String.self, forKey: .id) {
                self.id = Int(id)
            } else {
                self.id = nil
            }

            if let value = try container.decodeIfPresent(String.self, forKey: .value) {
                self.value = value
            } else if let value = try container.decodeIfPresent(Int.self, forKey: .value) {
                self.value = String(value)
            } else {
                self.value = nil
            }
        }
    }

    private static func inferKind(
        promoType: Int?,
        percent: Double?,
        certificateType: Int?
    ) -> SpecialCondition.Kind? {
        if certificateType != nil {
            return .certificate
        }
        if promoType != nil || percent != nil {
            return .promocode
        }
        return nil
    }

    private static func makeDiscount(
        kind: SpecialCondition.Kind?,
        promoType: Int?,
        percent: Double?,
        certificateType: Int?
    ) -> DiscountKind? {
        switch kind {
        case .promocode:
            return makePromocodeDiscount(
                freeMembers: nil,
                promoType: promoType,
                percentFraction: percent
            )
        case .certificate:
            return makeCertificateDiscount(
                value: nil,
                certificateType: certificateType
            )
        case .none:
            return nil
        }
    }

    private static func makePromocodeDiscount(
        freeMembers: Int?,
        promoType: Int?,
        percentFraction: Double?
    ) -> DiscountKind? {
        if let freeMembers, freeMembers > 0 {
            return .somePeopleForFree(amount: freeMembers)
        }
        if let promoType, promoType > 0 {
            return .somePeopleForFree(amount: promoType)
        }
        if let percentFraction, percentFraction > 0 {
            return .percent(fraction: percentFraction)
        }
        return nil
    }

    private static func makeCertificateDiscount(
        value: String?,
        certificateType: Int?
    ) -> DiscountKind? {
        if let certificateType,
           let certDiscount = CertificateDiscountType(rawValue: certificateType) {
            return .certificateDiscount(type: certDiscount)
        }

        guard let value = value?.trimmingCharacters(in: .whitespacesAndNewlines).lowercased() else {
            return nil
        }

        if value == "paid" {
            return .certificateDiscount(type: .allTeamFree)
        }

        if let peopleForFree = Int(value), peopleForFree > 0 {
            return .certificateDiscount(type: .numberOfPeopleForFree(peopleForFree))
        }

        return nil
    }

    var discountInfo: SpecialCondition.DiscountInfo {
        SpecialCondition.DiscountInfo(kind: kind, discount: discount)
    }
}
