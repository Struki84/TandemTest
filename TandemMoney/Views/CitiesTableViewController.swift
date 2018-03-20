//
//  CitiesTableViewController.swift
//  TandemMoney
//
//  Created by Šimun Strukan on 20/03/2018.
//  Copyright © 2018 Sintezis. All rights reserved.
//

import UIKit

class CitiesTableViewController: UITableViewController {

    var cities: [City]?
    var delegate: CitiesDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        if let url = Bundle.main.url(forResource: "city.list", withExtension: "json") {
            do {
                let data = try Data(contentsOf: url)
                let decoder = JSONDecoder()
                cities = try decoder.decode([City].self, from: data)
                self.tableView.reloadData()
            }
            catch let error {
                print("Cities list decoding error: \(error)")
            }
        }
    }

    override func numberOfSections(in tableView: UITableView) -> Int {
        if let _ = cities {
            return 1
        }
        return 0
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let cityList = cities {
            return cityList.count
        }
        return 0
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath)
        let index = indexPath.row
        if let city = cities?[index] {
            cell.textLabel?.text = city.name
            cell.tag = city.id!
        }
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath)
        delegate?.selected(city: cell.tag)
    }
    
    

}
