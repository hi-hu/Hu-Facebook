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
    
    // for the side scrolling gallery
    @IBOutlet weak var wedding1: UIImageView!
    @IBOutlet weak var wedding2: UIImageView!
    @IBOutlet weak var wedding3: UIImageView!
    @IBOutlet weak var wedding4: UIImageView!
    @IBOutlet weak var wedding5: UIImageView!
    var w1: UIImage!
    var w2: UIImage!
    var w3: UIImage!
    var w4: UIImage!
    var w5: UIImage!
    var pageIndex: Int!
    var currentPage: Int!
    var endFrame: CGRect!

    // placeholder for if the image frame is scrolled
    var scrolledPhotoFrame: CGRect!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // data passed from feedViewController gets stored here
        wedding1.image = w1
        wedding2.image = w2
        wedding3.image = w3
        wedding4.image = w4
        wedding5.image = w5
        
        // set the right endFrame based on the selectedImage
        switch pageIndex {
        case 0:
            wedding1.frame = endFrame
        case 1:
            wedding2.frame = endFrame
            wedding2.frame.origin.x = 320
        case 2:
            wedding3.frame = endFrame
            wedding3.frame.origin.x = 640
        case 3:
            wedding4.frame = endFrame
            wedding4.frame.origin.x = 960
        case 4:
            wedding5.frame = endFrame
            wedding5.frame.origin.x = 1280
        default:
            break
        }
        
        currentPage = pageIndex
        
        scrollView.contentSize = CGSize(width: 1600, height: 568)
        scrollView.contentOffset.x = CGFloat(pageIndex * 320)
        
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

    // called while scrolling
    func scrollViewDidScroll(scrollView: UIScrollView!) {
        
        currentPage = Int(scrollView.contentOffset.x / 320)
        
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
            scrollView.hidden = true // could be wrong
            doneButton.hidden = true
            dismissViewControllerAnimated(true, completion: nil)
        }
    }
    
    // selecting the view to zoom
    func viewForZoomingInScrollView(scrollView: UIScrollView!) -> UIView! {
        switch currentPage {
        case 0:
            return wedding1
        case 1:
            return wedding2
        case 2:
            return wedding3
        case 3:
            return wedding4
        case 4:
            return wedding5
        default:
            return nil
        }
    }
    
    func scrollViewWillBeginZooming(scrollView: UIScrollView, withView view: UIView!) {
        wedding2.hidden = true
        wedding3.hidden = true
        wedding4.hidden = true
        wedding5.hidden = true
    }
    
    func scrollViewDidEndZooming(scrollView: UIScrollView, withView view: UIView!, atScale scale: CGFloat) {
        wedding2.hidden = false
        wedding3.hidden = false
        wedding4.hidden = false
        wedding5.hidden = false
    }
}
