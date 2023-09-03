//
//  AuthStateManager.swift
//  Positive
//
//  Created by 大澤清乃 on 2022/12/11.
//

import UIKit
import Foundation
import FirebaseAuth

final class AuthStateManager {
    static let shared = AuthStateManager()
    let signInUpViewModel = SignInUpViewModel.shared
    let alertHelper = AlertDialog.shared
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
    
    func promptLogin(viewController: UIViewController) {
        if Auth.auth().currentUser == nil {
            alertHelper.showSaveAlert(title: "ログインしてください", message: "この先の機能はログインしないと使えません", viewController: viewController){
                let toSignUp: UIStoryboard = UIStoryboard(name: "MainStory", bundle: nil)
                let nextVC  = toSignUp.instantiateViewController(withIdentifier: "firstAccView")
                nextVC.modalPresentationStyle = .fullScreen
                viewController.present(nextVC, animated: true, completion: nil)
            }
        }
    }
    
    func logoutTransition(viewController: UIViewController){
        alertHelper.showSaveAlert(title: "ログアウトしますか？", message: "ログアウトした際ログイン画面に戻ります", viewController: viewController) {
            let firebaseAuth = Auth.auth()
            do{
                try firebaseAuth.signOut()
                let toSignUp: UIStoryboard = UIStoryboard(name: "MainStory", bundle: nil)
                let nextVC = toSignUp.instantiateViewController(withIdentifier: "firstAccView")
                nextVC.modalPresentationStyle = .fullScreen
                viewController.present(nextVC, animated: true, completion: nil)
            } catch let signOutError as NSError{
                print("Error signing out: %@", signOutError)
            }
        }
    }
    
    func deleteUser(viewController: UIViewController, password: String, completion: @escaping ()-> Void){
        alertHelper.showSaveAlert(title: "アカウント削除します", message: "よろしいですか？", viewController: viewController){
            do{
                guard let user = Auth.auth().currentUser else {return}
                guard let userEmail = user.email else {return}
                let credential = EmailAuthProvider.credential(withEmail: userEmail, password: password)
                try Auth.auth().signOut()
                user.reauthenticate(with: credential) {AuthDataResult, Error in
                    guard let result = AuthDataResult else {return}
                    result.user.delete { error in
                        if let error = error {
                            print(error.localizedDescription)
                        } else {
                            print("delete succeed")
                            completion()
                            let toSignUp: UIStoryboard = UIStoryboard(name: "MainStory", bundle: nil)
                            let nextVC = toSignUp.instantiateViewController(withIdentifier: "firstAccView")
                            nextVC.modalPresentationStyle = .fullScreen
                            viewController.present(nextVC, animated: true, completion: nil)
                        }
                    }
                }
            } catch let signOutError as NSError {
                print("Error signing out: %@", signOutError)
            }
        }
    }
    }
    
    
