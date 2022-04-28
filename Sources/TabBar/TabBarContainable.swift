//
//  TabBarContainable.swift
//  
//
//  Created by Franklyn Weber on 17/03/2021.
//

import SwiftUI


public protocol TabBarContainable {
    var tabBarItem: TabBarItem { get }
    var tabBarItemView: AnyView { get }
}
