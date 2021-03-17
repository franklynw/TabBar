//
//  HashableInstantiatable.swift
//  
//
//  Created by Franklyn Weber on 17/03/2021.
//

import Foundation


protocol HashableInstantiatable: Hashable {
    init()
}

extension String: HashableInstantiatable {
    init() {
        self = "String"
    }
}

extension Int: HashableInstantiatable {
    init() {
        self = 0
    }
}
