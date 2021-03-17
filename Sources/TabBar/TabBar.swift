//
//  TabBar.swift
//
//  Created by Franklyn Weber on 17/03/2021.
//

import SwiftUI
import Combine


public struct TabBar<S, V1, V2, V3, V4, V5>: UIViewControllerRepresentable where V1: TabBarContainable, V1.TabBarItemIdentifier == S, V2: TabBarContainable, V2.TabBarItemIdentifier == S, V3: TabBarContainable, V3.TabBarItemIdentifier == S, V4: TabBarContainable, V4.TabBarItemIdentifier == S, V5: TabBarContainable, V5.TabBarItemIdentifier == S {
    
    private let item1: (() -> V1)?
    private let item2: (() -> V2)?
    private let item3: (() -> V3)?
    private let item4: (() -> V4)?
    private let item5: (() -> V5)?
    
    private let selection: Published<S>.Publisher?
    
    internal var tabbed: ((S) -> ())?
    internal var barBackground: Published<TabBarBackground>.Publisher?
    internal var staticBarBackground: TabBarBackground?
    internal var animateBarChanges = true
    
    
    public init(_ item1: @escaping () -> V1) where V2 == DummyTabBarView<Int>, V3 == DummyTabBarView<Int>, V4 == DummyTabBarView<Int>, V5 == DummyTabBarView<Int> {
        self.item1 = item1
        item2 = nil
        item3 = nil
        item4 = nil
        item5 = nil
        selection = nil
    }
    
    public init(_ item1: @escaping () -> V1, _ item2: @escaping () -> V2) where V3 == DummyTabBarView<Int>, V4 == DummyTabBarView<Int>, V5 == DummyTabBarView<Int> {
        self.item1 = item1
        self.item2 = item2
        item3 = nil
        item4 = nil
        item5 = nil
        selection = nil
    }
    
    public init(_ item1: @escaping () -> V1, _ item2: @escaping () -> V2, _ item3: @escaping () -> V3) where V4 == DummyTabBarView<Int>, V5 == DummyTabBarView<Int> {
        self.item1 = item1
        self.item2 = item2
        self.item3 = item3
        item4 = nil
        item5 = nil
        selection = nil
    }
    
    public init(_ item1: @escaping () -> V1, _ item2: @escaping () -> V2, _ item3: @escaping () -> V3, _ item4: @escaping () -> V4) where V5 == DummyTabBarView<Int> {
        self.item1 = item1
        self.item2 = item2
        self.item3 = item3
        self.item4 = item4
        item5 = nil
        selection = nil
    }
    
    public init(_ item1: @escaping () -> V1, _ item2: @escaping () -> V2, _ item3: @escaping () -> V3, _ item4: @escaping () -> V4, _ item5: @escaping () -> V5) where S == Int {
        self.item1 = item1
        self.item2 = item2
        self.item3 = item3
        self.item4 = item4
        self.item5 = item5
        selection = nil
    }
    
    
    public init(selection: Published<S>.Publisher, _ item1: @escaping () -> V1) where V2 == DummyTabBarView<S>, V3 == DummyTabBarView<S>, V4 == DummyTabBarView<S>, V5 == DummyTabBarView<S> {
        self.selection = selection
        self.item1 = item1
        item2 = nil
        item3 = nil
        item4 = nil
        item5 = nil
    }
    
    public init(selection: Published<S>.Publisher, _ item1: @escaping () -> V1, _ item2: @escaping () -> V2) where V3 == DummyTabBarView<S>, V4 == DummyTabBarView<S>, V5 == DummyTabBarView<S> {
        self.selection = selection
        self.item1 = item1
        self.item2 = item2
        item3 = nil
        item4 = nil
        item5 = nil
    }
    
    public init(selection: Published<S>.Publisher, _ item1: @escaping () -> V1, _ item2: @escaping () -> V2, _ item3: @escaping () -> V3) where V4 == DummyTabBarView<S>, V5 == DummyTabBarView<S> {
        self.selection = selection
        self.item1 = item1
        self.item2 = item2
        self.item3 = item3
        item4 = nil
        item5 = nil
    }
    
    public init(selection: Published<S>.Publisher, _ item1: @escaping () -> V1, _ item2: @escaping () -> V2, _ item3: @escaping () -> V3, _ item4: @escaping () -> V4) where V5 == DummyTabBarView<S> {
        self.selection = selection
        self.item1 = item1
        self.item2 = item2
        self.item3 = item3
        self.item4 = item4
        item5 = nil
    }
    
    public init(selection: Published<S>.Publisher, _ item1: @escaping () -> V1, _ item2: @escaping () -> V2, _ item3: @escaping () -> V3, _ item4: @escaping () -> V4, _ item5: @escaping () -> V5) {
        self.selection = selection
        self.item1 = item1
        self.item2 = item2
        self.item3 = item3
        self.item4 = item4
        self.item5 = item5
    }
    
    public func makeUIViewController(context: Context) -> UITabBarController {
        return context.coordinator.tabBarController
    }
    
