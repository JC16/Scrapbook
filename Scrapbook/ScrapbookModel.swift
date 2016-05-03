//
//  ScrapbookModel.swift
//  Scrapbook
//
//  Created by Chen Jonathan on 5/2/16.
//  Copyright © 2016 Chen Yi Tai. All rights reserved.
//

import UIKit
import CoreData

class ScrapbookModel
{
    var collectionArray: [Collection] = []
    var manageObject: NSManagedObjectContext?
    
    init(object: NSManagedObjectContext?)
    {
        manageObject = object
    }
    
    func saveObject()
    {
        do
        {
            try manageObject?.save()
        }catch
        {
            print("Error")
        }
    }
    
    func newCollection(name: String)->Collection
    {
        let EntityDescription = NSEntityDescription.entityForName("Collection", inManagedObjectContext: manageObject!)
        let newData = Collection(entity: EntityDescription!, insertIntoManagedObjectContext: manageObject)
        
        newData.name = name
        
        saveObject()
        
        return newData
    }
    
    func getAllClippings()->[Clipping]
    {
        var clippingArray: [Clipping] = []
        let fetch = NSFetchRequest(entityName: "Clipping")
        
        do
        {
            let fetchResult = try manageObject!.executeFetchRequest(fetch)as?[Clipping]
            if let Clipping = fetchResult
            {
                clippingArray = Clipping
            }
        }catch
        {
            print("Error fetching")
        }
        return clippingArray
    }
    
    
    
    func getAllCollections()->[Collection]
    {
        //var clippingArray: [Clipping] = []
        let fetch = NSFetchRequest(entityName: "Collection")
        
        do
        {
            let fetchResult = try manageObject!.executeFetchRequest(fetch)as?[Collection]
            if let Collections = fetchResult
            {
                collectionArray = Collections
            }
        }catch
        {
            print("Error fetching")
        }
        return collectionArray
    }
    
    func newClipping(notes:String, image:UIImage)->Clipping
    {
        let EntityDescription = NSEntityDescription.entityForName("Clipping", inManagedObjectContext: manageObject!)
        
        let newClip = Clipping(entity: EntityDescription!, insertIntoManagedObjectContext: manageObject!)
        
        newClip.notes = notes
        newClip.dateCreated = NSDate()
        
        let documentFolder: String = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)[0]
        
        newClip.image = "/\(newClip.image).jpg"
        
        let documentPath = documentFolder + newClip.image
        
        if let imageData = UIImageJPEGRepresentation(image,1.0)
        {
            imageData.writeToFile(documentPath, atomically: true)
        }else
        {
            print("No Image found")
        }
        
        return newClip
    }
    
    func addClippingToCollection(clipping: Clipping, collection: Collection)
    {
        //collection.addCliping(clipping)
        clipping.collections = collection
        
        do
        {
            try manageObject?.save()
        }
        catch
        {
            print("Error adding clipping")
        }
        
    }
    
    func deleteCollection(collection: Collection)
    {
        for clipping in collection.clippings
        {
            manageObject!.deleteObject(clipping as! NSManagedObject)
        }
        manageObject!.deleteObject(collection)
        
        do
        {
            try manageObject?.save()
        }catch
        {
            print("error deleting collection")
        }
        
    }
    
    func deleteClipping(clipping: Clipping)
    {
        manageObject!.deleteObject(clipping)
        
        do
        {
            try manageObject?.save()
        }
        catch
        {
            print("Error deleting clipping")
        }
    }
    
    func searchClippings(match:String) ->[Clipping]
    {
        let request = NSFetchRequest()
        let EntityDescription = NSEntityDescription.entityForName("Clipping", inManagedObjectContext: manageObject!)
        request.entity = EntityDescription
        
        let pred = NSPredicate(format: "notes contains[c] %@", match)
        request.predicate = pred
        
        do{
            let results = try manageObject?.executeFetchRequest(request)
            return results as! [Clipping]
        } catch {
            print("error searching clippings")
        }
        return []
        
    }
    
    func searchClippingWithin(match: String, collection: Collection)->[Clipping]
    {
        let request = NSFetchRequest()
        let entityDescription = NSEntityDescription.entityForName("Clipping",
                                                                  inManagedObjectContext: manageObject!)
        request.entity = entityDescription
        
        let pred = NSPredicate(format: "notes contains[c] %@", match)
        let pred2 = NSPredicate(format: "myCollection == %@", collection)
        let predicate = NSCompoundPredicate(type: NSCompoundPredicateType.AndPredicateType, subpredicates: [pred, pred2])
        request.predicate = predicate
        
        do{
            let results = try manageObject?.executeFetchRequest(request)
            return results as! [Clipping]
        } catch {
            print("error searching clippings")
        }
        return []
    }
    
}
