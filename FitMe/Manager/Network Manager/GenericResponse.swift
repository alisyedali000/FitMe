//
//  GenericResponse.swift
//  ProBau
//
//  Created by Ali Syed on 21/09/2023.
//

import Foundation

struct GenericResponse: Codable {

    var message: String
    var status: Bool
    var total_pages:Int?
}

struct GenericResponseModel<T: Codable>: Codable {

    var message: String?
    var status: Bool?
    var data: T?
    var total_pages : Int?
    var user_token:String?

}


