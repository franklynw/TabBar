//
//  TabBar.swift
//
//  Created by Franklyn Weber on 17/03/2021.
//

import SwiftUI
import Combine


public typealias TC = TabBarContainable
public struct TabBar<S, V1, V2, V3, V4, V5, V6, V7, V8, V9, V10> where V1: TC, V1.TabBarItemIdentifier == S, V2: TC, V2.TabBarItemIdentifier == S, V3: TC, V3.TabBarItemIdentifier == S, V4: TC, V4.TabBarItemIdentifier == S, V5: TC, V5.TabBarItemIdentifier == S, V6: TC, V6.TabBarItemIdentifier == S, V7: TC, V7.TabBarItemIdentifier == S, V8: TC, V8.TabBarItemIdentifier == S, V9: TC, V9.TabBarItemIdentifier == S, V10: TC, V10.TabBarItemIdentifier == S {
    
    /*
     I approached this in a generic way to avoid the use of AnyView for each tab - supposedly there's a performance issue, but regardless of that, this approach uses the pure views.
     It is limited to 10 tabs, though that's probably not going to be a problem...
     */
    
    typealias D = DummyTabBarView
    
    private let item1: (() -> V1)?
    private let item2: (() -> V2)?
    private let item3: (() -> V3)?
    private let item4: (() -> V4)?
    private let item5: (() -> V5)?
    private let item6: (() -> V6)?
    private let item7: (() -> V7)?
    private let item8: (() -> V8)?
    private let item9: (() -> V9)?
    private let item10: (() -> V10)?
    
    private let selection: Published<S>.Publisher?
    
    internal var tabbed: ((S) -> ())?
    internal var barBackground: Published<TabBarBackground>.Publisher?
    internal var staticBarBackground: TabBarBackground?
    internal var animateBarChanges = true
    
    
    private init(_ selection: Published<S>.Publisher?, _ item1: (() -> V1)?, _ item2: (() -> V2)?, _ item3: (() -> V3)?, _ item4: (() -> V4)?, _ item5: (() -> V5)?, _ item6: (() -> V6)?, _ item7: (() -> V7)?, _ item8: (() -> V8)?, _ item9: (() -> V9)?, _ item10: (() -> V10)?) {
        self.selection = selection
        self.item1 = item1
        self.item2 = item2
        self.item3 = item3
        self.item4 = item4
        self.item5 = item5
        self.item6 = item6
        self.item7 = item7
        self.item8 = item8
        self.item9 = item9
        self.item10 = item10
    }
    
    
    public init(_ item1: @escaping () -> V1) where V2 == D<Int>, V3 == D<Int>, V4 == D<Int>, V5 == D<Int>, V6 == D<Int>, V7 == D<Int>, V8 == D<Int>, V9 == D<Int>, V10 == D<Int> {
        self.init(nil, item1, nil, nil, nil, nil, nil, nil, nil, nil, nil)
    }
    
    public init(_ item1: @escaping () -> V1, _ item2: @escaping () -> V2) where V3 == D<Int>, V4 == D<Int>, V5 == D<Int>, V6 == D<Int>, V7 == D<Int>, V8 == D<Int>, V9 == D<Int>, V10 == D<Int> {
        self.init(nil, item1, item2, nil, nil, nil, nil, nil, nil, nil, nil)
    }
    
    public init(_ item1: @escaping () -> V1, _ item2: @escaping () -> V2, _ item3: @escaping () -> V3) where V4 == D<Int>, V5 == D<Int>, V6 == D<Int>, V7 == D<Int>, V8 == D<Int>, V9 == D<Int>, V10 == D<Int> {
        self.init(nil, item1, item2, item3, nil, nil, nil, nil, nil, nil, nil)
    }
    
    public init(_ item1: @escaping () -> V1, _ item2: @escaping () -> V2, _ item3: @escaping () -> V3, _ item4: @escaping () -> V4) where V5 == D<Int>, V6 == D<Int>, V7 == D<Int>, V8 == D<Int>, V9 == D<Int>, V10 == D<Int> {
        self.init(nil, item1, item2, item3, item4, nil, nil, nil, nil, nil, nil)
    }
    
    public init(_ item1: @escaping () -> V1, _ item2: @escaping () -> V2, _ item3: @escaping () -> V3, _ item4: @escaping () -> V4, _ item5: @escaping () -> V5) where V6 == D<Int>, V7 == D<Int>, V8 == D<Int>, V9 == D<Int>, V10 == D<Int> {
        self.init(nil, item1, item2, item3, item4, item5, nil, nil, nil, nil, nil)
    }
    
