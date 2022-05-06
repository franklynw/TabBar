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
    internal var barBackground: TabBarBackground?
    internal var animateTabBarSelection = true
    
    
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
        if let barBackground = barBackground {
            context.coordinator.setBarBackground(barBackground)
        }
    }
    
    public func makeCoordinator() -> Coordinator {
        return Coordinator(self)
    }
    
    public class Coordinator: NSObject, UITabBarControllerDelegate {

        let tabBarController = UITabBarController()
        
        private let parent: TabBar
        
        private var selection: AnyCancellable?
        
        private var tabIdentifiers = [Int]()
        private var oldTabIdentifiers = [Int]()
        

        init(_ parent: TabBar) {
            
            self.parent = parent
            
            super.init()
            
            selection = parent.selection?
                .sink { [weak self] in
                    self?.setTab($0)
                }
            
            if let barBackground = parent.barBackground {
                setBarBackground(barBackground)
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
        
        fileprivate func setBarBackground(_ barBackground: TabBarBackground) {
            
            let tabBarAppearance = UITabBarAppearance()
            
            let backgroundColor: UIColor?
            let backgroundImage: UIImage?
            
            switch barBackground {
            case .color(let color):
                backgroundColor = color != nil ? UIColor(color!) : nil
                backgroundImage = nil
            case .image(let image):
                backgroundColor = nil
                backgroundImage = image
            }
            
            func changeBackground() {
                if #available(iOS 15.0, *) {
                    tabBarAppearance.configureWithOpaqueBackground()
                    tabBarAppearance.backgroundColor = backgroundColor
                    tabBarAppearance.backgroundImage = backgroundImage
                    self.tabBarController.tabBar.standardAppearance = tabBarAppearance
                    self.tabBarController.tabBar.scrollEdgeAppearance = tabBarAppearance
                } else {
                    self.tabBarController.tabBar.barTintColor = backgroundColor
                    self.tabBarController.tabBar.backgroundImage = backgroundImage
                }
            }
            
            if parent.animateTabBarSelection {
                UIView.transition(with: tabBarController.view, duration: 0.3, options: .transitionCrossDissolve) {
                    changeBackground()
                } completion: { _ in }
            } else {
                changeBackground()
            }
        }
    }
}
