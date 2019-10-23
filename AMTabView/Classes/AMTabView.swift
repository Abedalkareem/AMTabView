//
//  AMTabView.swift
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

public class AMTabView: UIView {

  // MARK: - Properties

  ///
  /// Images to show on the tabs.
  /// This also will decide the number of tabs depending on the number of images.
  ///
  public var tabsImages = [UIImage]() {
    willSet {
      if !tabsImages.isEmpty {
        fatalError("You can't set the tabs images multiple times.")
      }
    }
    didSet {
      addTabsImages()
    }
  }
  ///
  /// Number of tabs.
  ///
  public var numberOfTabs: CGFloat {
    return CGFloat(tabsImages.count)
  }
  ///
  /// Selected tab index. The default value is `0`.
  /// Changing this value will change the current select tab.
  ///
  public var selectedTabIndex: CGFloat = 0 {
    didSet {
      moveToSelectedTab()
    }
  }

  ///
  ///  Use this to customize the tab.
  ///
  ///  `animationDuration`: The default color is 1.
  ///
  ///  `ballColor`: The default color is purple.
  ///
  ///  `tabColor`: The default color is white.
  ///
  ///  `selectedTabTintColor`: The default color is white.
  ///
  ///  `unSelectedTabTintColor`: The default color is black.
  ///
  public static var settings = TabSettings()
  ///
  /// A delegate to get notified when the user click on a tab.
  ///
  public weak var delegate: AMTabViewDelegate?

  // MARK: Private properties

  private var previousTabIndex: CGFloat = -1
  private var itemWidth: CGFloat {
    let width = bounds.width / numberOfTabs
    return width > 100 ? 100 : width
  }
  private var itemHeight: CGFloat {
    let height = bounds.height
    return height > ballSize ? ballSize : height
  }
  private var ballSize: CGFloat {
    return itemWidth / 2
  }
  private var iconSize: CGFloat {
    return ballSize / 1.5
  }

  private let ballAnimationKey = "ball_animation_key"
  private let tabChangingAnimationKey = "ball_animation_key"

  private let itemLayer = CALayer()
  private let shapeLayer = CAShapeLayer()
  private var buttons = [UIButton]()

  // MARK: init

  override init(frame: CGRect) {
    super.init(frame: frame)
    setupView()
  }

