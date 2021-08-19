//
//  XKTransition.swift
//  XKBaseAlert
//
//  Created by kenneth on 2021/8/19.
//

import UIKit

public enum XKAlertStyle {
    case sheet
    case alert
}

class XKTransition: NSObject, UIViewControllerAnimatedTransitioning {
    
    public var animationDuration = 0.5
    public var style = XKAlertStyle.sheet
    public var isDismissed = false
    
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return animationDuration
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        
        guard isDismissed == false else {
            dismiss(transitionContext: transitionContext)
            return
        }
        
        display(transitionContext: transitionContext)
    }

}

//MARK: - display
extension XKTransition {
    
    func display(transitionContext: UIViewControllerContextTransitioning) {
        
        let containerView = transitionContext.containerView
        
        guard let toView = transitionContext.view(forKey: .to), let toVC = transitionContext.viewController(forKey: .to) as? XKAlertContainerViewController else { return }
        
        toView.frame = containerView.bounds
        
        containerView.addSubview(toView)
        
        guard let contentView = toVC.contentView else { return }
        
        switch style {
        case .sheet:
            sheet(contentView: contentView, containerView: containerView, transitionContext: transitionContext)
        case .alert:
            alert(contentView: contentView, containerView: containerView, transitionContext: transitionContext)
        }
    }
    
    func sheet(contentView: UIView, containerView: UIView, transitionContext: UIViewControllerContextTransitioning) {
        
        let y = containerView.bounds.maxY - contentView.bounds.midY
        
        var transform = CGAffineTransform(translationX: 0.0, y: y)
        
        contentView.transform = transform
        
        UIView.animate(withDuration: animationDuration, delay: 0.0, usingSpringWithDamping: 0.8, initialSpringVelocity: 0.0, options: .curveEaseInOut) {
            
            transform             = CGAffineTransform.identity
            contentView.transform = transform
            
        } completion: { _ in
            
            transitionContext.completeTransition(true)
        }
    }
    
    func alert(contentView: UIView, containerView: UIView, transitionContext: UIViewControllerContextTransitioning) {
        
        var transform = CGAffineTransform(scaleX: 0.0, y: 0.0)
        contentView.transform = transform
        contentView.alpha     = 0.0
        
        UIView.animate(withDuration: animationDuration, delay: 0.0, usingSpringWithDamping: 0.6, initialSpringVelocity: 0.0, options: .curveEaseInOut) {
            
            transform             = CGAffineTransform(scaleX: 1.0, y: 1.0)
            contentView.transform = transform
            contentView.alpha     = 1.0
            
        } completion: { _ in
            
            transitionContext.completeTransition(true)
        }

    }
}

//MARK: - dismiss
extension XKTransition {
    
    func dismiss(transitionContext: UIViewControllerContextTransitioning) {
        
        let containerView = transitionContext.containerView
        
        guard let fromVC = transitionContext.viewController(forKey: .from) as? XKAlertContainerViewController, let contentView = fromVC.contentView else { return }
        
        switch style {
        case .alert:
            alertDismiss(transitionContext: transitionContext, contentView: contentView)
        case .sheet:
            sheetDismiss(transitionContext: transitionContext, contentView: contentView, containerView: containerView)
        }
    }
    
    func sheetDismiss(transitionContext: UIViewControllerContextTransitioning, contentView: UIView, containerView: UIView) {
        
        let y = containerView.bounds.maxY - contentView.bounds.midY
        
        let transform = CGAffineTransform(translationX: 0.0, y: y)
        
        UIView.animate(withDuration: animationDuration) {
            contentView.alpha     = 0.0
            contentView.transform = transform
        } completion: { _ in
            transitionContext.completeTransition(true)
        }

    }
    
    func alertDismiss(transitionContext: UIViewControllerContextTransitioning, contentView: UIView) {
        
        UIView.animate(withDuration: animationDuration) {
            
            contentView.alpha     = 0.0
            contentView.transform = CGAffineTransform(scaleX: 0.5, y: 0.5)
            
        } completion: { _ in
            transitionContext.completeTransition(true)
        }
        
    }
}
