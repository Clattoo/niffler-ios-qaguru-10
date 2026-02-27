import XCTest

final class RegisterUITests: TestCase {
    
    lazy var username = registerPage.makeRandomUsername()
    lazy var title = newSpendPage.makeRandomSpendDescriptionTitle()
    lazy var categoryTitle = newSpendPage.makeRandomSpendCategoryTitle()
    
    let password = "Qwerty123"
    let incorrectPassword = "Qwerty1234"
    let amount = "25"
    
    override func setUp() {
           super.setUp()
           continueAfterFailure = false
       }
    
    func test_registerSuccess() throws {
        launchAppWithoutLogin()

        // Act
        loginPage.pressRegisterButton()
        registerPage.input(username: username, password: password, confirmPassword: password)
        
        // Assert
        registerPage.assertIsRegisterSuccessfulMessageShown()
    }
    
    func test_registerFailWithIncorrectCredentials() throws {
        launchAppWithoutLogin()

        // Act
        loginPage.pressRegisterButton()
        registerPage.input(username: username, password: password, confirmPassword: incorrectPassword)
        
        // Assert
        registerPage.assertIsRegisterErrorShown()
    }
    
    func test_fillLoginPageAndRegisterNewUser() throws {
        launchAppWithoutLogin()

        // Act
        loginPage
            .input(login: username, password: password)
            .pressRegisterButton()
        
        registerPage.pressSignUpButton()
        
        // Assert
        registerPage.assertIsRegisterSuccessfulMessageShown()
    }
    
    func test_registerNewUserAndCheckThatSpendsIsEmpty() throws {
        launchAppWithoutLogin()
        
        // Act
        registerUserAndLogin(username: username, password: password)
        
        // Assert
        spendsPage.assertEmptyListOfSpends()
    }
    
    func test_registerNewUserAndCreateNewCategory() throws {
        launchAppWithoutLogin()
        
        // Act
        registerUserAndLogin(username: username, password: password)
        
        // Assert
        spendsPage
            .assertEmptyListOfSpends()
            .addSpent()
        
        newSpendPage.createNewSpendAndCategory(amount: amount, title: title, categoryTitle: categoryTitle)
        
        spendsPage.assertNewSpendIsShown(title: title)
    }
    
    private func registerUserAndLogin(username: String, password: String) {
        loginPage.pressRegisterButton()
        registerPage
            .input(username: username, password: password, confirmPassword: password)
            .assertIsRegisterSuccessfulMessageShown()
            .pressLoginButtonAfterRegisterUser()
        
        loginPage.pressLoginButton()
    }
}
