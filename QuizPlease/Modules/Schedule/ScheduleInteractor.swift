//
//  ScheduleInteractor.swift
//  QuizPlease
//
//  Created by Владислав on 04.08.2020.
//  Copyright © 2020 Владислав. All rights reserved.
//

import Foundation

protocol ScheduleInteractorProtocol: class {
    func loadSchedule(completion: @escaping (Result<[GameInfo]?, Error>) -> Void)
    
    func openInMaps(placeName: String, withLongitutde lon: Double, andLatitude lat: Double)
    func openInMaps(place: Place)
}

class ScheduleInteractor: ScheduleInteractorProtocol {
    func loadSchedule(completion: @escaping (Result<[GameInfo]?, Error>) -> Void) {
        var games = [GameInfo]()
        games.insert(GameInfo(gameNumber: 62, name: "[Кино и музыка]",
                              place: Place(name: "Chesterfield Bar",
                                           address: "ул. Новый Арбат, 19",
                                           longitude: 37.589200, latitude: 55.751983),
                              time: "20:00", price: Decimal(500),
                              annotation: "Битва для тех, кто одинаково знаком с такими понятиями как «соль мажор», «увертюра» и «девочка-война». Для тех, кто не зря ходил на сольфеджио и понимает, о чем там поет Моргенштерн (это вообще никак не связано, если что). Для всех любителей музыки!"), at: 0)
        for i in 0...3 {
            let place = Place(name: "Place\(i)", address: "Address\(i)", longitude: 37.617635, latitude: 55.755814)
            games.append(GameInfo(gameNumber: i+1, name: "Game\(i)", place: place, time: "11:0\(i)", price: Decimal(1000 * i), annotation: "Annotation \(i)"))
        }
        completion(.success(games))
    }
    
    func openInMaps(placeName: String, withLongitutde lon: Double, andLatitude lat: Double) {
        MapService.openMap(for: placeName, withLongitude: lon, andLatitude: lat)
    }
    
    func openInMaps(place: Place) {
        MapService.openMap(for: place.name, withAddress: place.address)
    }
    
}
