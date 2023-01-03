//
//  AuthStateManager.swift
//  Positive
//
//  Created by 大澤清乃 on 2022/12/11.
//

import Foundation
import FirebaseAuth

final class AuthStateManager {
    static let shared = AuthStateManager()
    let signInUpViewModel = SignInUpViewModel.shared
    var errorMessage = ""
        
    func createUser(emailText: String, passwordText: String, completion:@escaping(String) -> Void) {
            Auth.auth().createUser(withEmail: emailText, password: passwordText) { FIRAuthDataResult, Error in
                if let error = Error{
                    self.handlingError(error: error)
                }else{
                    guard let authResult = FIRAuthDataResult else {
                        print("error: \(Error)")
                        return
                    }
                    completion(authResult.user.uid)
                }
            }
        }
        
        func signInUser(emailText: String, passwordText: String, completion:@escaping() -> Void) {
            Auth.auth().signIn(withEmail: emailText, password: passwordText) { AuthDataResult, Error in
                if let error = Error {
                    self.handlingError(error: error)
                } else {
                    completion()
                }
            }
        }
        
        func handlingError(error: Error?){
            guard let error = error as? NSError else {return}
            if let errorCode = AuthErrorCode.Code(rawValue: error.code){
                switch errorCode{
                case .invalidEmail:
                    self.errorMessage = "メールアドレスが違います"
                case .emailAlreadyInUse:
                    self.errorMessage = "メールアドレスは既に利用されています"
                case .wrongPassword:
                    self.errorMessage = "パスワードが間違っています"
                case .weakPassword:
                    self.errorMessage = "パスワードを強力にしてください"
                case .userNotFound:
                    self.errorMessage = "ユーザが見つかりませんでした"
                default:
                    self.errorMessage = "不明なエラーが発生しました"
                }
            }
            signInUpViewModel.errMessage = self.errorMessage
        }
    }
    
    
