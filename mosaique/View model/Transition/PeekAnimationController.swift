//
//  PeekAnimationController.swift
//  mosaique
//
//  Created by Klemen Zagar on 27/03/2019.
//  Copyright © 2019 Klemen Zagar. All rights reserved.
//

import UIKit

class PeekAnimationController: NSObject, UIViewControllerAnimatedTransitioning {
  
  private let presenting: Bool
  private let sourceTile: UIView
  
  func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
    return 0.45
  }
  
  func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
    let container = transitionContext.containerView
    let duration = transitionDuration(using: transitionContext)
    
    guard let toVC = transitionContext.viewController(forKey: .to) as? PeekTransitionController else { return }
    
    let toView = toVC.view!
    toView.layoutIfNeeded()
    container.addSubview(toView)
    let background = toVC.transitionBackground()
    let contentView = toVC.transitionContentView()
    let tileView = sourceTile.snapshotView(afterScreenUpdates: false)!
    tileView.layer.masksToBounds = true
    tileView.layer.cornerRadius = toVC.peekView().layer.cornerRadius
    tileView.frame = sourceTile.frameInWindowsCoordinateSystem()
    let finalFrame = toVC.peekView().frameInWindowsCoordinateSystem()
    contentView.transform = CGAffineTransform(scaleX: 3, y: 3)
    
    if presenting {
      container.addSubview(tileView)
      toVC.peekView().alpha = 0.0
      background.alpha = 0.0
    } else {
    }
    
    
    
    UIView.animate(withDuration: duration*4.0/5, delay: 0.0, options: [], animations: {
      tileView.frame = finalFrame
      background.alpha = 1.0
      contentView.transform = CGAffineTransform.identity
    })
    { _ in
      toVC.peekView().alpha = 1.0
    }
    UIView.animate(withDuration: duration*1/5, delay: duration*4/5, options: [], animations: {
      tileView.alpha = 0.0
    })
    { _ in
      tileView.removeFromSuperview()
      let success = !transitionContext.transitionWasCancelled
      transitionContext.completeTransition(success)
    }
  }
  
  init(presenting: Bool, sourceTile: UIView) {
    self.presenting = presenting
    self.sourceTile = sourceTile
  }
}





class PeekDismissAnimationController: NSObject, UIViewControllerAnimatedTransitioning {
  
  private let finalView: UIView
  
  func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
    return 0.40
  }
  
  func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
    let container = transitionContext.containerView
    let duration = transitionDuration(using: transitionContext)
    
    guard let fromVC = transitionContext.viewController(forKey: .from) as? PeekTransitionController else { return }
    
    let fromView = fromVC.view!
    fromView.layoutIfNeeded()
    container.addSubview(fromView)
    let background = fromVC.transitionBackground()
    let contentView = fromVC.transitionContentView()
    let tileView = fromVC.peekView().snapshotView(afterScreenUpdates: false)!
    tileView.frame = fromVC.peekView().frameInWindowsCoordinateSystem()
    fromVC.peekView().isHidden = true
    let finalFrame = finalView.frameInWindowsCoordinateSystem()
    
    tileView.layer.cornerRadius = fromVC.peekView().layer.cornerRadius
    
    
    container.addSubview(tileView)
    
    
    
    UIView.animate(withDuration: duration*4.0/5, delay: 0.0, options: [], animations: {
      tileView.frame = finalFrame
      background.alpha = 0.0
      contentView.transform = CGAffineTransform(scaleX: 3, y: 3)
    })
    
    UIView.animate(withDuration: duration*1/5, delay: duration*4/5, options: [], animations: {
      tileView.alpha = 0.0
    })
    { _ in
      tileView.removeFromSuperview()
      let success = !transitionContext.transitionWasCancelled
      transitionContext.completeTransition(success)
    }
  }
  
  init(finalView: UIView) {
    self.finalView = finalView
  }
  
}

typealias PeekTransitionController = UIViewController & PeekTransition
protocol PeekTransition: class {
  func transitionBackground() -> UIView
  func transitionContentView() -> UIView
  func peekView() -> UIView
  func headerview() -> UIView
}

extension UIView {
  func frameInWindowsCoordinateSystem() -> CGRect {
    if let superview = superview {
      return superview.convert(frame, to: nil)
    }
    print("[ANIMATION WARNING] Seems like this view is not in views hierarchy\n\(self)\nOriginal frame returned")
    return frame
  }
}


extension UIImage {
  convenience init(view: UIView) {
    UIGraphicsBeginImageContextWithOptions(view.bounds.size, view.isOpaque, 0.0)
    view.drawHierarchy(in: view.bounds, afterScreenUpdates: false)
    let image = UIGraphicsGetImageFromCurrentImageContext()
    UIGraphicsEndImageContext()
    self.init(cgImage: (image?.cgImage)!)
    
  }
}
