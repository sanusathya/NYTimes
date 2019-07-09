//
//  MappableObject.swift
//  NYTimes
//
//  Created by Sanu Leema on 7/9/19.
//  Copyright © 2019 Sanu. All rights reserved.
//

import ObjectMapper

class MappableObject: Mappable {
    
    required init?(map: Map) {}
    func mapping(map: Map) {}
    
    // to create object without a JSON
    init() {}
}
