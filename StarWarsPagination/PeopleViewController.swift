//
//  PeopleViewController.swift
//  StarWarsPagination
//
//  Created by Alfian Losari on 2/9/17.
//  Copyright © 2017 Alfian Losari. All rights reserved.
//

import UIKit

class PeopleViewController: UITableViewController {
    
    var people: [People] = []
    var totalCount = 0
    var nextURL: URL?

    override func viewDidLoad() {
        super.viewDidLoad()
        PeopleStore.getPeople(nextURL: nextURL) { [weak self ](results, error) in
            if let error = error {
                print(error.localizedDescription)
                return
            }
        
            DispatchQueue.main.async {
                self?.totalCount = results!.count
                if let nextURL = results?.next, let url = URL(string: nextURL) {
                    self?.nextURL = url
                }
                
                self?.people = results!.people
                self?.tableView.reloadData()
            }
            
            
        }
        self.tableView.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")
    }
    
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if totalCount == self.people.count {
            return self.people.count
        }
        return self.people.count + 1
    }
    
    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if indexPath.row == self.people.count {
            if let nextURL = self.nextURL {
                PeopleStore.getPeople(nextURL: nextURL) { [weak self ](results, error) in
                    if let error = error {
                        print(error.localizedDescription)
                        return
                    }
                    
                    DispatchQueue.main.async {
                        self?.totalCount = results!.count
                        if let nextURL = results?.next, let url = URL(string: nextURL) {
                            self?.nextURL = url
                        }
                        
                        self?.people.append(contentsOf: results!.people)
                        self?.tableView.reloadData()
                    }
                    
                    
                }
            }
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == self.people.count {
            let cell = self.tableView.dequeueReusableCell(withIdentifier: "LoadingCell", for: indexPath)
            let activityIndicator = cell.viewWithTag(1000) as! UIActivityIndicatorView
            activityIndicator.startAnimating()
            return cell
            
        } else {
            let cell = self.tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)

            cell.textLabel?.text = self.people[indexPath.row].name

            return cell
        }
    }
    



}
