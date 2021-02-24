//
//  Country.swift
//  CountryApp
//
//  Created by Akdag on 23.02.2021.
//

import Foundation
struct Country: Decodable {
    var name: String
    var capital: String
    var region: String
    var population: Int
    var timezones: [String]
    var languages: [Languages]
    
    enum Region : Decodable{
        case All
        case Europe
        case Africa
        case Oceania
   
        
    }
}
extension Country.Region : CaseIterable{}
extension Country.Region : RawRepresentable{
    typealias RawValue = String
    
    init?(rawValue: RawValue) {
        switch rawValue {
        case "All": self = .All
        case "Europe" : self = .Europe
        case "Africa" : self = .Africa
        case "Oceania" : self = .Oceania
        default : return nil
        }
    }
    var rawValue: RawValue{
        switch self{
        case .All : return "All"
        case .Africa : return "Africa"
        case .Europe : return "Europe"
        case .Oceania : return "Oceania"
        }
    }
}

struct Languages: Codable {
    var name: String
}
/*
extension Country {
    static func countries( _ data : Data) -> [Country]{
        let url = "https://restcountries.eu/rest/v2"
       
        if let url = URL(string: url){
            URLSession.shared.dataTask(with: url) { (data, response, error) in
                if let data = data , error == nil{
                    do{
                        let data = try JSONDecoder().decode([Country].self, from: data)
                    }catch{
                        print(error)
                    }
                }
            }.resume()
        }else{
            return [ ]
        }
            
        
       return []
    }
}
*/

