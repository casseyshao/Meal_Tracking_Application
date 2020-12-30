//
//  Meal.swift
//  FoodTracker
//
//  Created by Cassey Shao on 2020-12-22.
//  Copyright © 2020 Cassey Shao. All rights reserved.
//

// Importing UIKit also gives access to Foundation framework
import UIKit
import os.log

// In Swift, can represent:
// name using a String
// photo using a UIImage
// rating using an Int

class Meal: NSObject, NSCoding {
    
    //Mark: Properties
    
    var name: String
    var photo: UIImage?
    var rating: Int
    
    //Mark: Archiving Paths
    
    static let DocumentsDirectory = FileManager().urls(for: .documentDirectory, in: .userDomainMask).first!
    static let ArchiveURL = DocumentsDirectory.appendingPathComponent("meals")
    
    //Mark: Types
    
    struct PropertyKey {
        static let name = "name"
        static let photo = "photo"
        static let rating = "rating"
    }
    
    //Mark: Initalization
    
    init?(name: String, photo: UIImage?, rating: Int) {
        
        // guard statement declares a condition that must be true in order for following code to be executed
        // The name must not be empty
        guard  !name.isEmpty else {
            return nil
        }
        
        // The rating must be between 0 and 5 inclusively
        guard (rating >= 0) && (rating <= 5) else {
            return nil
        }
        
        // Initialize stored properties.
        self.name = name
        self.photo = photo
        self.rating = rating
    }
    
    //Mark: NSCoding
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(name, forKey: PropertyKey.name)
        aCoder.encode(photo, forKey: PropertyKey.photo)
        aCoder.encode(rating, forKey: PropertyKey.rating)
    }
    
    required convenience init?(coder aDecoder: NSCoder) {
        // The name is required. If we cannot decode a name string, the initializer should fail.
        guard let name = aDecoder.decodeObject(forKey: PropertyKey.name) as? String else {
            os_log("Unable to decode the name for a Meal object.", log: OSLog.default, type: .debug)
            return nil
        }
        
        // Because photo is an optional property of Meal, just use conditional cast.
        let photo = aDecoder.decodeObject(forKey: PropertyKey.photo) as? UIImage
        
        let rating = aDecoder.decodeInteger(forKey: PropertyKey.rating)
        
        // Must call designated initializer.
        self.init(name: name, photo: photo, rating: rating)
    }

}
