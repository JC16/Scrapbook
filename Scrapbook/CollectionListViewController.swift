//
//  CollectionListViewController.swift
//  Scrapbook
//
//  Created by Chen Jonathan on 5/4/16.
//  Copyright © 2016 Chen Yi Tai. All rights reserved.
//

import UIKit

class CollectionListViewController: UITableViewController {
    
    
    
    @IBAction func Addbutton(sender: AnyObject) {
        addCollection()
    }
    var bookModel: ScrapbookModel = ScrapbookModel()

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
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return bookModel.getAllCollections().count+1
    }

    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("collection", forIndexPath: indexPath)

        var colle: [Collection] = bookModel.getAllCollections()
        // Configure the cell...

        if(indexPath.row > 0)
        {
            cell.textLabel?.text = colle[indexPath.row - 1].name
        }
        else
        {
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
        
        let destinationNavigationController = segue.destinationViewController as! ClippingListViewController
        let row = self.tableView.indexPathForSelectedRow?.row
        var coll: [Collection] = bookModel.getAllCollections()
        
        if(row > 0){
            destinationNavigationController.clips = coll[row! - 1].clippings.allObjects as! [Clipping]
            destinationNavigationController.colle = coll[row! - 1]
        }
        else{
            destinationNavigationController.clips = bookModel.getAllClippings()
            destinationNavigationController.check = true
        }
        
        
    }
    
    func addCollection()
    {
        let alert: UIAlertController = UIAlertController(title: "Create new Collection", message: "",preferredStyle: .Alert)
        
        let cancel: UIAlertAction = UIAlertAction(title: "Cancel", style: .Cancel, handler: nil)
        
        alert.addAction(cancel)
        
        alert.addTextFieldWithConfigurationHandler { textField -> Void in
            textField.text = "Enter Collection Name "
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