  required init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
    setupView()
  }

  private func setupView() {
    shapeLayer.fillColor = AMTabView.settings.tabColor.cgColor
    shapeLayer.lineWidth = 0.5
    shapeLayer.position = CGPoint(x: 10, y: 10)
    layer.addSublayer(shapeLayer)
    backgroundColor = .clear

    itemLayer.backgroundColor = AMTabView.settings.ballColor.cgColor
    layer.addSublayer(itemLayer)
  }

  private func addTabsImages() {
    tabsImages
      .enumerated()
      .map { offset, element -> UIButton in
        let button = UIButton(type: .custom)
        button.adjustsImageWhenHighlighted = false
        button.setImage(element, for: .normal)

        button.contentMode = .scaleAspectFit
        button.addTarget(self, action: #selector(buttonTaped(_:)), for: .touchUpInside)
        buttons.append(button)
        return button
    }
    .forEach(addSubview(_:))
  }

  @objc
  private func buttonTaped(_ sender: UIButton) {
    let index = buttons.firstIndex(of: sender)
    delegate?.tabDidSelectAt(index: index ?? 0)
  }

  // MARK: - View lifecycle

  override public func draw(_ rect: CGRect) {
    moveToSelectedTab()
  }

  override public func layoutSubviews() {
    super.layoutSubviews()

    updateFrames()
  }

  private func updateFrames() {
    shapeLayer.frame = bounds

    itemLayer.frame = CGRect(x: 0, y: 0, width: ballSize, height: ballSize)
    itemLayer.cornerRadius = ballSize / 2

    let sectionWidth = bounds.width / numberOfTabs

    buttons.enumerated().forEach { offset, element in
      let y = offset == Int(selectedTabIndex) ? 0 : (bounds.height / 2) - (iconSize / 2)
      let x =  (CGFloat(offset) * sectionWidth) + (sectionWidth / 2) - (iconSize / 2)
      element.frame = CGRect(x: x, y: y, width: iconSize, height: iconSize)
    }

    self.moveToSelectedTab()
  }

  // MARK: - Moving methods

  private func moveToSelectedTab() {

    animateBallWith(path: ballPath())
    animateTabTo(path: fullRectangle()) {
      self.animateTabTo(path: self.holePathForSelectedIndex())
      self.previousTabIndex = self.selectedTabIndex
    }
    animateTintColorChanging()
  }

  // MARK: - Paths

  private func ballPath() -> CGPath {
    let sectionWidth = bounds.width / numberOfTabs
    let fromX = ((previousTabIndex + 1) * sectionWidth) - (sectionWidth * 0.5)
    let toX = ((selectedTabIndex + 1) * sectionWidth) - (sectionWidth * 0.5)
    var controlPointY = abs(fromX - toX)
    controlPointY = controlPointY != 0 ? controlPointY : 50
    let path = UIBezierPath()
    path.move(to: CGPoint(x: fromX, y: itemHeight * 0.5))
    path.addQuadCurve(to: CGPoint(x: toX, y: itemHeight * 0.25),
                      controlPoint: CGPoint(x: (fromX + toX) / 2, y: -controlPointY))

    return path.cgPath
  }

  private func holePathForSelectedIndex() -> CGPath {
    let sectionWidth = bounds.width / numberOfTabs
    let sectionHeight = bounds.height

    let beginningOfTheTab = (selectedTabIndex * sectionWidth)

    let bezierPath = UIBezierPath()
    bezierPath.move(to: CGPoint(x: 0, y: 0))
    bezierPath.addLine(to: CGPoint(x: beginningOfTheTab - (sectionWidth * 0.3), y: 0))
    bezierPath.addQuadCurve(to: CGPoint(x: beginningOfTheTab + (sectionWidth * 0.2), y: itemHeight * 0.5),
                            controlPoint: CGPoint(x: beginningOfTheTab + (sectionWidth * 0.1), y: 0))
    bezierPath.addCurve(to: CGPoint(x: beginningOfTheTab + (sectionWidth * 0.8), y: itemHeight * 0.5),
                        controlPoint1: CGPoint(x: beginningOfTheTab + (sectionWidth * 0.3), y: itemHeight),
                        controlPoint2: CGPoint(x: beginningOfTheTab + (sectionWidth * 0.7), y: itemHeight))
    bezierPath.addQuadCurve(to: CGPoint(x: beginningOfTheTab + sectionWidth + (sectionWidth * 0.3), y: 0),
                            controlPoint: CGPoint(x: beginningOfTheTab + (sectionWidth * 0.9), y: 0))
    bezierPath.addLine(to: CGPoint(x: bounds.width, y: 0))
    bezierPath.addLine(to: CGPoint(x: bounds.width, y: sectionHeight))
    bezierPath.addLine(to: CGPoint(x: 0, y: sectionHeight))
    bezierPath.addLine(to: CGPoint(x: 0, y: 0))
    bezierPath.close()

    return bezierPath.cgPath
  }

  private func fullRectangle() -> CGPath {
    let height = bounds.height
    let width = bounds.width
    let bezierPath = UIBezierPath(rect: bounds)
    bezierPath.move(to: CGPoint(x: 0, y: 0))
    bezierPath.addLine(to: CGPoint(x: width, y: 0))
    bezierPath.addLine(to: CGPoint(x: width, y: height))
    bezierPath.addLine(to: CGPoint(x: 0, y: height))
    bezierPath.addLine(to: CGPoint(x: 0, y: 0))
    bezierPath.close()
    return bezierPath.cgPath
  }

  // MARK: - Animations

  private func animateTabTo(path: CGPath, completion: (() -> Void)? = nil) {
    CATransaction.begin()
    let animation : CABasicAnimation = CABasicAnimation(keyPath: "path")
    animation.toValue = path
    animation.fillMode = .both
    animation.isRemovedOnCompletion = false
    animation.duration = AMTabView.settings.tabShapeChangeAnimation

    CATransaction.setCompletionBlock {
      self.shapeLayer.path = path
      completion?()
    }

    shapeLayer.add(animation, forKey: tabChangingAnimationKey)
    CATransaction.commit()
  }

  private func animateBallWith(path: CGPath) {
    let animation = CAKeyframeAnimation(keyPath: #keyPath(CALayer.position))
    animation.path = path
    animation.duration = AMTabView.settings.ballAnimation
    animation.fillMode = .both
    animation.isRemovedOnCompletion = false
    animation.timingFunctions = [CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeOut)]
    itemLayer.add(animation, forKey: ballAnimationKey)
  }

  private func animateTintColorChanging() {
    UIView.animate(withDuration: AMTabView.settings.changeTinitColorAnimation) {
      self.buttons
        .enumerated()
        .filter({ $0.offset != Int(self.selectedTabIndex) })
        .forEach({
          $0.element.tintColor = AMTabView.settings.unSelectedTabTintColor
          $0.element.frame.origin.y = (self.bounds.height / 2) - (self.iconSize / 2)
        })

      let selectedTabButton = self.buttons[Int(self.selectedTabIndex)]
      selectedTabButton.tintColor = AMTabView.settings.selectedTabTintColor
      selectedTabButton.frame.origin.y = 0
    }
  }

}

// MARK: - Settings

public class TabSettings {

  // MARK: - Animation Duration

  ///
  /// The change tab animation duration.
  ///
  public var animationDuration: Double = 1
  var tabShapeChangeAnimation: Double {
    return animationDuration * 0.2
  }
  var ballAnimation: Double {
    return animationDuration * 0.4
  }
  var changeTinitColorAnimation: Double {
    return animationDuration * 0.4
  }

  // MARK: - Colors

  public var ballColor = #colorLiteral(red: 0.7529411765, green: 0.4470588235, blue: 0.5960784314, alpha: 1)
  public var tabColor = #colorLiteral(red: 0.9960784314, green: 0.9960784314, blue: 0.9960784314, alpha: 1)
  public var selectedTabTintColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
  public var unSelectedTabTintColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)

}

///
/// A delegate to get notified when the user click on a tab.
/// ''''
public protocol AMTabViewDelegate: AnyObject {
  ///
  /// Will be called when the user click on a tab.
  ///
  func tabDidSelectAt(index: Int)
}
