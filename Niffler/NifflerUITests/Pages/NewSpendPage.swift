import XCTest

class NewSpendPage: BasePage {
    
    func inputSpent(title: String) {
        inputAmount()
        .selectCategory()
        .inputDescription(title)
//        .swipeToAddSpendsButton()
        .pressAddSpend()
    }
    
    func inputSpentWithNewCategory(amount: String, title: String, categoryTitle: String) {
        XCTContext.runActivity(named: "Создаю новый spending с параметрами amount:\(amount), title:\(title), categoryTitle:\(categoryTitle)") { _ in
            inputAmountWithSum(amount: amount)
            .inputDescription(title)
            .createNewCategory(categoryTitle)
            .pressAddSpend()
        }
    }
    
    func inputAmount() -> Self {
        app.textFields["amountField"].typeText("14")
        return self
    }
    
    func inputAmountWithSum(amount: String) -> Self {
        XCTContext.runActivity(named: "Указываю сумму \(amount) при создании spending") { _ in
            app.textFields["amountField"].typeText(amount)
        }
        return self
    }
    
    func selectCategory() -> Self {
        app.buttons["Select category"].tap()
        app.buttons["Рыбалка"].tap() // TODO: Bug
        return self
    }
    
    func createNewCategory(_ title: String) -> Self {
        XCTContext.runActivity(named: "Создаю новую категорию \(title) при создании spending") { _ in
            app.buttons["Select category"].tap()
            app.textFields["Name"].tap()
            app.textFields["Name"].typeText(title)
            app.buttons["Add"].firstMatch.tap()
        }
        return self
    }
    
    func inputDescription(_ title: String) -> Self {
        XCTContext.runActivity(named: "Указываю в поле Description \(title)") { _ in
            app.textFields["descriptionField"].tap()
            app.textFields["descriptionField"].typeText(title)
        }
        return self
    }
    
//    func swipeToAddSpendsButton() -> Self {
//        let screenCenter = app.coordinate(withNormalizedOffset: CGVector(dx: 0.5, dy: 0.5))
//        let screenTop = app.coordinate(withNormalizedOffset: CGVector(dx: 0.5, dy: 0.15))
//        screenCenter.press(forDuration: 0.01, thenDragTo: screenTop)
//        return self
//    }
    
    func pressAddSpend() {
        app.buttons["Add"].tap()
    }
    
    func createNewSpendAndCategory(amount: String, title: String, categoryTitle: String) {
        inputSpentWithNewCategory(amount: amount, title: title, categoryTitle: categoryTitle)
    }
    
    func makeRandomSpendDescriptionTitle() -> String {
        "RandomDescription_\(Int.random(in: 1000...9999))"
    }
    
    func makeRandomSpendCategoryTitle() -> String {
        "RandomCategory_\(Int.random(in: 1000...9999))"
    }
}
