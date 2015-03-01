//
//  PhotoViewController.swift
//  Hu-Facebook
//
//  Created by Hi_Hu on 2/28/15.
//  Copyright (c) 2015 hi_hu. All rights reserved.
//

import UIKit

class PhotoViewController: UIViewController, UIScrollViewDelegate {

    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var photoImageView: UIImageView!

    var photoImage: UIImage!
    var endFrame: CGRect!
    var scrolledPhotoFrame: CGRect!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // data passed from feedViewController gets stored here
        photoImageView.image = photoImage
        photoImageView.frame = endFrame
        
        // default value of scrolledPhotoFrame is unscrolled position of photoImageView
        scrolledPhotoFrame = endFrame
            
        scrollView.delegate = self      // required for registering scroll events
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func doneDidPress(sender: AnyObject) {
        dismissViewControllerAnimated(true, completion: nil)
    }

    func scrollViewDidScroll(scrollView: UIScrollView!) {
        // This method is called as the user scrolls
//        println(scrollView.contentOffset.y)
//        println(scrollView.frame.origin)

    }
    
    
    func scrollViewDidEndDragging(scrollView: UIScrollView!, willDecelerate decelerate: Bool) {
        
        var offsetY = scrollView.contentOffset.y
        
        if (abs(offsetY) > 80) {
            scrolledPhotoFrame.origin.y = scrolledPhotoFrame.origin.y - offsetY
            photoImageView.hidden = true
//            println(scrolledPhotoFrame)
            dismissViewControllerAnimated(true, completion: nil)
        }

        // This method is called right as the user lifts their finger
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
