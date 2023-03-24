//
//  Constants.swift
//  ChatWithFirestore
//
//  Created by 모상현 on 2023/02/16.
//

import Foundation
import Firebase

let STORAGE_REF = Storage.storage().reference()
let STORAGE_PROFILE_IMAGES = STORAGE_REF.child("profile_images")
let FS = Firestore.firestore()
let FS_USER = FS.collection("users")
let FS_MESSAGE = FS.collection("message")
