//
//  ClippingListViewController.swift
//  Scrapbook
//
//  Created by Chen Jonathan on 5/4/16.
//  Copyright © 2016 Chen Yi Tai. All rights reserved.
//

import UIKit

class ClippingListViewController: UITableViewController, UISearchBarDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    //If there are more than 1 clip show edit otherwise show add
    var check: Bool = false
    
    var clips: [Clipping] = []
    
    var searchClips: [Clipping] = []
    
    var colle: Collection?
    
    var image = UIImagePickerController()
    
    var bookModel: ScrapbookModel = ScrapbookModel()
    
    
    @IBOutlet weak var searchBar: UISearchBar!
    
    //The search bar function
    func searchBar(searchbar: UISearchBar, textDidChange searchText: String)
    {
        //If collection not nil
        if(colle == nil)
        {
            //If search is not empty
            if(searchText != "")
            {
                clips = bookModel.searchClippings(searchText)
            }
            else
            {
                clips = bookModel.getAllClippings()
            }
        }
        else
        {
            if(searchText != "")
            {
                clips = bookModel.searchClippingWithin(searchText, collection: colle!)
            }
            else
            {
                clips = colle?.clippings.allObjects as! [Clipping]
            }
        }
        
        self.tableView.reloadData()
    }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
        
        searchClips = clips
        searchBar.delegate = self
        
        //Check if there are more than one clips
        if(check)
        {
           self.navigationItem.rightBarButtonItem = self.editButtonItem()
           self.navigationItem.title = "All Clippings"
        }
        else
        {
            self.navigationItem.title = colle?.name
            self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem:  UIBarButtonSystemItem.Add, target:  self, action: Selector("addClipping"))
        }
        
        image.delegate = self
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingImage image: UIImage, editingInfo: [String : AnyObject]?) {
        self.dismissViewControllerAnimated(true, completion: { () -> Void in
            
        })
        
        
        //Get the document URL and fileanme
        let documentsURL = NSFileManager.defaultManager().URLsForDirectory(.DocumentDirectory, inDomains: .UserDomainMask)[0]
        let imgName: String = "image_\(NSDate.timeIntervalSinceReferenceDate())" + ".png"
        let fileURL = documentsURL.URLByAppendingPathComponent(imgName)
        
        //Save the image using the fileURL path
        let pngImageData = UIImagePNGRepresentation(image)
        let result = pngImageData!.writeToFile(fileURL.path!, atomically: true) //save to file
        
        //Check if the image had been saved or not with file URL
        if result{
            print("save success " + imgName + " " + fileURL.path!)}
        else{
            print("save error")
        }
        
        //Create the AlertController
        let alert: UIAlertController = UIAlertController(title: "Create New Clipping", message: "", preferredStyle: .Alert)
        
        //Create and add the Cancel action
        let cancelAction: UIAlertAction = UIAlertAction(title: "Cancel", style: .Cancel) { action -> Void in
            //Do some stuff
        }
        alert.addAction(cancelAction)
        
        //Add a text field
        alert.addTextFieldWithConfigurationHandler { textField -> Void in
            textField.text = "Clipping Description"
            //TextField configuration
            //textField.textColor = UIColor.blueColor()
        }
        
        
        //Create an option action for user to chooise
        let createAction: UIAlertAction = UIAlertAction(title: "Create", style: .Default) { action -> Void in
            if alert.textFields![0].text != nil{
                
                let newClip: Clipping = self.bookModel.newClipping(alert.textFields![0].text!, image: imgName)
                
                print("Image Name: " + imgName)
                self.clips.append(newClip)
                self.bookModel.addClippingToCollection(newClip, collection: self.colle!)
            }
            
            self.tableView.reloadData()
        }
        alert.addAction(createAction)
        
        //Present the AlertController
        alert.view.setNeedsLayout() //kill bug
        self.presentViewController(alert, animated: true, completion: nil)
    }
    
    //Add new clipping
    func addClipping()
    {
        //Create a alert for user to insert clipping description
        let alert: UIAlertController = UIAlertController(title: "Create New Clipping", message: "", preferredStyle: .ActionSheet)
        
        let cancel: UIAlertAction = UIAlertAction(title: "Cancel", style: .Cancel, handler: nil)
        
        alert.addAction(cancel)
        
        
        let takePictureAction: UIAlertAction = UIAlertAction(title: "Take Picture", style: .Default) { action -> Void in
            //Open the camera for user to take phote
            if(UIImagePickerController .isSourceTypeAvailable(UIImagePickerControllerSourceType.Camera))
            {
                //Set the camera source
                self.image.sourceType = UIImagePickerControllerSourceType.Camera
                
                //make photo can be edited
                self .presentViewController(self.image, animated: true, completion: nil)
            }
            else
            {
                
                //Check if the user have camera
                let alert: UIAlertController = UIAlertController(title: "Warning", message: "You don't have camera", preferredStyle: .Alert)
                
                //Create and add the Cancel action
                let cancelAction: UIAlertAction = UIAlertAction(title: "Cancel", style: .Cancel) { action -> Void in
                   
                }
                //Add action
                alert.addAction(cancelAction)
                alert.view.setNeedsLayout()
                self.presentViewController(alert, animated: true, completion: nil)
            }
        }
        
        //Add takePicture action
        alert.addAction(takePictureAction)
        
        //Choose picture from camera
        let choosePictureAction: UIAlertAction = UIAlertAction(title: "Choose From Camera Roll", style: .Default) { action -> Void in
            
            // Picking from camera
            if UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.SavedPhotosAlbum){
                
                
                self.image.delegate = self
                self.image.sourceType = UIImagePickerControllerSourceType.SavedPhotosAlbum;
                self.image.allowsEditing = false
                
                self.presentViewController(self.image, animated: true, completion: nil)
            }
            
        }
        alert.addAction(choosePictureAction)
        
        //Present the AlertController
        self.presentViewController(alert, animated: true, completion: nil)
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
        return clips.count
    }

    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        //Upate the cell in the tabel view
        let cell = tableView.dequeueReusableCellWithIdentifier("result", forIndexPath: indexPath)

        cell.textLabel!.text = clips[indexPath.row].notes
        let imgPath = clips[indexPath.row].image
        
        /*
        Used for debug check cell and image
        print("*********************")
        print("Seting Cell imageName: " + imgPath)
         */
        
        //Create an image view and update image to the cell
        let documentURL = NSFileManager.defaultManager().URLsForDirectory(.DocumentDirectory, inDomains: .UserDomainMask)[0]
        let fileURL = documentURL.URLByAppendingPathComponent(imgPath)
        cell.imageView?.image = UIImage(named: fileURL.path!)
        
        
        //Formate the date and set date
        let formatter = NSDateFormatter()
        formatter.dateStyle = NSDateFormatterStyle.LongStyle
        formatter.timeStyle = .MediumStyle
        
        let date = clips[indexPath.row].dateCreated
        
        let dateString = formatter.stringFromDate(date)
        
        cell.detailTextLabel!.text = dateString
        

        return cell
    }
    

    /*
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    
    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            // Delete the row from the data source
            let fileManager = NSFileManager.defaultManager()
            let documentsURL = NSFileManager.defaultManager().URLsForDirectory(.DocumentDirectory, inDomains: .UserDomainMask)[0]
            let fileURL = documentsURL.URLByAppendingPathComponent(clips[indexPath.row].image)
            do {
                try fileManager.removeItemAtPath(fileURL.path!)
            }
            catch let error as NSError {
                print("Ooops! Something went wrong: \(error)")
            }
            
            //delete in data base
            bookModel.deleteClipping(clips[indexPath.row])
            
            //delete in clipping array
            clips.removeAtIndex(indexPath.row)
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
        let destination = segue.destinationViewController as! ClippingDetailViewController
        let row = self.tableView.indexPathForSelectedRow?.row
        
        destination.label = clips[row!].notes
        destination.img = clips[row!].image
        
        let formatter = NSDateFormatter()
        formatter.dateStyle = NSDateFormatterStyle.LongStyle
        formatter.timeStyle = .MediumStyle
        
        let date = clips[row!].dateCreated
        
        let dateString = formatter.stringFromDate(date)
        
        
        let time = dateString
        destination.time = String(time)
    }
   

}
