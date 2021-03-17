//
//  TabBarItem.swift
//  
//
//  Created by Franklyn Weber on 17/03/2021.
//

import UIKit


public struct TabBarItem<I: Hashable> {
    let name: String
    let imageName: String?
    let imageSystemName: String?
    let identifier: I
    
    public init(name: String, imageName: String) where I == Int {
        self.name = name
        self.imageName = imageName
        imageSystemName = nil
        identifier = 0
    }
    
    public init(name: String, imageName: String, identifier: I) {
        self.name = name
        self.imageName = imageName
        self.identifier = identifier
        imageSystemName = nil
    }
    
    public init(name: String, imageSystemName: String) where I == Int {
        self.name = name
        self.imageSystemName = imageSystemName
        imageName = nil
        identifier = 0
    }
    
    public init(name: String, imageSystemName: String, identifier: I) {
        self.name = name
        self.imageSystemName = imageSystemName
        self.identifier = identifier
        imageName = nil
    }
    
    var image: UIImage? {
        if let imageName = imageName {
            return UIImage(named: imageName)
        } else if let imageSystemName = imageSystemName {
            return UIImage(systemName: imageSystemName)
        }
        return nil
    }
}
