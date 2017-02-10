//
//  People.swift
//  StarWarsPagination
//
//  Created by Alfian Losari on 2/9/17.
//  Copyright © 2017 Alfian Losari. All rights reserved.
//

import Foundation
import SwiftyJSON


struct People {
    var name: String
    var height: String
    var mass: String
    var hair_color: String
    var eye_color: String
    var birth_year: String
    var gender: String
}

extension People {
    
    init?(json: JSON) {
        guard
            let name = json["name"].string,
            let height = json["height"].string,
            let mass = json["mass"].string,
            let hair_color = json["hair_color"].string,
            let eye_color = json["eye_color"].string,
            let birth_year = json["birth_year"].string,
            let gender = json["gender"].string
            else {
                return nil
        }
        self.name = name
        self.height = height
        self.mass = mass
        self.hair_color = hair_color
        self.eye_color = eye_color
        self.birth_year = birth_year
        self.gender = gender
    }
    
}
