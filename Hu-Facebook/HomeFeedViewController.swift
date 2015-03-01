//
//  HomeFeedViewController.swift
//  Hu-Facebook
//
//  Created by Hi_Hu on 2/24/15.
//  Copyright (c) 2015 hi_hu. All rights reserved.
//

import UIKit

class HomeFeedViewController: UIViewController, UIViewControllerAnimatedTransitioning, UIViewControllerTransitioningDelegate {

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
    
    //-----------------------------------------------------------------------------
    ////// transition delegate methods
    func animationControllerForPresentedController(presented: UIViewController!, presentingController presenting: UIViewController!, sourceController source: UIViewController!) -> UIViewControllerAnimatedTransitioning! {
        isPresenting = true
        return self
    }
    
    func animationControllerForDismissedController(dismissed: UIViewController!) -> UIViewControllerAnimatedTransitioning! {
        isPresenting = false
        return self
    }
    
    ////// the methods that actually control the transitions
    func transitionDuration(transitionContext: UIViewControllerContextTransitioning) -> NSTimeInterval {
        // The value here should be the duration of the animations scheduled in the animationTransition method
        return 0.4
    }
    
    func animateTransition(transitionContext: UIViewControllerContextTransitioning) {
        var containerView = transitionContext.containerView()
        var toViewController = transitionContext.viewControllerForKey(UITransitionContextToViewControllerKey)!
        var fromViewController = transitionContext.viewControllerForKey(UITransitionContextFromViewControllerKey)!
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

            movingImageView.frame = newFrame                                // what is the position
            movingImageView.contentMode = selectedImageView.contentMode     // what is the aspect
            movingImageView.clipsToBounds = selectedImageView.clipsToBounds // what is the clipping
            containerView.addSubview(movingImageView)
            UIView.animateWithDuration(0.5, animations: { () -> Void in
                
                toViewController.view.alpha = 1
                movingImageView.frame = endFrame //photoViewController.photoImageView.frame
                
            }) { (finished: Bool) -> Void in
                transitionContext.completeTransition(true)
                self.selectedImageView.hidden = false
                movingImageView.removeFromSuperview()
                photoViewController.photoImageView.hidden = false
            }
        
        // dismiss transition animation
        } else {
            
            // to and from during the transition are different
            var photoViewController = fromViewController as PhotoViewController
            
            // making a copy of the opened image view and setting the same size
            var movingImageView = UIImageView(image: photoViewController.photoImageView.image)
            
            movingImageView.frame = photoViewController.photoImageView.frame                // what is the position
            movingImageView.contentMode = selectedImageView.contentMode     // what is the aspect
            movingImageView.clipsToBounds = selectedImageView.clipsToBounds // what is the clipping
            containerView.addSubview(movingImageView)
            
            UIView.animateWithDuration(0.5, animations: { () -> Void in
                
                fromViewController.view.alpha = 0
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

    // In a storyboard-based application, you will often want to do a little preparation before navigation

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // calculating the size
        var frameHeight = (320 * selectedImageView.image!.size.height) / selectedImageView.image!.size.width
        var endFrame = CGRect(x: 0, y: (view.frame.size.height - frameHeight) / 2, width: 320, height: frameHeight )
        var destinationViewController = segue.destinationViewController as PhotoViewController
        
        destinationViewController.photoImage = self.selectedImageView.image
        destinationViewController.endFrame = endFrame

        destinationViewController.modalPresentationStyle = UIModalPresentationStyle.Custom
        destinationViewController.transitioningDelegate = self
    }
}
