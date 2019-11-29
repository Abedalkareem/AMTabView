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
    setViewControllers()
    XCTAssertEqual(tabsViewController.selectedTabIndex, 0)
  }

  func testNumberOfTabsAfterSettingTheViewControllers() {
    setViewControllers()
    XCTAssertEqual(tabsViewController.viewControllers?.count, 2)
  }

  func testViewControllersNumbersEqualChildrenNumber() {
    setViewControllers()
    XCTAssertEqual(tabsViewController.children, tabsViewController.viewControllers)
  }

  func testChangingTheCurrentTab() {
    setViewControllers()
    tabsViewController.selectedTabIndex = 1
    XCTAssertEqual(tabsViewController.selectedTabIndex, 1)
  }

  func testHavingViewControllersWithNavigation() {
    setViewControllers(withNavigation: true)
    XCTAssertEqual(tabsViewController.viewControllers?.count, 2)
  }

  func testChangingTheCurrentTabTwiceWithTheSameIndexShouldNotChangeTheTab() {
    setViewControllers()
    tabsViewController.selectedTabIndex = 1
    tabsViewController.selectedTabIndex = 1
    XCTAssertEqual(tabsViewController.selectedTabIndex, 1)
  }

  private func setViewControllers(withNavigation: Bool = false) {
    if withNavigation {
      tabsViewController.viewControllers = [UINavigationController(rootViewController: TabViewController()),
                                            UINavigationController(rootViewController: TabViewController())]
    } else {
      tabsViewController.viewControllers = [TabViewController(), TabViewController()]
    }
  }

}
