//
//  ServerStore.swift
//  StarWarsPagination
//
//  Created by Alfian Losari on 2/9/17.
//  Copyright © 2017 Alfian Losari. All rights reserved.
//

import Foundation
import SwiftyJSON

typealias PeopleResponse = (_ peopleResults:(people: [People], count: Int, next: String?, previous: String?)?, _ error: Error?) -> ()

struct PeopleStore {
    
    static func getPeople(nextURL: URL?, completionHandler: @escaping PeopleResponse) {
        var url = URL(string: "http://swapi.co/api/people/")!

        if let nextURL = nextURL {
            url = nextURL
        }
        
        let request = URLRequest(url: url)
        let session = URLSession(configuration: URLSessionConfiguration.default)
        
        let task = session.dataTask(with: request) { (data, response, error) in
            if let error = error {
                completionHandler(nil, error)
                return
            }
            let json = JSON(data: data!)
            guard
                let count = json["count"].int,
                let results = json["results"].array
                else {
                    let error = NSError(domain: "people", code: 0, userInfo: [NSLocalizedDescriptionKey: "Invalid data"])
                    completionHandler(nil, error)
                    return
            }
            var people = [People]()
            let next = json["next"].string
            let previous = json["previous"].string
            for result in results {
                guard let person = People(json: result) else { continue }
                people.append(person)
            }
            
            completionHandler((people, count, next, previous), nil)
            
        }
        
        task.resume()
        session.finishTasksAndInvalidate()
        
    }
    
    
}
