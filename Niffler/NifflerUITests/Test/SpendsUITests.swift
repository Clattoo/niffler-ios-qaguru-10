import XCTest

final class SpendsUITests: TestCase {
    
    lazy var descriptionTitle = newSpendPage.makeRandomSpendDescriptionTitle()
    lazy var categoryTitle = newSpendPage.makeRandomSpendCategoryTitle()
    let amount = "25"
    
    func test_whenAddSpent_shouldShowSpendInList() {
        launchAppWithoutLogin()
        
        // Arrange
        loginPage
            .input(login: "stage", password: "12345")
        
        // Act
        spendsPage
            .waitSpendsScreenWithSpends()
            .addSpent()
        
        let title = UUID.randomPart
        newSpendPage
            .inputSpent(title: title)
        
        // Assert
        spendsPage
            .assertNewSpendIsShown(title: title)
    }
    
    func test_checkCategoryExistForUser() {
        launchAppWithoutLogin()
        
        // Arrange
        loginPage.input(login: "stage", password: "12345")
        
        if spendsPage.hasSpends() {
            spendsPage.addSpent()
            newSpendPage.inputSpent(title: descriptionTitle)
        } else {
            spendsPage.addSpent()
            newSpendPage.createNewSpendAndCategory(amount: amount, title: descriptionTitle, categoryTitle: categoryTitle)
        }
        
        // Assert
        spendsPage.assertNewSpendIsShown(title: descriptionTitle)
    }
    
    func test_checkNewCategoryExistsAfterCreatingSpendWithNewCategory() {
        launchAppWithoutLogin()
        
        loginPage.input(login: "RandomUser12", password: "Qwerty123")
        
        spendsPage
            .waitSpendsScreen()
            .addSpent()
        newSpendPage.createNewSpendAndCategory(amount: amount, title: descriptionTitle, categoryTitle: categoryTitle)
        
        spendsPage.clickMenuButton()
        spendsPage.clickProfileButton()
        profilePage.assertCategoryExists(categoryTitle)
    }
    
    func test_checkCategoryNotExistsAfterDeletingFromProfileInNewSpendScreen() {
        launchAppWithoutLogin()
        
        loginPage.input(login: "RandomUser13", password: "Qwerty123")
        
        spendsPage
            .waitSpendsScreen()
            .addSpent()
        newSpendPage.createNewSpendAndCategory(amount: amount, title: descriptionTitle, categoryTitle: categoryTitle)
        
        spendsPage.clickMenuButton()
        spendsPage.clickProfileButton()
        profilePage.assertCategoryExists(categoryTitle)
        profilePage.deleteCategory(categoryTitle)
        
        profilePage.pressCloseButton()
        spendsPage.addSpent()
        newSpendPage.checkCategoriesNotExist(categoryTitle)
    }
}

extension UUID {
    static var randomPart: String {
        UUID().uuidString.components(separatedBy: "-").first!
    }
}
