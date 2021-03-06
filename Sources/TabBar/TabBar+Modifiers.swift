//
//  TabBar+Modifiers.swift
//  
//
//  Created by Franklyn Weber on 17/03/2021.
//

import SwiftUI


extension TabBar {
  
    /// Provide a closure to be notified of tab changes - the parameter in the closure is the identifier of the tab item
    /// - Parameter tabbed: a closure which is invoked on tab change
    public func tabChanged(_ tabbed: @escaping (S) -> ()) -> Self {
        var copy = self
        copy.tabbed = tabbed
        return copy
    }
    
    /// Set the background of the tabBar - either a Color or a UIImage
    /// - Parameter barBackground: a Publisher which emits background changes, which allows the background to dynamically update
    public func barBackground(_ barBackground: Published<TabBarBackground>.Publisher) -> Self {
        var copy = self
        copy.barBackground = barBackground
        return copy
    }
    
    /// Set the background of the tabBar - either a Color or a UIImage
    /// - Parameter barBackground: a TabBarBackground value
    public func barBackground(_ barBackground: TabBarBackground) -> Self {
        var copy = self
        copy.staticBarBackground = barBackground
        return copy
    }
    
    /// The default behaviour is to fade from one item to the next, and to cross-dissolve background colour & image changes; use this modifier to make the changes instantaneous
    public var disableBarAnimation: Self {
        var copy = self
        copy.animateBarChanges = false
        return copy
    }
}
