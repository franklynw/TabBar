# TabBar

A SwiftUI TabView substitute (just for the DefaultTabViewStyle, ie, a tabBar at the foot of the screen), with a few customisation options and added extras.


## Installation

### Swift Package Manager

In Xcode:
* File ⭢ Swift Packages ⭢ Add Package Dependency...
* Use the URL https://github.com/franklynw/TabBar.git


## Example

> **NB:** All examples require `import TabBar` at the top of the source file


```swift
var body: some View {
    
    TabBar(selection: viewModel.$currentTab,
           { mapView },
           { placesView }
    )
    .tabChanged {
        viewModel.currentTab = $0
    }
    .barBackground(viewModel.$tabBarBackground)
    .accentColor(Color(.label))
    .ignoresSafeArea(edges: .all)
    
}
```


## Initialisation

You can initialise either with a published selection or without - if you use the selection, you can programmatically change the displayed tab. It currently supports up to 5 tab items, though it would be very easy to extend it to take more if you really needed them.

The views used for each tab must conform to the TabBarContainable protocol, detailed below.


## Customisation

### Respond to tab changes programmatically

```swift
TabBar(selection: viewModel.$currentTab,
       { mapView },
       { placesView }
)
.tabChanged {
    viewModel.currentTab = $0
}
```

In this example, the viewModel is informed of the tab which the user tapped.

### Set the tabBar background

You can either set a static background, or use a published value so it can update dynamically.

* A static background -

```swift
TabBar(selection: viewModel.$currentTab,
       { mapView },
       { placesView }
)
.barBackground(.color(.black))
```

* A published background -

```swift
TabBar(selection: viewModel.$currentTab,
       { mapView },
       { placesView }
)
.barBackground(viewModel.$tabBarBackground)
```

### Disable the animation on tab changing

The default behaviour of TabBar is to fade between changes, which is noticeable if you have different backgrounds depending on the selected tab. You can disable this & make the changes instant -

```swift
TabBar(selection: viewModel.$currentTab,
       { mapView },
       { placesView }
)
.disableBarAnimation
```


## TabBarContainable

This is the protocol which views used in the TabBar must implement. The requirement is simple - they must provide a TabBarItem value -

```swift
struct MyView: TabBarContainable {
    
    let tabBarItem = TabBarItem(name: "Sleep", imageSystemName: "zzz")
```

Used in its basic form, the tabBarItem is Int indexed, which means that to change tabs, you specify an index. An Int will be returned in the .tabChanged handler as well. You can also use String identifiers, which means that to change tab , you'd have to use that value - likewise, it will be returned in .tabChanged -

```swift
let tabBarItem = TabBarItem(name: "Sleep", imageSystemName: "zzz", identifier: "sleepTab")
```

Currently, only Ints & Strings are supported as identifiers, but it would be easy enough to extend to other types if required.


## Licence

`TabBar` is available under the MIT licence.
