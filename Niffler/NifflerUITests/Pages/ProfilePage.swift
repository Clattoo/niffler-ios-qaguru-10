import XCTest

class ProfilePage: BasePage {
    
    func pressAddCategoryButton() {
        app.buttons["Add Category"].tap()
    }
    
    func pressCloseButton() {
        app.buttons["Close"].tap()
    }
    
    func pressDeleteCategoryButton(categoryName: String) {
        XCTAssertTrue(app.buttons["Delete"].waitForExistence(timeout: 1))
        app.buttons["Delete"].tap()
        
        let deletedCategory = categoryElement(categoryName)
        XCTAssertFalse(deletedCategory.waitForExistence(timeout: 3),
                       "Категория '\(categoryName)' не удалена после нажатия Delete")
    }
    
    @discardableResult
    func swipeCategory(categoryName: String) -> Self {
        XCTContext.runActivity(named: "Удаляю категорию") { _ in
                    
                let list = app.collectionViews.firstMatch // или app.collectionViews.firstMatch
                XCTAssertTrue(list.waitForExistence(timeout: 3), "Список не появился")

                let cell = list.cells.containing(.staticText, identifier: categoryName).firstMatch
                XCTAssertTrue(cell.waitForExistence(timeout: 3), "Ячейка '\(categoryName)' не найдена")

                XCTAssertTrue(cell.isHittable, "Ячейка '\(categoryName)' не видима/не кликабельна")

                cell.swipeLeft()
                }
        return self
    }
    
    func assertCategoryExists(_ categoryName: String, file: StaticString = #filePath, line: UInt = #line) {
        XCTContext.runActivity(named: "Проверяю наличие категории: \(categoryName)") { _ in
            let element = categoryElement(categoryName)
            XCTAssertTrue(element.waitForExistence(timeout: 5),
                          "Категория '\(categoryName)' не найдена в списке",
                          file: file, line: line)
        }
    }
    
    func assertCategoryNotExists(_ categoryName: String, file: StaticString = #filePath, line: UInt = #line) {
        XCTContext.runActivity(named: "Проверяю отсутствие категории: \(categoryName)") { _ in
            let element = categoryElement(categoryName)
            XCTAssertFalse(element.waitForExistence(timeout: 1),
                           "Категория '\(categoryName)' найдена, хотя не должна быть",
                           file: file, line: line)
        }
    }
    
    func deleteCategory(_ categoryName: String) {
        swipeCategory(categoryName: categoryName)
        pressDeleteCategoryButton(categoryName: categoryName)
    }
    
    private func categoryElement(_ categoryName: String) -> XCUIElement {
        return app.staticTexts.matching(identifier: "categoriesSection")
                              .matching(NSPredicate(format: "label == %@", categoryName))
                              .firstMatch
    }
}
