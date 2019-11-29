//
//  AMTabsViewController.swift
//  AMTabView (https://github.com/Abedalkareem/AMTabView)
//
//  Created by abedalkareem omreyh on 16/10/2019.
//  Copyright © 2019 abedalkareem. All rights reserved.
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in
//  all copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
//  THE SOFTWARE.

import UIKit

open class AMTabsViewController: UIViewController {

  // MARK: - Properties

  ///
  /// Selected tab index. The default value is `nil`.
  /// Changing this value will change the current select tab.
  ///
  public var selectedTabIndex: Int {
    get {
      return tabBar.selectedTabIndex
    }
    set {
      tabBar?.selectedTabIndex = newValue
      moveToViewContollerAt(index: newValue)
    }
  }

  ///
  /// The tabs view controller, each view controller must implement `TabItem`.
  ///
  public var viewControllers: [UIViewController]? = nil {
    willSet {
      if viewControllers != nil {
        fatalError("You can't set the tabs viewControllers multiple times.")
      }
    }
    didSet {
      viewControllers?.forEach(addChild(_:))
      initViews()
      setTabsIcon()
      selectedTabIndex = 0
    }
  }

  // MARK: Private properties

  private var lastSelectedViewIndex: Int?

  private var tabBar: AMTabView!
  private var containerView: UIView!
  private var bottomView: UIView!

  // MARK: - ViewController lifecycle

  override open func viewDidLoad() {
    super.viewDidLoad()

  }

  private func initViews() {
    containerView = UIView()
    view.addSubview(containerView)

    tabBar = AMTabView()
    tabBar.delegate = self
    view.addSubview(tabBar)

    bottomView = UIView()
    bottomView.backgroundColor = AMTabView.settings.tabColor
    view.addSubview(bottomView)

    makeConstraints()
  }

  private func makeConstraints() {

    containerView.translatesAutoresizingMaskIntoConstraints = false
    tabBar.translatesAutoresizingMaskIntoConstraints = false
    bottomView.translatesAutoresizingMaskIntoConstraints = false

    var constraints = [NSLayoutConstraint]()

    // Container view constraints
    if #available(iOS 11.0, *) {
      constraints.append(containerView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor))
    } else {
      constraints.append(containerView.bottomAnchor.constraint(equalTo: view.bottomAnchor))
    }
    constraints.append(containerView.trailingAnchor.constraint(equalTo: view.trailingAnchor))
    constraints.append(containerView.leadingAnchor.constraint(equalTo: view.leadingAnchor))
    constraints.append(containerView.topAnchor.constraint(equalTo: view.topAnchor))

    // Tab bar constraints
    if #available(iOS 11.0, *) {
      constraints.append(tabBar.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor))
    } else {
      constraints.append(tabBar.bottomAnchor.constraint(equalTo: view.bottomAnchor))
    }

    constraints.append(tabBar.trailingAnchor.constraint(equalTo: view.trailingAnchor))
    constraints.append(tabBar.leadingAnchor.constraint(equalTo: view.leadingAnchor))
    constraints.append(tabBar.heightAnchor.constraint(equalToConstant: 60))

    // Bottom view constraints

    constraints.append(bottomView.trailingAnchor.constraint(equalTo: view.trailingAnchor))
    constraints.append(bottomView.leadingAnchor.constraint(equalTo: view.leadingAnchor))
    constraints.append(bottomView.bottomAnchor.constraint(equalTo: view.bottomAnchor))
    constraints.append(bottomView.topAnchor.constraint(equalTo: tabBar.bottomAnchor))

    constraints.forEach({ $0.isActive = true })

  }

  private func setTabsIcon() {
    tabBar.tabsImages = children.compactMap({ viewController -> UIImage? in
      var tabItem: TabItem!
      if let controller = (viewController as? UINavigationController)?.topViewController as? TabItem {
        tabItem = controller
      } else if let controller = viewController as? TabItem {
        tabItem = controller
      } else {
        fatalError("View controller must implement `TabItem`")
      }
      return tabItem.tabImage
    })
  }

  private func moveToViewContollerAt(index: Int) {

    guard index != lastSelectedViewIndex else {
      return
    }

    let currentView = containerView.subviews.first
    currentView?.removeFromSuperview()

    let contoller = children[index]
    let newView = contoller.view
    if newView?.superview == nil {
      containerView.addSubview(newView!)
      contoller.didMove(toParent: self)
      newView?.frame = containerView.bounds
    }

    lastSelectedViewIndex = index
  }

}

///
/// To use any view controller as a tab you need to implement protocol.
///
public protocol TabItem {
  ///
  /// Image or title to show on the tab.
  ///
  var tabImage: UIImage? { get }
}

extension AMTabsViewController: AMTabViewDelegate {

  ///
  /// Override the method to get the tab selected actions.
  ///
  public func tabDidSelectAt(index: Int) {
    selectedTabIndex = index
  }

}
