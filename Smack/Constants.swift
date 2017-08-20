//
//  Constants.swift
//  Smack
//
//  Created by Melisa Kısacık on 19.08.2017.
//  Copyright © 2017 MurathanBagdat. All rights reserved.
//

import Foundation

typealias CompletionHandler = (_ Success : Bool) -> ()

//typealias Murathan = String                     //  var olan bir type'ı adlandırma!
//let bagdat : Murathan = "mb"

//Segues
let TO_LOGINVC_SEGUE = "toLoginVC"
let TO_CREATE_ACCOUNT_SEGUE = "toCreateAccountSegue"
let UNWIND_TO_CHANNEL = "unwindToChannel"
let TO_AVATAR_PICKER = "toAvatarPicker"


//User Defaults

let TOKEN_Key = "token"
let LOGED_IN_KEY = "loggedIn"
let USER_EMAIL = "userEmail"


//Url Constants

let BASE_URL = "https://chattychatchattychat.herokuapp.com/v1/"
let URL_REGISTER = "\(BASE_URL)account/register"
let URL_LOGIN = "\(BASE_URL)account/login"
let URL_ADD_USER = "\(BASE_URL)user/add"



// Header

let HEADER = [
    "Content-Type" : "application/json; charset=utf-8"
]
let HEADER_ADD_USER = [
    "Authorization" : "Bearer \(AuthServices.instance.authToken)",
    "Content-Type" : "application/json; charset=utf-8"
]


//Cells

let AVATAR_PICKER_CELL = "avatarCollectionCell"








