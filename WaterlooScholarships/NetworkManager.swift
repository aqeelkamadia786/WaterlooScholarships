//
//  NetworkManager.swift
//  WaterlooScholarships
//
//  Created by Aqeel Kamadia on 2017-10-10.
//  Copyright © 2017 Aqeel Kamadia. All rights reserved.
//

import Foundation

class NetworkManager {
    static let networkManager = NetworkManager()
    let url = "https://api.uwaterloo.ca/v2/"
    let key = "4d4225db0e3723d3f10d9e722c7aab85"
    
    private func dataTask(request: NSMutableURLRequest, method: String, completion: @escaping (_ success: Bool, _ object: AnyObject?) -> ()) {
        request.httpMethod = method
        
        let session = URLSession(configuration: URLSessionConfiguration.default)
        
        session.dataTask(with: request as URLRequest) { (data, response, error) -> Void in
            guard error == nil else {
                print(error ?? "ERROR")
                return
            }
            guard let data = data else {
                print("Error in data")
                return
            }
            do {
                guard let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] else {
                    print("Error getting JSON")
                    return
                }
                if let response = response as? HTTPURLResponse, 200...299 ~= response.statusCode {
                    completion(true, json as AnyObject)
                }   else {
                    print(json)
                    completion(false, json as AnyObject)
                }
            }   catch {
                print("Error trying to convert data to JSON")
                return
            }
        }.resume()
    }
    
    private func get(request: URLRequest, completion: @escaping (_: Bool, _ object: AnyObject?) -> ()) {
        dataTask(request: request as! NSMutableURLRequest, method: "GET", completion: completion)
    }
    
    private func clientURLRequest(path: String, params: [String: AnyObject]?) -> NSMutableURLRequest {
        var paramString = ""
        if let params = params {
            for (key, value) in params {
                paramString += "\(key)=\(value)&"
            }
        }
        let request = NSMutableURLRequest(url: URL(string: url + path + "?" + paramString)!)
        return request
    }
    
    func getUndergraduate(completion: @escaping (_ object: [String: AnyObject]) -> ()) {
        let params = ["key": key]
        get(request: clientURLRequest(path: "awards/undergraduate.json", params: params as [String : AnyObject]) as URLRequest) { (success, object) -> () in
            DispatchQueue.main.async(execute: { () -> Void in
                if success {
                    print("Success")
                    completion(object as! [String: AnyObject])
                } else {
                    print("There was an error")
                }
            })
        }
    }
    
    func getGraduate(completion: @escaping (_ object: [String: AnyObject]) -> ()) {
        let params = ["key": key]
        get(request: clientURLRequest(path: "awards/graduate.json", params: params as [String : AnyObject]) as URLRequest) { (success, object) -> () in
            DispatchQueue.main.async(execute: { () -> Void in
                if success {
                    print("Success")
                    completion(object as! [String: AnyObject])
                } else {
                    print("There was an error")
                }
            })
        }
    }
}

