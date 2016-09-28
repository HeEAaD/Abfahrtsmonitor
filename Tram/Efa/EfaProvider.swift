//
//  EfaProvider.swift
//  Tram
//
//  Created by Steffen Matthischke on 25.09.16.
//  Copyright © 2016 Matthischke. All rights reserved.
//

import Foundation
import CoreLocation

protocol EfaProvider {
    var id: String { get }
    var baseURL: String { get } // e.g. http://efa155.efa.de/efaws2/default/
    var center: CLLocationCoordinate2D { get }
    var addionalQueryItems: [URLQueryItem] { get }
}

extension EfaProvider {
    var addionalQueryItems: [URLQueryItem] {
        return []
    }
}

struct VVOProvider: EfaProvider {
    let id = "VVO"
    let baseURL = "http://efa.vvo-online.de:8080/standard/"
    let center = CLLocationCoordinate2D(latitude: 51.051128, longitude: 13.733356) // Dresden
}

struct GVHProvider: EfaProvider {
    let id = "GVH"
    let baseURL = "http://efa155.efa.de/efaws2/default/"
    let center = CLLocationCoordinate2D(latitude: 52.387128, longitude: 9.735375) // Hannover
    let addionalQueryItems = [URLQueryItem(name: "mId", value: "efa_www")]
}

struct MVVProvider: EfaProvider {
    let id = "MVV"
    let baseURL = "http://efa.mvv-muenchen.de/ng/"
    let center = CLLocationCoordinate2D(latitude: 48.144289, longitude: 11.570670) // Munich
}


// MARK: - Network
extension EfaProvider {
    func coordRequestUrl(with coordinate: CLLocationCoordinate2D) -> URL {

        guard var components = URLComponents(string: self.baseURL) else {
            fatalError()
        }

        if !components.path.hasSuffix("/") {
            components.path += "/"
        }
        components.path += "XML_COORD_REQUEST"

        components.queryItems = self.addionalQueryItems  + [
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
}

extension Tram {

    /// All registered EFA providers. Can be extended.
    static var allEfaProvider: [EfaProvider] = {
        return [
            VVOProvider(),
            GVHProvider(),
            MVVProvider()
        ]
    }()

    static func nearestEfaProvider(from coordinate: CLLocationCoordinate2D) -> EfaProvider {

        var nearestProvider = self.allEfaProvider[0]
        var nearestDistance = CLLocationDistanceMax

        for provider in self.allEfaProvider {
            let distance = provider.center.distance(from: coordinate)
            if distance < nearestDistance {
                nearestProvider = provider
                nearestDistance = distance
            }
        }

        return nearestProvider
    }
}
