//
//  Meal.swift
//  FoodTracker
//
//  Created by Davy, Martin on 10/7/15.
//  Copyright © 2015 Mandi. All rights reserved.
//

import UIKit

class Meal : NSObject, NSCoding
{
    // MARK: Properties
    
    var name: String
    var photo: UIImage?
    var rating: Int
    var date: NSString?
    var location : NSString?
    
    // MARK: Archiving Paths
    
    static let DocumentsDirectory = NSFileManager().URLsForDirectory(.DocumentDirectory, inDomains: .UserDomainMask).first!
    static let ArchiveURL = DocumentsDirectory.URLByAppendingPathComponent("meals")
    
    
    // MARK: Initialization
    init?(name:String, photo:UIImage?, rating:Int)
    {
        // Initialize stored properties
        self.name = name
        self.photo = photo
        self.rating = rating
        
        
        super.init()
        
        // Initialization should fail if there is no name or if rating is negative
        if name.isEmpty || rating < 0
        {
            return nil
        }
    }
    
    // MARK: Types
    struct PropertyKey
    {
        static let nameKey = "name"
        static let photoKey = "photo"
        static let ratingKey = "rating"
    }
    
    // MARK: NSCoding
    func encodeWithCoder(aCoder: NSCoder)
    {
        aCoder.encodeObject(name, forKey: PropertyKey.nameKey)
        aCoder.encodeObject(photo, forKey: PropertyKey.photoKey)
        aCoder.encodeInteger(rating, forKey: PropertyKey.ratingKey)
    }
    
    required convenience init?(coder aDecoder: NSCoder)
    {
        
        let name = aDecoder.decodeObjectForKey(PropertyKey.nameKey) as! String
        
        // Because photo is an optional property of Meal, use conditional cast.
        let photo = aDecoder.decodeObjectForKey(PropertyKey.photoKey) as? UIImage
        
        let rating = aDecoder.decodeIntegerForKey(PropertyKey.ratingKey)
        
        // Must call designated initilizer.
        self.init(name: name, photo: photo, rating: rating)
        
    }
}