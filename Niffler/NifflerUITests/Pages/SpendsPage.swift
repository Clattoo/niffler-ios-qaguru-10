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
    func waitSpendsScreen(file: StaticString = #filePath, line: UInt = #line) -> Self {
        let isFound = app.firstMatch
            .scrollViews.firstMatch
            .switches.firstMatch
            .waitForExistence(timeout: 10)
        
        XCTAssertTrue(isFound,
                      "Не дождались экрана со списком трат",
                      file: file, line: line)
        
        return self
    }
    
    func addSpent() {
        app.buttons["addSpendButton"].tap()
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
