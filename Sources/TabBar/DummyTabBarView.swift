//
//  DummyTabBarView.swift
//  
//
//  Created by Franklyn Weber on 17/03/2021.
//

import SwiftUI


struct DummyTabBarView<I: HashableInstantiatable>: TabBarContainable {
    
    var tabBarItem: TabBarItem<I> {
        TabBarItem(name: "No name", imageName: "No image", identifier: I())
    }
    
    var body: some View {
        EmptyView()
    }
}
