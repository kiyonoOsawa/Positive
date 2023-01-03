//
//  SignInUpViewModel.swift
//  Positive
//
//  Created by 大澤清乃 on 2023/01/03.
//

import Foundation
import Combine

class SignInUpViewModel {
    static let shared = SignInUpViewModel()
    @Published var errMessage = ""
}
