//
//  PhotoViewController.swift
//  Hu-Facebook
//
//  Created by Hi_Hu on 2/28/15.
//  Copyright (c) 2015 hi_hu. All rights reserved.
//

import UIKit

class PhotoViewController: UIViewController {

    @IBOutlet weak var photoImageView: UIImageView!

    var photoImage: UIImage!
    var endFrame: CGRect!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        photoImageView.image = photoImage
        photoImageView.frame = endFrame
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func doneDidPress(sender: AnyObject) {
        dismissViewControllerAnimated(true, completion: nil)
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
