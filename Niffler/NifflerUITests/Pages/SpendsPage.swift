import XCTest

class SpendsPage: BasePage {
    
    @discardableResult
    func assertIsSpendsViewAppeared(file: StaticString = #filePath, line: UInt = #line) -> Self {
        XCTContext.runActivity(named: "Жду экран с тратами") { _ in
            waitSpendsScreen(file: file, line: line)
            XCTAssertGreaterThanOrEqual(app.scrollViews.switches.count, 1,
                                        "Не нашел трат в списке",
                                        file: file, line: line)
        }
        
        return self
    }
    
    @discardableResult
    func waitSpendsScreenWithSpends(file: StaticString = #filePath, line: UInt = #line) -> Self {
        XCTContext.runActivity(named: "Жду экран со списком трат") { _ in
            let isFound = app.firstMatch
                .scrollViews.firstMatch
                .switches.firstMatch
                .waitForExistence(timeout: 10)
            
            XCTAssertTrue(isFound,
                          "Не дождались экрана со списком трат",
                          file: file, line: line)
        }
        return self
    }
    
    @discardableResult
    func waitSpendsScreen(file: StaticString = #filePath, line: UInt = #line) -> Self {
        XCTContext.runActivity(named: "Жду появления экрана spending независимо от наличия трат") { _ in
            let isFound = app.staticTexts["allSpendsAmount"].firstMatch.waitForExistence(timeout: 10)
            XCTAssertTrue(isFound, "Не дождались отображения экрана с тратами'", file: file, line: line)
        }
        
        return self
    }
    
    @discardableResult
    func waitMenuList(file: StaticString = #filePath, line: UInt = #line) -> Self {
        XCTContext.runActivity(named: "Ожидаю появления экрана меню с разделами приложения") { _ in
            let isFound = app.otherElements["menuList"]
                .waitForExistence(timeout: 10)
            
            XCTAssertTrue(isFound,
                          "Не дождались экрана меню с разделами приложения",
                          file: file, line: line)
        }
        return self
    }
    
    @discardableResult
    func addSpent() -> Self {
        XCTContext.runActivity(named: "Жму кнопку добавления новой траты") { _ in
            app.buttons["addSpendButton"].tap()
        }
        return self
    }
    
    @discardableResult
    func clickMenuButton() -> Self {
        XCTContext.runActivity(named: "Открываю меню приложения") { _ in
            waitSpendsScreen()
            app.images["menuButton"].tap()
        }
        return self
    }
    
    @discardableResult
    func clickProfileButton() -> Self {
        XCTContext.runActivity(named: "Открываю раздел пользователя") { _ in
            waitMenuList()
            app.buttons["Profile"].tap()
        }
        return self
    }
    
    func hasSpends(timeout: TimeInterval = 10) -> Bool {
        XCTContext.runActivity(named: "Выполняю проверку наличия трат") { _ in
            let screenExists = app.scrollViews.firstMatch
                .switches.firstMatch
                .waitForExistence(timeout: timeout)
            
            guard screenExists else { return false }
            
            let count = app.scrollViews.firstMatch.switches.count
            return count >= 1
        }
    }
    
    @discardableResult
    func openUserProfile() -> Self {
        XCTContext.runActivity(named: "Перехожу в профиль пользователя") { _ in
            clickMenuButton()
            clickProfileButton()
        }
        return self
    }
    
    @discardableResult
    func assertNewSpendIsShown(title: String, file: StaticString = #filePath, line: UInt = #line) -> Self {
        XCTContext.runActivity(named: "Проверяю создание новой траты") { _ in
            let isFound = app.firstMatch
                .scrollViews.firstMatch
                .staticTexts[title].firstMatch
                .waitForExistence(timeout: 1)
            
            XCTAssertTrue(isFound, file: file, line: line)
        }
        return self
    }
    
    @discardableResult
    func assertEmptyListOfSpends(file: StaticString = #filePath, line: UInt = #line) -> Self {
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
        
        return self
    }
}
