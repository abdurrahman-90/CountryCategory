//
//  DetailTableViewController.swift
//  ConutriesFeatureApp
//
//  Created by Akdag on 23.02.2021.
//

import UIKit

class DetailTableViewController: UITableViewController {

    var selectedCountry : Country?
    
    var languages = [String]()
    var timezones = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        
        guard let country = selectedCountry else {return}
        
        title = country.name
        for i in 0...country.languages.count - 1{
            languages.append(country.languages[i].name)
        }
        for i in 0...country.timezones.count - 1 {
            timezones.append(country.timezones[i])
        }

      
    }
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 12
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell  = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        
        cell.textLabel?.numberOfLines = 0
        cell.selectionStyle = .none
        switch indexPath.row {
        case 0 , 2 , 4 , 6 , 8 , 10:
            cell.textLabel?.font = UIFont.preferredFont(forTextStyle: .headline)
        default:
            cell.textLabel?.font = UIFont.preferredFont(forTextStyle: .body)
        }
        
        if let country = selectedCountry {
            switch indexPath.row {
            case 0:
                cell.textLabel?.text = "Name"
            case 1 :
                cell.textLabel?.text = "\(country.name)"
            case 2:
                cell.textLabel?.text = "Capital"
            case 3 :
                cell.textLabel?.text = "\(country.capital)"
            case 4:
                cell.textLabel?.text = "Region"
            case 5 :
                cell.textLabel?.text = "\(country.region)"
            case 6:
                cell.textLabel?.text = "Population"
            case 7 :
                let format = NumberFormatter()
                format.numberStyle = .decimal
                format.groupingSeparator = "."
                
                cell.textLabel?.text = format.string(for: country.population)
            case 8:
                cell.textLabel?.text = "Timezones"
            case 9 :
                cell.textLabel?.text = "\(timezones.joined(separator: ", "))"
            case 10:
                cell.textLabel?.text = "Languages"
            case 11 :
                cell.textLabel?.text = "\(languages.joined(separator: ", "))"
            default:
                cell.textLabel?.text = "Country Feature Loading"
            }
        }
        return cell
    }



}
