import XCTest

class NewSpendPage: BasePage {
    
    func inputSpent(title: String) {
        inputAmount()
        .selectCategory()
        .inputDescription(title)
//        .swipeToAddSpendsButton()
        .pressAddSpend()
    }
    
    @discardableResult
    func inputSpentWithNewCategory(amount: String, title: String, categoryTitle: String) -> Self {
        XCTContext.runActivity(named: "Ввожу данные для нового spending с параметрами amount:\(amount), title:\(title), categoryTitle:\(categoryTitle)") { _ in
                
                inputAmountWithSum(amount: amount)
                    .inputDescription(title)
                
                if app.staticTexts["+ New category"].exists {
                    app.buttons["Select category"].tap()
                    createNewCategory(categoryTitle)
                } else {
                    app.buttons["Select category"].tap()
                    app.buttons["+ New category"].tap()
                    createNewCategory(categoryTitle)
                }
                
                pressAddSpend()
            }
        
        return self
    }
    
    @discardableResult
    func inputAmount() -> Self {
        app.textFields["amountField"].typeText("14")
        return self
    }
    
    @discardableResult
    func inputAmountWithSum(amount: String) -> Self {
        XCTContext.runActivity(named: "Указываю сумму \(amount) при создании spending") { _ in
            app.textFields["amountField"].typeText(amount)
        }
        return self
    }
    
    @discardableResult
    func selectCategory() -> Self {
        app.buttons["Select category"].tap()
        app.buttons["Рыбалка"].tap() // TODO: Bug
        return self
    }
    
    @discardableResult
    func createNewCategory(_ title: String) -> Self {
        XCTContext.runActivity(named: "Создаю новую категорию \(title) при создании spending") { _ in
            app.textFields["Name"].tap()
            app.textFields["Name"].typeText(title)
            app.buttons["Add"].firstMatch.tap()
        }
        return self
    }
    
    @discardableResult
    func inputDescription(_ title: String) -> Self {
        XCTContext.runActivity(named: "Указываю в поле Description \(title)") { _ in
            app.textFields["descriptionField"].tap()
            app.textFields["descriptionField"].typeText(title)
        }
        return self
    }
    
    @discardableResult
    func checkCategoriesNotExist(_ title: String) -> Self {
        XCTContext.runActivity(named: "Проверяю, что в категориях нет \(title)") { _ in
            let selectCategoryButton = app.buttons["Select category"]
            
            if selectCategoryButton.label == "+ New category" {
                // Список пуст, категории точно нет
                return
            }
            
            if selectCategoryButton.exists {
                selectCategoryButton.tap()
            }
            
            let categoryButton = app.buttons[title]
            let exists = categoryButton.waitForExistence(timeout: 1)
            
            XCTAssertFalse(exists, "Категория '\(title)' найдена, хотя её не должно быть")
        }
        return self
    }
    
    
//    func swipeToAddSpendsButton() -> Self {
//        let screenCenter = app.coordinate(withNormalizedOffset: CGVector(dx: 0.5, dy: 0.5))
//        let screenTop = app.coordinate(withNormalizedOffset: CGVector(dx: 0.5, dy: 0.15))
//        screenCenter.press(forDuration: 0.01, thenDragTo: screenTop)
//        return self
//    }
    
    @discardableResult
    func pressAddSpend() -> Self {
        app.buttons["Add"].tap()
        
        return self
    }
    
    @discardableResult
    func createNewSpendAndCategory(amount: String, title: String, categoryTitle: String) -> Self {
        XCTContext.runActivity(named: "Создаю новую трат с категории со следующими параметрами: \(amount), \(title), \(categoryTitle)") { _ in
            inputSpentWithNewCategory(amount: amount, title: title, categoryTitle: categoryTitle)
        }
        return self
    }
    
    func makeRandomSpendDescriptionTitle() -> String {
        "RandomDescription_\(Int.random(in: 1000...9999))"
    }
    
    func makeRandomSpendCategoryTitle() -> String {
        "RandomCategory_\(Int.random(in: 1000...9999))"
    }
}
