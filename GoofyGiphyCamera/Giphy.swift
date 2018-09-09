//
//  Giphy.swift
//  GoofyGiphyCamera
//
//  Created by Brendan Manning on 9/8/18.
//  Copyright © 2018 Brendan Manning. All rights reserved.
//

import Alamofire
import SwiftyJSON
import UIKit

class Giphy: NSObject {
    static func random(query: String, callback: @escaping (_ gif: URL?) -> Void) {
        
        print("https://api.giphy.com/v1/gifs/random?api_key=B8sn2TaHbz5ATCH4Zd9VoJpoEKrQClAt&rating=PG-13&tag=" + query.replacingOccurrences(of: " ", with: "%20"));
        
        Alamofire.request("https://api.giphy.com/v1/gifs/random?api_key=r4aLKSZRLbr4gtxwU93uns6L68c89ZbT&rating=G&tag=" + query.replacingOccurrences(of: " ", with: "%20")).responseJSON { response in
            print(response);
            if let jsonres = response.result.value {
                let json = JSON(jsonres);
                let url = json["data"]["images"]["original"]["url"].stringValue;
                print("Erl: " + url);
                callback(URL(string: url));
            }
        }
    }
}
