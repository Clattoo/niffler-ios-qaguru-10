import XCTest

final class RegisterUITests: TestCase {
    
    func test_registerSuccess() throws {
        launchAppWithoutLogin()

        // Act
        loginPage.pressRegisterButton()
        registerPage.input(username: "RandomUser5", password: "Qwerty123", confirmPassword: "Qwerty123")
        
        // Assert
        registerPage.assertIsRegisterSuccessfulMessageShown()
    }
    
    func test_fillLoginPageAndRegisterNewUser() throws {
        launchAppWithoutLogin()

        // Act
        loginPage.input(login: "RandomUser6", password: "Qwerty123")
        loginPage.pressRegisterButton()
        registerPage.pressSignUpButton()
        
        // Assert
        registerPage.assertIsRegisterSuccessfulMessageShown()
    }
    
}
