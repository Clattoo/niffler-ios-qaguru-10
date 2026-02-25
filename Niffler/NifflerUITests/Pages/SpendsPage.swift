import XCTest

class SpendsPage: BasePage {
    func assertIsSpendsViewAppeared(file: StaticString = #filePath, line: UInt = #line) {
        XCTContext.runActivity(named: "Жду экран с тратами") { _ in
            waitSpendsScreen(file: file, line: line)
            XCTAssertGreaterThanOrEqual(app.scrollViews.switches.count, 1,
                                        "Не нашел трат в списке",
                                        file: file, line: line)
        }
    }
    
    @discardableResult
    func waitSpendsScreenWithSpends(file: StaticString = #filePath, line: UInt = #line) -> Self {
        let isFound = app.firstMatch
            .scrollViews.firstMatch
            .switches.firstMatch
            .waitForExistence(timeout: 10)
        
        XCTAssertTrue(isFound,
                      "Не дождались экрана со списком трат",
                      file: file, line: line)
        
        return self
    }
    
    @discardableResult
    func waitSpendsScreen(file: StaticString = #filePath, line: UInt = #line) -> Self {
        XCTContext.runActivity(named: "Жду экран со списком трат") { _ in
            let isFound = app.staticTexts["allSpendsAmount"].firstMatch.waitForExistence(timeout: 10)
            XCTAssertTrue(isFound, "Не дождались отображения экрана с тратами'", file: file, line: line)
        }
        
        return self
    }
    
    @discardableResult
    func waitMenuList(file: StaticString = #filePath, line: UInt = #line) -> Self {
        let isFound = app.otherElements["menuList"]
            .waitForExistence(timeout: 10)
        
        XCTAssertTrue(isFound,
                      "Не дождались экрана меню с разделами приложения",
                      file: file, line: line)
        
        return self
    }
    
    func addSpent() {
        app.buttons["addSpendButton"].tap()
    }
    
    func clickMenuButton() {
        waitSpendsScreen()
        app.images["menuButton"].tap()
    }
    
    func clickProfileButton() {
        waitMenuList()
        app.buttons["Profile"].tap()
    }
    
    func hasSpends(timeout: TimeInterval = 10) -> Bool {
        let screenExists = app.scrollViews.firstMatch
            .switches.firstMatch
            .waitForExistence(timeout: timeout)
        
        guard screenExists else { return false }
        
        let count = app.scrollViews.firstMatch.switches.count
        return count >= 1
    }
    
    func assertNewSpendIsShown(title: String, file: StaticString = #filePath, line: UInt = #line) {
        let isFound = app.firstMatch
            .scrollViews.firstMatch
            .staticTexts[title].firstMatch
            .waitForExistence(timeout: 1)
        
        XCTAssertTrue(isFound, file: file, line: line)
    }
    
    func assertEmptyListOfSpends(file: StaticString = #filePath, line: UInt = #line) {
        XCTContext.runActivity(named: "Жду пустого списка трат у нового пользователя") { _ in
            let isFound = app.staticTexts["allSpendsAmount"].firstMatch
            
            guard isFound.waitForExistence(timeout: 10) else {
                XCTFail("Не найден allSpendsAmount", file: file, line: line)
                return
            }

            let cellsCount = app.otherElements.matching(identifier: "spendsList").count
            
            guard cellsCount == 0 else {
                XCTFail("Список трат не пуст", file: file, line: line)
                return
            }
        }
    }
}
