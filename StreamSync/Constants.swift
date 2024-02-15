//
//  Constants.swift
//  StreamSync
//
//  Created by Deniz Dilbilir on 18/02/2024.
//

import Foundation

struct Constants {
  
    static let baseURL = "https://api.themoviedb.org"
    static let youtubeBaseURL = "https://youtube.googleapis.com/youtube/v3/search?"
   
    
    static var API_KEY: String {
           guard let path = Bundle.main.path(forResource: "Keys", ofType: "plist"),
                 let keys = NSDictionary(contentsOfFile: path),
                 let API_KEY = keys["API_KEY"] as? String else {
               fatalError("Unable to load client ID from Keys.plist")
           }
           return API_KEY
       }
    static var imageBaseURL = "https://image.tmdb.org/t/p/w500/"
    
    static var YoutubeAPI_Key: String {
        
        guard let path = Bundle.main.path(forResource: "Keys", ofType: "plist"),
              let keys = NSDictionary(contentsOfFile: path),
              let YoutubeAPI_Key = keys["YoutubeAPI_Key"] as? String else {
            fatalError("Unable to load client ID from Keys.plist")
        }
        return YoutubeAPI_Key
    }

}
