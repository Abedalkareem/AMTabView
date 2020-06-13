<p align="center">
 <img src="https://raw.githubusercontent.com/Abedalkareem/AMTabView/master/tabviewlogo.png"  >
</p>

[![CI Status](https://img.shields.io/travis/Abedalkareem/AMTabView.svg?style=flat)](https://travis-ci.org/Abedalkareem/AMTabView)
[![Version](https://img.shields.io/cocoapods/v/AMTabView.svg?style=flat)](https://cocoapods.org/pods/AMTabView)
[![License](https://img.shields.io/cocoapods/l/AMTabView.svg?style=flat)](https://cocoapods.org/pods/AMTabView)
[![Platform](https://img.shields.io/cocoapods/p/AMTabView.svg?style=flat)](https://cocoapods.org/pods/AMTabView)

## Screenshot
<p align="center">
 <img src="https://raw.githubusercontent.com/Abedalkareem/AMTabView/master/screenshot.gif"  >
</p>

## Android

It's also available on android you can find it [here](https://github.com/Abedalkareem/AMTabView-Android).

## Example

To run the example project, clone the repo, and run `pod install` from the Example directory first.

## Installation

AMTabView is available through [CocoaPods](https://cocoapods.org). To install
it, simply add the following line to your Podfile:

```ruby
pod 'AMTabView'
```

## Usage

1- Inherit the `AMTabsViewController` class.
```
class ViewController: AMTabsViewController {

   override func viewDidLoad() {
    super.viewDidLoad()

  }
```

2-In the `viewDidLoad` set the tabs view controllers.

```
   override func viewDidLoad() {
    super.viewDidLoad()

    setTabsControllers()

  }

  private func setTabsControllers() {
    let storyboard = UIStoryboard(name: "Main", bundle: nil)
    let graveViewController = storyboard.instantiateViewController(withIdentifier: "GraveViewController")
    let bumpkinViewController = storyboard.instantiateViewController(withIdentifier: "BumpkinViewController")

    viewControllers = [
      graveViewController,
      bumpkinViewController
    ]
  }
}
```
3- Those view controllers need to implement `TabItem` protocol and need to provide the image for the tab.

```
class GraveViewController: UIViewController, TabItem {

  var tabImage: UIImage? {
    return UIImage(named: "tab1")
  }

  override func viewDidLoad() {
    super.viewDidLoad()

  }

}
```

## Customization

```
 // Customize the colors
 AMTabView.settings.ballColor = .red
 AMTabView.settings.tabColor = .white
 AMTabView.settings.selectedTabTintColor = .white
 AMTabView.settings.unSelectedTabTintColor = .black

 // Change the animation duration
 AMTabView.settings.animationDuration = 1
```

## Author

Abedalkareem, abedalkareem.omreyh@yahoo.com

## License

AMTabView is available under the MIT license. See the LICENSE file for more info.
