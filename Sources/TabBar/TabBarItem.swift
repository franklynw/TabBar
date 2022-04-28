//
//  TabBarItem.swift
//  
//
//  Created by Franklyn Weber on 17/03/2021.
//

import UIKit


public struct TabBarItem {
    let name: String
    let imageName: String?
    let imageSystemName: String?
    let identifier: Int
    
    public init(name: String, imageName: String) {
        self.name = name
        self.imageName = imageName
        imageSystemName = nil
        identifier = 0
    }
    
    public init(name: String, imageName: String, identifier: Int) {
        self.name = name
        self.imageName = imageName
        self.identifier = identifier
        imageSystemName = nil
    }
    
    public init(name: String, imageSystemName: String) {
        self.name = name
        self.imageSystemName = imageSystemName
        imageName = nil
        identifier = 0
    }
    
    public init(name: String, imageSystemName: String, identifier: Int) {
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
