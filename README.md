# Core

[![Carthage](https://img.shields.io/badge/Carthage-compatible-4BC51D.svg?style=flat)](https://github.com/Carthage/Carthage)
[![CocoaPods](https://img.shields.io/cocoapods/v/CoreArchitecture.svg?style=flat)](http://cocoapods.org/pods/CoreArchitecture)
[![CI Status](http://img.shields.io/travis/gokselkoksal/Core.svg?style=flat)](https://travis-ci.org/gokselkoksal/Core)
[![Platform](https://img.shields.io/cocoapods/p/CoreArchitecture.svg?style=flat)](http://cocoadocs.org/docsets/CoreArchitecture)
[![Language](https://img.shields.io/badge/swift-3.1-orange.svg)](http://swift.org)
[![License](https://img.shields.io/badge/license-MIT-lightgrey.svg)](https://github.com/gokselkoksal/Lightning/blob/master/LICENSE.txt)

Core helps you design applications in a way that the app flow is driven by business layer, instead of UI layer. It also promotes unidirectional data flow between components for consistency, high testability and powerful debugging.

## Design

![Class Diagram](https://github.com/gokselkoksal/Core/blob/master/Core-Diagram.png)

- **Core** is simply a box that represents our app.
- **Components** are our features.
- **Actions** are the changes that happen on the system.
- **Subscribers** can be anything. It can be a console app. It can be an iOS app. It can be our test suite.

Core can be seen as a Redux, Flux and MVVM hybrid.

### Main differences between Core and Redux:

- **Redux** is static. It expects you to define a big fat structure that expresses the app state in compile time. This can be challenging if you have reusable controllers that you present here and there a number of times. Especially in cases where your application flow is altered by server responses, you cannot easily define your app state in compile time without hacking the architecture. **Core** is dynamic. You only need to define the state and actions for the component you are working on. Transition between components is handled dynamically.

- In **Redux**, there is no standard way to implement navigation between components. With **Core**, you get native navigation support.

- **Redux** focuses on application state, whereas **Core** focuses on isolated component state. In this regard, I find it easier to work in isolation on one component rather than getting lost in huge application state.

- In **Redux**, since the state is global, it’s easy to forget to do state clean-up when a screen is popped from the navigation stack. In **Core**, since every component stores its own state, when you remove a component from the tree, state gets disposed along with it. This is handled internally by navigation mechanism.

## Implementation

I'll follow the tradition and start with countdown example.

**State:**

```swift
struct CountdownState: State {
  var count: UInt
}
```

**Actions:**

```swift
enum CountdownAction: Action {
  case tick
}
```

**Component:**

```swift
class CountdownComponent: Component<CountdownState> {
  
  func process(action: Action) {
    guard let action = action as? LoginAction else { return }
    switch action {
    case .tick:
      tick()
    }
  }
  
  private func tick() {
    var state = state 
    state.count = state.count - 1
    if state.count == 0 {
      let nextComponent = ResultComponent()
      let navigation = BasicNavigation.push(nextComponent, from: self)
      commit(state, navigation)
    } else {
      commit(state)
    }
  }
}
```
More complex examples:
- Level 2 Sample: [iOS Example](https://github.com/gokselkoksal/Core/tree/master/iOS%20Example)
- Level 3 Sample: [Movies](https://github.com/gokselkoksal/Movies/tree/core)

## Installation

### Using [CocoaPods](https://github.com/CocoaPods/CocoaPods)
Add the following line to your `Podfile`:
```
pod 'CoreArchitecture'
```

### Using [Carthage](https://github.com/Carthage/Carthage)
Add the following line to your `Cartfile`:
```
github "gokselkoksal/Core"
```

### Manually
Drag and drop `Sources` folder to your project. 

*It's highly recommended to use a dependency manager like CocoaPods or Carthage.*

## Alternatives
You can also check out [ReSwift](https://github.com/ReSwift/ReSwift), [Reactor](https://github.com/ReactorSwift/Reactor) or [Dispatch](https://github.com/alexdrone/Dispatch) for pure Redux and Flux implementations for Swift.

## License
Core is available under the [MIT license](https://github.com/gokselkoksal/Core/blob/master/LICENSE.txt).
