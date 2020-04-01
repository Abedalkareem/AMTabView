//
//  ViewController.swift
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
import AMTabView

class ViewController: AMTabsViewController {
  
  override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
      super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
      super.cvDelegate = self
      setTabsControllers()
  }
  
  required init?(coder aDecoder: NSCoder) {
      super.init(coder: aDecoder)
      super.cvDelegate = self
      setTabsControllers()
  }

  // MARK: - ViewController lifecycle
  
  override func viewDidLoad() {
    super.viewDidLoad()
  }

  private func setTabsControllers() {
    let storyboard = UIStoryboard(name: "Main", bundle: nil)
    let graveViewController = storyboard.instantiateViewController(withIdentifier: "GraveViewController")
    let bumpkinViewController = storyboard.instantiateViewController(withIdentifier: "BumpkinViewController")
    let fireworkViewController = storyboard.instantiateViewController(withIdentifier: "FireworkViewController")
    let ghostViewController = storyboard.instantiateViewController(withIdentifier: "GhostViewController")

    viewControllers = [
      graveViewController,
      bumpkinViewController,
      fireworkViewController,
      ghostViewController
    ]
  }
  
  // Optional param, triggered always when user tabbed on tab bar element
  override func tabDidSelectAt(index: Int) {
      super.tabDidSelectAt(index: index)
  }
  
}

// MARK: - TabBarControllerDelegate

extension ViewController: ControllerDelegate {

  func tabBarController(didSelect viewController: UIViewController) {
    print(viewController)
    // If you were use separate root CV
//      AppRouter.router.tabBarDidChangedTo(controller: viewController)
  }

}

