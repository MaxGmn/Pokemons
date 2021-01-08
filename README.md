Choices motivation

In the application I've used RxSwift framework to implement MVVM pattern. I choose this framework because I have some experience to work with it (dealt with it on my first project). Also it one of more popular frameworks for reactive programming.

Between three package managers I'd like to use SPM because it's a native manager for Swift. Unfortunately, RxSwift doesn't install with it due to critical bug. So I've used Carthage, because project builds faster than with Pods. Also Carthage doesn't modify project unlike CocoaPods does.
