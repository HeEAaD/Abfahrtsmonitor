//
//  EfaProvider.swift
//  Tram
//
//  Created by Steffen Matthischke on 25.09.16.
//  Copyright © 2016 Matthischke. All rights reserved.
//

import Foundation

enum EfaProvider {
    case vvo
    case gvh
    
    var coordBaseURL: URL {
        switch self {
        case .vvo:
            return URL(string: "http://efa.vvo-online.de:8080/standard/XML_COORD_REQUEST")!
        case .gvh:
            return URL(string: "http://efa155.efa.de/efaws2/default/XML_COORD_REQUEST?mId=efa_www")!
        }
    }
    
    static let all = Set<EfaProvider>(arrayLiteral: .vvo, .gvh)
}
