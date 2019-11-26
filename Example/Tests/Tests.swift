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

  func testSetNonTabItemViewControllersToViewControllers() {

  }

}
