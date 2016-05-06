//
//  CollectionListViewController.swift
//  Scrapbook
//
//  Created by Chen Jonathan on 5/4/16.
//  Copyright © 2016 Chen Yi Tai. All rights reserved.
//

import UIKit

class CollectionListViewController: UITableViewController {
    
    
    //The add collection button
    @IBAction func Addbutton(sender: AnyObject) {
        addCollection()
    }
    
    
    var bookModel: ScrapbookModel = ScrapbookModel()

    //Create an edit button for edit collection
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        self.navigationItem.leftBarButtonItem = self.editButtonItem()
        
        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // Return the number of sections
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return bookModel.getAllCollections().count+1
    }

    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        //Dequeue the information
        let cell = tableView.dequeueReusableCellWithIdentifier("collection", forIndexPath: indexPath)

        //Get all the collection from coredata
        var colle: [Collection] = bookModel.getAllCollections()
    
        //If there are more than one collection get collection
        if(indexPath.row > 0)
        {
            cell.textLabel?.text = colle[indexPath.row - 1].name
        }
        else
        {
            //All clippings
            cell.textLabel?.text = "All Clippings"
        }
        
        return cell
    }
    

    
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
    
        if indexPath.row == 0
        {
            return false
        }
        else
        {
            return true
        }
    }
    

    
    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            //Delete the collection
            bookModel.deleteCollection(bookModel.getAllCollections()[indexPath.row - 1])
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        }
    }
    

    /*
    // Override to support rearranging the table view.
    override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        
        //Navigate the collection view ro clipping view
        let destination = segue.destinationViewController as! ClippingListViewController
        let row = self.tableView.indexPathForSelectedRow?.row
        var coll: [Collection] = bookModel.getAllCollections()
        
        //Check which clips to go
        if(row > 0){
            destination.clips = coll[row! - 1].clippings.allObjects as! [Clipping]
            destination.colle = coll[row! - 1]
        }
        else{
            destination.clips = bookModel.getAllClippings()
            destination.check = true
        }
        
        
    }
    
    //Add collection function
    func addCollection()
    {
        //Create a alert for user to input the collection name
        let alert: UIAlertController = UIAlertController(title: "Create new Collection", message: "",preferredStyle: .Alert)
        
        //Cancel if they don't want to do it
        let cancel: UIAlertAction = UIAlertAction(title: "Cancel", style: .Cancel, handler: nil)
        
        alert.addAction(cancel)
        
        alert.addTextFieldWithConfigurationHandler { textField -> Void in
            textField.text = " "
        }
        
        let createAction: UIAlertAction = UIAlertAction(title: "Create", style: .Default) { action -> Void in
            if alert.textFields![0].text != nil{
                self.bookModel.newCollection(alert.textFields![0].text!)
            }
            
            self.tableView.reloadData()
        }
        alert.addAction(createAction)
        
        alert.view.setNeedsLayout()
        self.presentViewController(alert, animated: true, completion: nil)
        
        
    }
    

}
