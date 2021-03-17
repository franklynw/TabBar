//
//  TabBarContainable.swift
//  
//
//  Created by Franklyn Weber on 17/03/2021.
//

import SwiftUI


public protocol TabBarContainable: View {
    associatedtype TabBarItemIdentifier: Hashable
    var tabBarItem: TabBarItem<TabBarItemIdentifier> { get }
}
