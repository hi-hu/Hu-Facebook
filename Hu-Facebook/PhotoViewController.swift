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
    @IBOutlet weak var blackView: UIView!
    @IBOutlet weak var doneButton: UIButton!
    @IBOutlet weak var photoActions: UIImageView!
    
    @IBOutlet weak var photoImageView: UIImageView! // need to kill
    @IBOutlet weak var wedding2: UIImageView!
    @IBOutlet weak var wedding3: UIImageView!
    @IBOutlet weak var wedding4: UIImageView!
    @IBOutlet weak var wedding5: UIImageView!
    
    
    var photoImage: UIImage! // need to kill
    
    var w1: UIImage!
    var w2: UIImage!
    var w3: UIImage!
    var w4: UIImage!
    var w5: UIImage!
    var pageIndex: Int!

    var endFrame: CGRect!

    // placeholder for if the image frame is scrolled
    var scrolledPhotoFrame: CGRect!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // data passed from feedViewController gets stored here
        photoImageView.image = photoImage
        photoImageView.frame = endFrame

//        wedding1.image = w1
        wedding2.image = w2
        wedding3.image = w3
        wedding4.image = w4
        wedding5.image = w5
        
        
        scrollView.contentSize = CGSize(width: 1600, height: 568)
        
        
        scrollView.contentOffset.x = CGFloat(pageIndex * 320)
        
//        var page = Int(scrollView.contentOffset.x / (scrollView.contentSize.width/4))
        
        
        // default value of scrolledPhotoFrame is unscrolled position of photoImageView
        scrolledPhotoFrame = endFrame

        // required for registering scroll events
        scrollView.delegate = self
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func doneDidPress(sender: AnyObject) {
        dismissViewControllerAnimated(true, completion: nil)
    }

    // change the alpha of the background and button as the user scrolls
    func scrollViewDidScroll(scrollView: UIScrollView!) {
        
        var alpha = CGFloat(1 - abs(scrollView.contentOffset.y) / 100)
        var alpha2 = CGFloat(1 - abs(scrollView.contentOffset.y) / 20)
        
        blackView.alpha = alpha
        doneButton.alpha = alpha2
        photoActions.alpha = alpha2
    }
    
    // This method is called right as the user lifts their finger
    func scrollViewDidEndDragging(scrollView: UIScrollView!, willDecelerate decelerate: Bool) {

        var offsetY = scrollView.contentOffset.y
        var alpha = CGFloat(1 - abs(scrollView.contentOffset.y) / 240)
        
        if (abs(offsetY) > 100) {
            scrolledPhotoFrame.origin.y = scrolledPhotoFrame.origin.y - offsetY
            blackView.hidden = true
            photoImageView.hidden = true
            doneButton.hidden = true
            dismissViewControllerAnimated(true, completion: nil)
        }
    }
    
    // selecting the view to zoom
    func viewForZoomingInScrollView(scrollView: UIScrollView!) -> UIView! {
        return photoImageView
    }
}
