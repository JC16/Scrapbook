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
    let manageObject = (UIApplication.sharedApplication().delegate as! AppDelegate).managedObjectContext
    
    //Create collection function
    func newCollection(name: String)->Collection
    {
        //Insert the new collection data into database
        let EntityDescription = NSEntityDescription.entityForName("Collection", inManagedObjectContext: manageObject)
        let newData = Collection(entity: EntityDescription!, insertIntoManagedObjectContext: manageObject)
        
        //Set the date name eqaul name
        newData.name = name
        
        do
        {
            //Save collection
            try manageObject.save()
        }catch
        {
            print("Error in saving collection")
        }
        
        return newData
    }
    
    //Get all the clippings return a clipping array
    func getAllClippings()->[Clipping]
    {
        
        var clippingArray: [Clipping] = []
        let fetch = NSFetchRequest(entityName: "Clipping")
        
        do
        {
            //Fetch the result from database
            let fetchResult = try manageObject.executeFetchRequest(fetch)as?[Clipping]
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
    
    
    //Get collection
    func getAllCollections()->[Collection]
    {

        let fetch = NSFetchRequest(entityName: "Collection")
        
        var collectionArray = [Collection]()
        
        do
        {
            let fetchResult = try manageObject.executeFetchRequest(fetch)as?[Collection]
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
    
    
    //Create new clipping store in database
    func newClipping(notes:String, image:String)->Clipping
    {
        let EntityDescription = NSEntityDescription.entityForName("Clipping", inManagedObjectContext: manageObject)
        
        let newClip = Clipping(entity: EntityDescription!, insertIntoManagedObjectContext: manageObject)
        
        newClip.notes = notes
        newClip.dateCreated = NSDate()
        newClip.image = image
        
        do
        {
            try manageObject.save()
        }
        catch
        {
            print("Could not save clip")
        }
        
        return newClip
    }
    
    //Add cliping to collection
    func addClippingToCollection(clipping: Clipping, collection: Collection)
    {
        //collection.addCliping(clipping)
        clipping.collections = collection
        
        do
        {
            try manageObject.save()
        }
        catch
        {
            print("Error adding clipping")
        }
        
    }
    
    //Delete collection
    func deleteCollection(collection: Collection)
    {
        for clipping in collection.clippings
        {
            manageObject.deleteObject(clipping as! NSManagedObject)
        }
        manageObject.deleteObject(collection)
        
        do
        {
            try manageObject.save()
        }catch
        {
            print("error deleting collection")
        }
        
    }
    
    //Delete Clipping
    func deleteClipping(clipping: Clipping)
    {
        manageObject.deleteObject(clipping)
        
        do
        {
            try manageObject.save()
        }
        catch
        {
            print("Error deleting clipping")
        }
    }
    
    //Search Clippings
    func searchClippings(match:String) ->[Clipping]
    {
        let request = NSFetchRequest()
        let EntityDescription = NSEntityDescription.entityForName("Clipping", inManagedObjectContext: manageObject)
        request.entity = EntityDescription
        
        let pred = NSPredicate(format: "notes contains[c] %@", match)
        request.predicate = pred
        
        do{
            let results = try manageObject.executeFetchRequest(request)
            return results as! [Clipping]
        } catch {
            print("error searching clippings")
        }
        return []
        
    }
    
    //Search Clipping with collection
    func searchClippingWithin(match: String, collection: Collection)->[Clipping]
    {
        let request = NSFetchRequest()
        let entityDescription = NSEntityDescription.entityForName("Clipping",
                                                                  inManagedObjectContext: manageObject)
        request.entity = entityDescription
        
        let pred = NSPredicate(format: "notes contains[c] %@", match)
        let pred2 = NSPredicate(format: "collections == %@", collection)
        let predicate = NSCompoundPredicate(type: NSCompoundPredicateType.AndPredicateType, subpredicates: [pred, pred2])
        request.predicate = predicate
        
        //var error: NSError?
        do{
            let results = try manageObject.executeFetchRequest(request)
            return results as! [Clipping]
        } catch {
            print("error searching clippings")
        }
        return []
    }
    
}
