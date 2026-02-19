import XCTest

class ProfilePage: BasePage {

    @discardableResult
    func pressAddCategoryButton() -> Self {
        XCTContext.runActivity(named: "Жму кнопку добавления новой категории в разделе профиля") { _ in
            app.buttons["Add Category"].tap()
        }
        return self
    }
    
    @discardableResult
    func pressCloseButton() -> Self {
        XCTContext.runActivity(named: "Жму кнопку закрытия раздела с профилем пользователя") { _ in
            app.buttons["Close"].tap()
            
        }
        return self
    }
    
    @discardableResult
    func pressDeleteCategoryButton(categoryName: String) -> Self {
        XCTContext.runActivity(named: "Жму кнопку удаления категории в профиле пользователя") { _ in
            XCTAssertTrue(app.buttons["Delete"].waitForExistence(timeout: 1))
            app.buttons["Delete"].tap()
            sleep(1)
            let deletedCategory = app.collectionViews.firstMatch
                .staticTexts[categoryName].firstMatch
            
            XCTAssertFalse(deletedCategory.waitForExistence(timeout: 1), file: #file, line: #line)
        }
        
        return self
    }
    
    @discardableResult
    func swipeCategory(categoryName: String) -> Self {
        XCTContext.runActivity(named: "Свайпаю категорию: \(categoryName)") { _ in
                    
                let list = app.collectionViews.firstMatch // или app.collectionViews.firstMatch
                XCTAssertTrue(list.waitForExistence(timeout: 3), "Список не появился")

                let cell = list.cells.containing(.staticText, identifier: categoryName).firstMatch
                XCTAssertTrue(cell.waitForExistence(timeout: 3), "Ячейка '\(categoryName)' не найдена")

                XCTAssertTrue(cell.isHittable, "Ячейка '\(categoryName)' не видима/не кликабельна")

                cell.swipeLeft()
                }
        
        return self
    }
    
    @discardableResult
    func assertCategoryExists(_ categoryName: String, file: StaticString = #filePath, line: UInt = #line) -> Self {
            XCTContext.runActivity(named: "Проверяю наличие категории: \(categoryName)") { _ in
                let predicate = NSPredicate(format: "label == %@", categoryName)
                let categoryElement = app.staticTexts.matching(predicate).firstMatch
                
                let exists = categoryElement.waitForExistence(timeout: 5)
                XCTAssertTrue(exists, "Категория '\(categoryName)' не найдена в списке", file: file, line: line)
            }
        
        return self
    }
     
    @discardableResult
    func assertCategoryNotExists(_ categoryName: String, file: StaticString = #filePath, line: UInt = #line) -> Self {
            XCTContext.runActivity(named: "Проверяю отсутствие категории: \(categoryName)") { _ in
                let predicate = NSPredicate(format: "label == %@", categoryName)
                let categoryElement = app.staticTexts.matching(predicate).firstMatch
                
                let exists = categoryElement.waitForExistence(timeout: 1)
                XCTAssertFalse(exists, "Категория '\(categoryName)' найдена, хотя не должна быть", file: file, line: line)
            }
        
        return self
    }
    
    @discardableResult
    func deleteCategory(_ categoryName: String) -> Self {
        XCTContext.runActivity(named: "Проверяю отсутствие категории: \(categoryName)") { _ in
            swipeCategory(categoryName: categoryName)
            pressDeleteCategoryButton(categoryName: categoryName)
        }
        
        return self
    }
}
