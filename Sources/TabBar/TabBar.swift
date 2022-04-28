//
//  TabBar.swift
//
//  Created by Franklyn Weber on 17/03/2021.
//

import SwiftUI
import Combine


public struct TabBar {
    
    private let items: [(() -> TabBarContainable)]
    private let selection: Published<Int>.Publisher?
    
    internal var tabbed: ((Int) -> ())?
    internal var barBackground: Published<TabBarBackground>.Publisher?
    internal var staticBarBackground: TabBarBackground?
    internal var animateBarChanges = true
    
    
    public init(selection: Published<Int>.Publisher? = nil, items: [() -> TabBarContainable]) {
        self.selection = selection
        self.items = items
    }
}


// MARK: - UIViewControllerRepresentable
extension TabBar: UIViewControllerRepresentable {
    
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
        
        private var tabIdentifiers = [Int]()
        private var oldTabIdentifiers = [Int]()
        

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
                }
            
            if let staticBarBackground = parent.staticBarBackground {
                setBarBackground(staticBarBackground)
            }
            
            let viewControllers = makeTabBarViewControllers()
            tabBarController.setViewControllers(viewControllers, animated: false)
            tabBarController.delegate = self
        }
        
        public func tabBarController(_ tabBarController: UITabBarController, didSelect viewController: UIViewController) {
            let identifier = viewController.view.tag
            parent.tabbed?(identifier)
        }
        
        public func tabBarController(_ tabBarController: UITabBarController, willBeginCustomizing viewControllers: [UIViewController]) {
            oldTabIdentifiers = tabIdentifiers
        }
        
        public func tabBarController(_ tabBarController: UITabBarController, didEndCustomizing viewControllers: [UIViewController], changed: Bool) {
            
            guard changed else {
                return
            }
            
            tabIdentifiers.removeAll()
            tabBarController.viewControllers?.enumerated().forEach {
                let previousTabIndex = $0.element.view.tag
                let identifier = oldTabIdentifiers[previousTabIndex]
                tabIdentifiers.append(identifier)
                $0.element.view.tag = $0.offset
            }
        }
        
        private func makeTabBarViewControllers() -> [UIViewController] {
            
            var viewControllers = [UIViewController]()
            
            func makeItem(_ item: TabBarContainable, index: Int) {
                
                let hostingController = UIHostingController(rootView: item.tabBarItemView)
                
                tabIdentifiers.append(item.tabBarItem.identifier)
                let image = item.tabBarItem.image
                let barItem = UITabBarItem(title: item.tabBarItem.name, image: image, tag: index)
                
                hostingController.tabBarItem = barItem
                hostingController.view.tag = index
                
                viewControllers.append(hostingController)
            }
            
            parent.items.enumerated().forEach {
                makeItem($0.element(), index: $0.offset)
            }
            
            return viewControllers
        }
        
        private func setTab(_ tabIdentifier: Int) {
            tabBarController.selectedIndex = tabIdentifier
        }
    }
}
