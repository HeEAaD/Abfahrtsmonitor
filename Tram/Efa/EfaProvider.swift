//
//  EfaProvider.swift
//  Tram
//
//  Created by Steffen Matthischke on 25.09.16.
//  Copyright © 2016 Matthischke. All rights reserved.
//

import Foundation
import CoreLocation

enum EfaProvider {
    case vvo
    case gvh

    fileprivate var coordBaseURL: String {
        switch self {
        case .vvo:
            return "http://efa.vvo-online.de:8080/standard/XML_COORD_REQUEST"
        case .gvh:
            return "http://efa155.efa.de/efaws2/default/XML_COORD_REQUEST?mId=efa_www"
        }
    }

    fileprivate var center: CLLocationCoordinate2D {
        switch self {
        case .vvo:
            return CLLocationCoordinate2D(latitude: 51.051128, longitude: 13.733356) // Dresden
        case .gvh:
            return CLLocationCoordinate2D(latitude: 52.387128, longitude: 9.735375) // Hannover
        }
    }

    static let all = Set<EfaProvider>(arrayLiteral: .vvo, .gvh)
}



// MARK: - Network
extension EfaProvider {

    func url(with coordinate: CLLocationCoordinate2D) -> URL {

        guard var components = URLComponents(string: self.coordBaseURL) else {
            fatalError()
        }

        components.queryItems = (components.queryItems ?? []) + [
            URLQueryItem(name: "coordOutputFormat", value: "WGS84[DD.ddddd]"),
            URLQueryItem(name: "max", value: "10"),
            URLQueryItem(name: "radius_1", value: "1000"),
            URLQueryItem(name: "inclFilter", value: "1"),
            URLQueryItem(name: "type_1", value: "STOP"),
            URLQueryItem(name: "outputFormat", value: "JSON"),
            URLQueryItem(name: "coord", value: String(format: "%f:%f:WGS84", coordinate.longitude, coordinate.latitude)),
        ]

        guard let url = components.url else {
            fatalError()
        }
        return url
    }

    static func nearest(from coordinate: CLLocationCoordinate2D) -> EfaProvider {

        var nearestProvider = EfaProvider.vvo
        var nearestDistance = CLLocationDistanceMax

        for provider in EfaProvider.all {
            let distance = provider.center.distance(from: coordinate)
            if distance < nearestDistance {
                nearestProvider = provider
                nearestDistance = distance
            }
        }

        return nearestProvider
    }
}
