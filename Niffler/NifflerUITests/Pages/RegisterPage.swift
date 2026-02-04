import XCTest

class RegisterPage: BasePage {

    @discardableResult
    func input(username: String, password: String, confirmPassword: String) -> Self {
        XCTContext.runActivity(named: "Регистрирую \(username), \(password), \(confirmPassword)") { _ in
            input(username: username)
            input(password: password)
            input(confirmPassword: confirmPassword)
            pressSignUpButton()
        }
        return self
    }
    
    private func input(username: String) {
        XCTContext.runActivity(named: "Ввожу логин \(username)") { _ in
            let textField = app.textFields["userNameTextField"].firstMatch
            textField.tap()
            textField.typeText(username)
        }
    }
    
    private func input(password: String) {
        XCTContext.runActivity(named: "Ввожу пароль \(password)") { _ in
            let secureField = app.secureTextFields["passwordTextField"].firstMatch
            secureField.tap()
            secureField.typeText(password)
        }
    }

    private func input(confirmPassword: String) {
        XCTContext.runActivity(named: "Ввожу подтверждения пароля \(confirmPassword)") { _ in
            let secureField = app.secureTextFields["confirmPasswordTextField"].firstMatch
            secureField.tap()
            secureField.typeText(confirmPassword)
        }
    }
    
    func pressSignUpButton() {
        XCTContext.runActivity(named: "Жму кнопку создания пользователя") { _ in
            app.buttons["Sign Up"].firstMatch.tap()
        }
    }
    
    func assertIsRegisterErrorShown(file: StaticString = #filePath, line: UInt = #line) {
        XCTContext.runActivity(named: "Жду сообщение с ошибкой") { _ in
            let isFound = app.staticTexts["Не удалось создать пользователя"]
                .waitForExistence(timeout: 5)
            
            XCTAssertTrue(isFound,
                          "Не удалось создать пользователя",
                          file: file, line: line)
        }
    }
    
    func assertIsRegisterSuccessfulMessageShown(file: StaticString = #filePath, line: UInt = #line) {
        XCTContext.runActivity(named: "Жду сообщение с успешной регистрацией пользователя") { _ in
            let isFound = app.alerts["Congratulations!"]
                .waitForExistence(timeout: 5)
            
            XCTAssertTrue(isFound,
                          "Алерт об успешной регистрации не появился",
                          file: file, line: line)
        }
    }
}
