//
//  ClippingDetailViewController.swift
//  Scrapbook
//
//  Created by Chen Jonathan on 5/4/16.
//  Copyright © 2016 Chen Yi Tai. All rights reserved.
//

import UIKit

class ClippingDetailViewController: UIViewController {

    var img: String!
    var label: String!
    var time: String!
    
    @IBOutlet weak var ImageLabel: UIImageView!
    @IBOutlet weak var DateLabel: UILabel!
    @IBOutlet weak var NoteLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Get the document URL
        let documentURL = NSFileManager.defaultManager().URLsForDirectory(.DocumentDirectory, inDomains: .UserDomainMask)[0]
        //Combine the document URL with file name
        let fileURL = documentURL.URLByAppendingPathComponent(img)
        
        //Set the imageView for the detail page
        ImageLabel.image = UIImage(contentsOfFile: fileURL.path!)
        
        //Set description and date
        NoteLabel.text = "Description: " + label
        DateLabel.text = "Date: " + time
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
