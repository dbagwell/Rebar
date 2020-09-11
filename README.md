# Rebar

## Requirements

- iOS 11.0+
- Xcode 11.0+
- Swift 5.0+

## Installation

### Cocoapods

[CocoaPods](https://cocoapods.org/) is a dependency manager for Cocoa projects. You can install it with the following command:

```
$ gem install cocoapods
```

To integrate Rebar into your Xcode project using CocoaPods, specify it in your Podfile:

```
source 'https://github.com/CocoaPods/Specs.git'
platform :ios, '11.0'
use_frameworks!

target '<Your Target Name>' do
    pod 'Rebar', '~> 1.6.0'
end
```

Then, run the following command:

```
$ pod install
```

## Credits

David Bagwell

## License

Rebar is release under the MIT license. See LICENSE for details.
