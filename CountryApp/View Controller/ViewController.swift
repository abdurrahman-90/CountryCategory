//
//  ViewController.swift
//  CountryApp
//
//  Created by Akdag on 23.02.2021.
//

import UIKit

class ViewController: UIViewController {
    @IBOutlet var searchFooterBottomConstraint: NSLayoutConstraint!
    @IBOutlet weak var searchFooter: SearchFooter!
    @IBOutlet weak var tableView: UITableView!
    
    var countries : [Country] = []
    let searchController = UISearchController(searchResultsController: nil)
    var filteredcountry : [Country] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
       fetch()
        searchController.searchResultsUpdater = self
        // 2
        searchController.obscuresBackgroundDuringPresentation = false
        // 3
        searchController.searchBar.placeholder = "Search Country"
        // 4
        navigationItem.searchController = searchController
        // 5
        definesPresentationContext = true
        
        searchController.searchBar.scopeButtonTitles = Country.Region.allCases.map {$0.rawValue}
        searchController.searchBar.delegate = self
        
    }
    func fetch(){
        let url = "https://restcountries.eu/rest/v2"
        
        if let url = URL(string: url){
            URLSession.shared.dataTask(with: url) { (data, response, error) in
                if let data = data , error == nil {
                    do{
                        let json = try JSONDecoder().decode([Country].self, from: data)
                        
                        DispatchQueue.main.async {
                            self.countries = json
                            self.tableView.reloadData()
                        }
                    }catch{
                        print(error)
                    }
                }
            }.resume()
        }
    }
    
  
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard segue.identifier == "detail",
              let indexPath = tableView.indexPathForSelectedRow,
              let vc = segue.destination as? DetailTableViewController else{return}
        let country : Country
        if isFiltering{
            country = filteredcountry[indexPath.row]
        }else{
            country = countries[indexPath.row]
        }
        vc.selectedCountry = country
    }
    
    var isSearchBarEmpty: Bool {
      return searchController.searchBar.text?.isEmpty ?? true
    }
    var isFiltering: Bool {
      let searchBarScopeIsFiltering = searchController.searchBar.selectedScopeButtonIndex != 0
      return searchController.isActive && (!isSearchBarEmpty || searchBarScopeIsFiltering)
    }
    
    func filterContentForSearchText( _ searchText : String , region : Country.Region? = nil){
        filteredcountry = countries.filter({ (country : Country) -> Bool in
            let doesCategoryMatch = region == .All || country.region == region!.rawValue
            if isSearchBarEmpty{
                return doesCategoryMatch
            }else{
                return doesCategoryMatch && country.name.lowercased().contains(searchText.lowercased())
            }
        })
        tableView.reloadData()
    }


}
extension ViewController : UISearchResultsUpdating{
     func updateSearchResults(for searchController : UISearchController) {
        let searchBar = searchController.searchBar
        let category = Country.Region(rawValue: searchBar.scopeButtonTitles![searchBar.selectedScopeButtonIndex])
        filterContentForSearchText(searchBar.text! , region: category)
     }
}
extension ViewController : UISearchBarDelegate{
    func searchBar(_ searchBar: UISearchBar, selectedScopeButtonIndexDidChange selectedScope: Int) {
        let region = Country.Region(rawValue: searchBar.scopeButtonTitles![selectedScope])
        filterContentForSearchText(searchBar.text!, region: region)
    }
}
extension ViewController : UITableViewDataSource{
   
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if isFiltering{
            searchFooter.setIsFilteringToShow(filteredItemCount: filteredcountry.count, of: countries.count)
            return filteredcountry.count
        }else{
            searchFooter.setNotFiltering()
            return countries.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        let country : Country
        if isFiltering {
            country = filteredcountry[indexPath.row]
        }else{
            country = countries[indexPath.row]
        }
        cell.textLabel?.text = country.name
        
        return cell
    }
    
   
}

