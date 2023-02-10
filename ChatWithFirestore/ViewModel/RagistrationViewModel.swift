//
//  RagistrationViewModel.swift
//  ChatWithFirestore
//
//  Created by 모상현 on 2023/02/10.
//

import UIKit
struct RegistrationViewModel: AuthenticationProtocol {
    var email: String?
    var password: String?
    var fullname: String?
    var nickname: String?
    
    var formIsValid: Bool {
        return email?.isEmpty == false && password?.isEmpty == false && fullname?.isEmpty == false && nickname?.isEmpty == false
    }
}
