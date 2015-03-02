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
    
    var selectedImageView: UIImageView!
    var isPresenting: Bool = true
    
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
            photoViewController.photoImageView.hidden = true
            
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
                photoViewController.photoImageView.hidden = false
            }
        
        // dismiss transition animation
        } else {    
            
            // to and from during the transition are different
            var photoViewController = fromViewController as PhotoViewController
            
            // making a copy of the opened image view and setting the same size and frame
            var movingImageView = UIImageView(image: photoViewController.photoImageView.image)
            
            movingImageView.frame = photoViewController.scrolledPhotoFrame   // position & size
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
        
        // passing the phot and end frame data to photoViewController
        destinationViewController.photoImage = self.selectedImageView.image
        destinationViewController.endFrame = endFrame

        destinationViewController.modalPresentationStyle = UIModalPresentationStyle.Custom
        destinationViewController.transitioningDelegate = self
    }
}