    public init(_ item1: @escaping () -> V1, _ item2: @escaping () -> V2, _ item3: @escaping () -> V3, _ item4: @escaping () -> V4, _ item5: @escaping () -> V5, _ item6: @escaping () -> V6) where V7 == D<Int>, V8 == D<Int>, V9 == D<Int>, V10 == D<Int> {
        self.init(nil, item1, item2, item3, item4, item5, item6, nil, nil, nil, nil)
    }
    
    public init(_ item1: @escaping () -> V1, _ item2: @escaping () -> V2, _ item3: @escaping () -> V3, _ item4: @escaping () -> V4, _ item5: @escaping () -> V5, _ item6: @escaping () -> V6, _ item7: @escaping () -> V7) where V8 == D<Int>, V9 == D<Int>, V10 == D<Int> {
        self.init(nil, item1, item2, item3, item4, item5, item6, item7, nil, nil, nil)
    }
    
    public init(_ item1: @escaping () -> V1, _ item2: @escaping () -> V2, _ item3: @escaping () -> V3, _ item4: @escaping () -> V4, _ item5: @escaping () -> V5, _ item6: @escaping () -> V6, _ item7: @escaping () -> V7, _ item8: @escaping () -> V8) where V9 == D<Int>, V10 == D<Int> {
        self.init(nil, item1, item2, item3, item4, item5, item6, item7, item8, nil, nil)
    }
    
    public init(_ item1: @escaping () -> V1, _ item2: @escaping () -> V2, _ item3: @escaping () -> V3, _ item4: @escaping () -> V4, _ item5: @escaping () -> V5, _ item6: @escaping () -> V6, _ item7: @escaping () -> V7, _ item8: @escaping () -> V8, _ item9: @escaping () -> V9) where V10 == D<Int> {
        self.init(nil, item1, item2, item3, item4, item5, item6, item7, item8, item9, nil)
    }
    
    public init(_ item1: @escaping () -> V1, _ item2: @escaping () -> V2, _ item3: @escaping () -> V3, _ item4: @escaping () -> V4, _ item5: @escaping () -> V5, _ item6: @escaping () -> V6, _ item7: @escaping () -> V7, _ item8: @escaping () -> V8, _ item9: @escaping () -> V9, _ item10: @escaping () -> V10) where S == Int {
        self.init(nil, item1, item2, item3, item4, item5, item6, item7, item8, item9, item10)
    }
    
    
    public init(selection: Published<S>.Publisher, _ item1: @escaping () -> V1) where V2 == D<S>, V3 == D<S>, V4 == D<S>, V5 == D<S>, V6 == D<S>, V7 == D<S>, V8 == D<S>, V9 == D<S>, V10 == D<S> {
        self.init(selection, item1, nil, nil, nil, nil, nil, nil, nil, nil, nil)
    }
    
    public init(selection: Published<S>.Publisher, _ item1: @escaping () -> V1, _ item2: @escaping () -> V2) where V3 == D<S>, V4 == D<S>, V5 == D<S>, V6 == D<S>, V7 == D<S>, V8 == D<S>, V9 == D<S>, V10 == D<S> {
        self.init(selection, item1, item2, nil, nil, nil, nil, nil, nil, nil, nil)
    }
    
    public init(selection: Published<S>.Publisher, _ item1: @escaping () -> V1, _ item2: @escaping () -> V2, _ item3: @escaping () -> V3) where V4 == D<S>, V5 == D<S>, V6 == D<S>, V7 == D<S>, V8 == D<S>, V9 == D<S>, V10 == D<S> {
        self.init(selection, item1, item2, item3, nil, nil, nil, nil, nil, nil, nil)
    }
    
    public init(selection: Published<S>.Publisher, _ item1: @escaping () -> V1, _ item2: @escaping () -> V2, _ item3: @escaping () -> V3, _ item4: @escaping () -> V4) where V5 == D<S>, V6 == D<S>, V7 == D<S>, V8 == D<S>, V9 == D<S>, V10 == D<S> {
        self.init(selection, item1, item2, item3, item4, nil, nil, nil, nil, nil, nil)
    }
    
