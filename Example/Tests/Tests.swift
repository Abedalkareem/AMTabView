import XCTest
import AMTabView

class Tests: XCTestCase {

  var tabsViewController: AMTabsViewController!
  

  override func setUp() {
    super.setUp()
    tabsViewController = AMTabsViewController()
  }

  override func tearDown() {
    tabsViewController = nil
    super.tearDown()
  }

  func testTheDefaultSelectedItemIsZero() {
    tabsViewController.viewControllers = [TabViewController(), TabViewController()]
    XCTAssertEqual(tabsViewController.selectedTabIndex, 0)
  }

  func testNumberOfTabsAfterSettingTheViewControllers() {
    tabsViewController.viewControllers = [TabViewController(), TabViewController()]
    XCTAssertEqual(tabsViewController.viewControllers?.count, 2)
  }

  func testViewControllersNumbersEqualChildrenNumber() {
    tabsViewController.viewControllers = [TabViewController(), TabViewController()]
    XCTAssertEqual(tabsViewController.children, tabsViewController.viewControllers)
  }

}
