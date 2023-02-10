//
//  LoginViewModel.swift
//  ChatWithFirestore
//
//  Created by 모상현 on 2023/02/10.
//

import UIKit

protocol AuthenticationProtocol {
    var formIsValid: Bool { get }
}

struct LoginViewModel: AuthenticationProtocol {
    var email: String?
    var pass: String?
    
    var formIsValid: Bool {
        return email?.isEmpty == false && pass?.isEmpty == false
    }
    
    
}