    public init(selection: Published<S>.Publisher, _ item1: @escaping () -> V1, _ item2: @escaping () -> V2, _ item3: @escaping () -> V3, _ item4: @escaping () -> V4, _ item5: @escaping () -> V5) where V6 == D<S>, V7 == D<S>, V8 == D<S>, V9 == D<S>, V10 == D<S> {
        self.init(selection, item1, item2, item3, item4, item5, nil, nil, nil, nil, nil)
    }
    
    public init(selection: Published<S>.Publisher, _ item1: @escaping () -> V1, _ item2: @escaping () -> V2, _ item3: @escaping () -> V3, _ item4: @escaping () -> V4, _ item5: @escaping () -> V5, _ item6: @escaping () -> V6) where V7 == D<S>, V8 == D<S>, V9 == D<S>, V10 == D<S> {
        self.init(selection, item1, item2, item3, item4, item5, item6, nil, nil, nil, nil)
    }
    
    public init(selection: Published<S>.Publisher, _ item1: @escaping () -> V1, _ item2: @escaping () -> V2, _ item3: @escaping () -> V3, _ item4: @escaping () -> V4, _ item5: @escaping () -> V5, _ item6: @escaping () -> V6, _ item7: @escaping () -> V7) where V8 == D<S>, V9 == D<S>, V10 == D<S> {
        self.init(selection, item1, item2, item3, item4, item5, item6, item7, nil, nil, nil)
    }
    
    public init(selection: Published<S>.Publisher, _ item1: @escaping () -> V1, _ item2: @escaping () -> V2, _ item3: @escaping () -> V3, _ item4: @escaping () -> V4, _ item5: @escaping () -> V5, _ item6: @escaping () -> V6, _ item7: @escaping () -> V7, _ item8: @escaping () -> V8) where V9 == D<S>, V10 == D<S> {
        self.init(selection, item1, item2, item3, item4, item5, item6, item7, item8, nil, nil)
    }
    
    public init(selection: Published<S>.Publisher, _ item1: @escaping () -> V1, _ item2: @escaping () -> V2, _ item3: @escaping () -> V3, _ item4: @escaping () -> V4, _ item5: @escaping () -> V5, _ item6: @escaping () -> V6, _ item7: @escaping () -> V7, _ item8: @escaping () -> V8, _ item9: @escaping () -> V9) where V10 == D<S> {
        self.init(selection, item1, item2, item3, item4, item5, item6, item7, item8, item9, nil)
    }
    
    public init(selection: Published<S>.Publisher, _ item1: @escaping () -> V1, _ item2: @escaping () -> V2, _ item3: @escaping () -> V3, _ item4: @escaping () -> V4, _ item5: @escaping () -> V5, _ item6: @escaping () -> V6, _ item7: @escaping () -> V7, _ item8: @escaping () -> V8, _ item9: @escaping () -> V9, _ item10: @escaping () -> V10) {
        self.init(selection, item1, item2, item3, item4, item5, item6, item7, item8, item9, item10)
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
        
        private var tabIdentifiers = [S]() // not relevant for Int tab identifiers
        private var oldTabIdentifiers = [S]()
        

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
            
            if let identifier = viewController.view.tag as? S {
                parent.tabbed?(identifier)
                return
            }
            
            let identifier = tabIdentifiers[viewController.view.tag]
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
            
            func makeItem<T: TabBarContainable>(item: T?, index: Int) where T.TabBarItemIdentifier == S {
                
                guard let item = item else {
                    return
                }
                
                let hostingController = UIHostingController(rootView: item)
                
                tabIdentifiers.append(item.tabBarItem.identifier)
                let image = item.tabBarItem.image
                let barItem = UITabBarItem(title: item.tabBarItem.name, image: image, tag: index)
                
                hostingController.tabBarItem = barItem
                hostingController.view.tag = index
                
                viewControllers.append(hostingController)
            }
            
            makeItem(item: parent.item1?(), index: 0)
            makeItem(item: parent.item2?(), index: 1)
            makeItem(item: parent.item3?(), index: 2)
            makeItem(item: parent.item4?(), index: 3)
            makeItem(item: parent.item5?(), index: 4)
            makeItem(item: parent.item6?(), index: 5)
            makeItem(item: parent.item7?(), index: 6)
            makeItem(item: parent.item8?(), index: 7)
            makeItem(item: parent.item9?(), index: 8)
            makeItem(item: parent.item10?(), index: 9)
            
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
