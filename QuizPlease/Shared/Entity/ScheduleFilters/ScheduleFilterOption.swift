//
//  ScheduleFilterOption.swift
//  QuizPlease
//
//  Created by Владислав on 13.09.2020.
//  Copyright © 2020 Владислав. All rights reserved.
//

import Foundation

struct ScheduleFilterOption: Decodable {//, ScheduleFilterProtocol {
    var id: String
    var title: String
    var address: String?
    
    private enum CodingKeys: String, CodingKey {
        case id, title, address
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        title = try container.decode(String.self, forKey: .title)
        address = try? container.decode(String.self, forKey: .address)
        
        if let id = try? container.decode(String.self, forKey: .id) {
            self.id = id
        } else {
            let id = (try? container.decode(Int.self, forKey: .id)) ?? -1
            self.id = "\(id)"
        }
    }
    
}