    public func updateUIViewController(_ uiViewController: UITabBarController, context: Context) {
    }
    
    public func makeCoordinator() -> Coordinator {
        return Coordinator(self)
    }
    
    public class Coordinator: NSObject, UITabBarControllerDelegate {

        let tabBarController = UITabBarController()
        
        private let parent: TabBar
        
        private var selection: AnyCancellable?
        private var setBackground: AnyCancellable?
        
        private var tabIdentifiers = [S]() // not relevant for Int tab identifiers
        

        init(_ parent: TabBar) {
            
            self.parent = parent
            
            super.init()
            
            selection = parent.selection?
                .sink { [weak self] in
                    self?.setTab($0)
                }
            
            func setBarBackground(_ barBackground: TabBarBackground) {
                
                switch barBackground {
                case .color(let color):
                    tabBarController.tabBar.barTintColor = color != nil ? UIColor(color!) : nil
                case .image(let image):
                    tabBarController.tabBar.backgroundImage = image
                }
            }
            
            setBackground = parent.barBackground?
                .sink { [weak self] background in
                    guard let self = self else {
                        return
                    }
                    if parent.animateBarChanges {
                        UIView.transition(with: self.tabBarController.tabBar, duration: 0.2, options: .transitionCrossDissolve) {
                            setBarBackground(background)
                        }
                    } else {
                        setBarBackground(background)
                    }
//                    switch $0 {
//                    case .color(let color):
//                        if parent.animateBarChanges {
//                            UIView.transition(with: self.tabBarController.tabBar, duration: 0.2, options: .transitionCrossDissolve) {
//                                self.tabBarController.tabBar.barTintColor = color != nil ? UIColor(color!) : nil
//                            }
//                        } else {
//                            self.tabBarController.tabBar.barTintColor = color != nil ? UIColor(color!) : nil
//                        }
//                    case .image(let image):
//                        if parent.animateBarChanges {
//                            UIView.transition(with: self.tabBarController.tabBar, duration: 0.2, options: .transitionCrossDissolve) {
//                                self.tabBarController.tabBar.backgroundImage = image
//                            }
//                        } else {
//                            self.tabBarController.tabBar.backgroundImage = image
//                        }
//                    }
                }
            
            if let staticBarBackground = parent.staticBarBackground {
                setBarBackground(staticBarBackground)
            }
            
            let viewControllers = makeTabBarViewControllers()
            tabBarController.setViewControllers(viewControllers, animated: false)
            tabBarController.delegate = self
        }
        
        public func tabBarController(_ tabBarController: UITabBarController, didSelect viewController: UIViewController) {
            
            if let identifier = viewController.view.tag as? S {
                parent.tabbed?(identifier)
                return
            }
            
            let identifier = tabIdentifiers[viewController.view.tag]
            parent.tabbed?(identifier)
        }
        
        private func makeTabBarViewControllers() -> [UIViewController] {
            
            var viewControllers = [UIViewController]()
            
            func tabBarItem(_ tabBarItem: TabBarItem<S>, tag: Int) -> UITabBarItem {
                tabIdentifiers.append(tabBarItem.identifier)
                let image = tabBarItem.image
                let item = UITabBarItem(title: tabBarItem.name, image: image, tag: tag)
                return item
            }
            
            if let item = parent.item1?() {
                let hostingController = UIHostingController(rootView: item)
                hostingController.tabBarItem = tabBarItem(item.tabBarItem, tag: 0)
                hostingController.view.tag = 0
                viewControllers.append(hostingController)
            }
            if let item = parent.item2?() {
                let hostingController = UIHostingController(rootView: item)
                hostingController.tabBarItem = tabBarItem(item.tabBarItem, tag: 1)
                hostingController.view.tag = 1
                viewControllers.append(hostingController)
            }
            if let item = parent.item3?() {
                let hostingController = UIHostingController(rootView: item)
                hostingController.tabBarItem = tabBarItem(item.tabBarItem, tag: 2)
                hostingController.view.tag = 2
                viewControllers.append(hostingController)
            }
            if let item = parent.item4?() {
                let hostingController = UIHostingController(rootView: item)
                hostingController.tabBarItem = tabBarItem(item.tabBarItem, tag: 3)
                hostingController.view.tag = 3
                viewControllers.append(hostingController)
            }
            if let item = parent.item5?() {
                let hostingController = UIHostingController(rootView: item)
                hostingController.tabBarItem = tabBarItem(item.tabBarItem, tag: 4)
                hostingController.view.tag = 4
                viewControllers.append(hostingController)
            }
            
            return viewControllers
        }
        
        private func setTab(_ tabIdentifier: S) {
            
            let tabIndex: Int
            
            if let tabIdentifier = tabIdentifier as? Int {
                tabIndex = tabIdentifier
            } else {
                tabIndex = tabIdentifiers.firstIndex(where: {
                    $0 == tabIdentifier
                }) ?? 0
            }
            
            tabBarController.selectedIndex = tabIndex
        }
    }
}
