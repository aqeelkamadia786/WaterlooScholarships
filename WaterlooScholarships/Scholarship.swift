//
//  Scholarship.swift
//  WaterlooScholarships
//
//  Created by Aqeel Kamadia on 2017-10-12.
//  Copyright © 2017 Aqeel Kamadia. All rights reserved.
//

import Foundation

class Scholarship: NSObject, NSCoding {
    let title: String
    let value: String
    let details: String
    let programs: [String]
    var favourited: Bool
    
    init(with dictionary: [String: AnyObject]) {
        self.title = dictionary["title"] as! String
        self.value = dictionary["value"] as! String
        self.details = dictionary["description"] as! String
        self.programs = dictionary["programs"] as! [String]
        self.favourited = false
    }
    
    required init?(coder aDecoder: NSCoder) {
        self.title = aDecoder.decodeObject(forKey: "title") as! String
        self.value = aDecoder.decodeObject(forKey: "value") as! String
        self.details = aDecoder.decodeObject(forKey: "details") as! String
        self.programs = aDecoder.decodeObject(forKey: "programs") as! [String]
        self.favourited = aDecoder.decodeBool(forKey: "favourited")
    }
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(self.title, forKey: "title")
        aCoder.encode(self.value, forKey: "value")
        aCoder.encode(self.details, forKey: "details")
        aCoder.encode(self.programs, forKey: "programs")
        aCoder.encode(self.favourited, forKey: "favourited")
    }
}
