//
//  HomeFeedViewController.swift
//  Hu-Facebook
//
//  Created by Hi_Hu on 2/24/15.
//  Copyright (c) 2015 hi_hu. All rights reserved.
//

import UIKit

class HomeFeedViewController: UIViewController, UIViewControllerAnimatedTransitioning, UIViewControllerTransitioningDelegate, UIScrollViewDelegate {

    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var homeFeedImage: UIImageView!
    @IBOutlet weak var wedding1: UIImageView!
    @IBOutlet weak var wedding2: UIImageView!
    @IBOutlet weak var wedding3: UIImageView!
    @IBOutlet weak var wedding4: UIImageView!
    @IBOutlet weak var wedding5: UIImageView!
    
    var selectedImageView: UIImageView!
    var isPresenting: Bool = true
    var pageIndex: Int!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        scrollView.contentSize = homeFeedImage.frame.size
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func imageDidTap(sender: UITapGestureRecognizer) {
        selectedImageView = sender.view as UIImageView
        
        // determine which image was selected
        if(selectedImageView.isEqual(wedding1)) {
            pageIndex = 0
        } else if(selectedImageView.isEqual(wedding2)) {
            pageIndex = 1
        } else if(selectedImageView.isEqual(wedding3)) {
            pageIndex = 2
        } else if(selectedImageView.isEqual(wedding4)) {
            pageIndex = 3
        } else {
            pageIndex = 4
        }

        performSegueWithIdentifier("photoSegue", sender: self)
    }

    /* Custom Transition Animations
    ----------------------------------------------------------------------------*/
    
    // transition delegate methods
    func animationControllerForPresentedController(presented: UIViewController!, presentingController presenting: UIViewController!, sourceController source: UIViewController!) -> UIViewControllerAnimatedTransitioning! {
        isPresenting = true
        return self
    }

    // transition delegate methods
    func animationControllerForDismissedController(dismissed: UIViewController!) -> UIViewControllerAnimatedTransitioning! {
        isPresenting = false
        return self
    }
    
    // The value here should be the duration of the animations scheduled in the animationTransition method
    func transitionDuration(transitionContext: UIViewControllerContextTransitioning) -> NSTimeInterval {
        return 0.4
    }
    
    // the methods that actually control the transitions
    func animateTransition(transitionContext: UIViewControllerContextTransitioning) {
        
        // unque values to transitions
        var containerView = transitionContext.containerView()
        var toViewController = transitionContext.viewControllerForKey(UITransitionContextToViewControllerKey)!
        var fromViewController = transitionContext.viewControllerForKey(UITransitionContextFromViewControllerKey)!

        // getting the position and size of the frame from selectedImageView
        var newFrame = containerView.convertRect(selectedImageView.frame, fromView: scrollView)

        // present transition animation
        if (isPresenting) {
            
            var photoViewController = toViewController as PhotoViewController
            var endFrame = photoViewController.endFrame
            
            containerView.addSubview(toViewController.view)
            
            // set all the transitions before hand
            toViewController.view.alpha = 0
            selectedImageView.hidden = true
            
            // hide all the images
            photoViewController.wedding1.hidden = true
            photoViewController.wedding2.hidden = true
            photoViewController.wedding3.hidden = true
            photoViewController.wedding4.hidden = true
            photoViewController.wedding5.hidden = true
            
            // making a copy of the selected image view and setting the same size
            var movingImageView = UIImageView(image: selectedImageView.image)
            
            movingImageView.frame = newFrame                                    // position & size
            movingImageView.contentMode = selectedImageView.contentMode         // e.g. aspect fill
            movingImageView.clipsToBounds = selectedImageView.clipsToBounds     // bool value for clipping
            containerView.addSubview(movingImageView)

            UIView.animateWithDuration(0.5, animations: { () -> Void in
                
                toViewController.view.alpha = 1
                
                // animating the copy of selectedImageView image to the photoViewController size and position
                movingImageView.frame = endFrame
                
            }) { (finished: Bool) -> Void in
                transitionContext.completeTransition(true)
                movingImageView.removeFromSuperview()
                self.selectedImageView.hidden = false
                
                // show all the images
                photoViewController.wedding1.hidden = false
                photoViewController.wedding2.hidden = false
                photoViewController.wedding3.hidden = false
                photoViewController.wedding4.hidden = false
                photoViewController.wedding5.hidden = false
            }
        
        // dismiss transition animation
        } else {    
            
            // to and from during the transition are different
            var photoViewController = fromViewController as PhotoViewController
            
            // making a copy of the image based on paging and setting the same size and frame
            var movingImageView = UIImageView()

            switch photoViewController.currentPage {
            case 0:
                movingImageView = UIImageView(image: photoViewController.wedding1.image)
                newFrame = containerView.convertRect(wedding1.frame, fromView: scrollView)
            case 1:
                movingImageView = UIImageView(image: photoViewController.wedding2.image)
                newFrame = containerView.convertRect(wedding2.frame, fromView: scrollView)
            case 2:
                movingImageView = UIImageView(image: photoViewController.wedding3.image)
                newFrame = containerView.convertRect(wedding3.frame, fromView: scrollView)
            case 3:
                movingImageView = UIImageView(image: photoViewController.wedding4.image)
                newFrame = containerView.convertRect(wedding4.frame, fromView: scrollView)
            case 4:
                movingImageView = UIImageView(image: photoViewController.wedding5.image)
                newFrame = containerView.convertRect(wedding5.frame, fromView: scrollView)
            default:
                break
            }
            
            movingImageView.frame = photoViewController.scrolledPhotoFrame      // position & size
            movingImageView.contentMode = selectedImageView.contentMode         // e.g. aspect fill
            movingImageView.clipsToBounds = selectedImageView.clipsToBounds     // bool value for clipping
            containerView.addSubview(movingImageView)
            
            UIView.animateWithDuration(0.5, animations: { () -> Void in
                
                fromViewController.view.alpha = 0
                
                // animating the copy of photoViewController image back to the selectedImageView size and position
                movingImageView.frame = newFrame
                
            }) { (finished: Bool) -> Void in
                transitionContext.completeTransition(true)
                fromViewController.view.removeFromSuperview()
                movingImageView.removeFromSuperview()
                self.selectedImageView.hidden = false
            }
        }
    }
    //-----------------------------------------------------------------------------
    
    // MARK: - Navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        var destinationViewController = segue.destinationViewController as PhotoViewController

        // calculating the size and position of the final frame size and position of the image in photoViewController
        var frameHeight = (320 * selectedImageView.image!.size.height) / selectedImageView.image!.size.width
        var endFrame = CGRect(x: 0, y: (view.frame.size.height - frameHeight) / 2, width: 320, height: frameHeight )
        
        // passing the photo and end frame data to photoViewController
        destinationViewController.w1 = wedding1.image
        destinationViewController.w2 = wedding2.image
        destinationViewController.w3 = wedding3.image
        destinationViewController.w4 = wedding4.image
        destinationViewController.w5 = wedding5.image
        destinationViewController.endFrame = endFrame
        destinationViewController.pageIndex = pageIndex

        destinationViewController.modalPresentationStyle = UIModalPresentationStyle.Custom
        destinationViewController.transitioningDelegate = self
    }
}
