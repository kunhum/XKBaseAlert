//
//  XKAlertPresentController.swift
//  Pods-XKBaseAlert_Example
//
//  Created by Nicholas on 2020/5/26.
//

import UIKit

class XKAlertPresentController: UIPresentationController {
    
    typealias XKAlertPresentControllerHandler = () -> Void
    
    var animationDuration = 0.5
    
    ///default is UIBlurEffectStyleDark
    var effectStyle = UIBlurEffectStyle.dark
    ///必须指定
    var frameOfPresentedView = UIApplication.shared.keyWindow?.bounds
    ///遮罩的透明度,默认0.5
    var maskViewAlpha: CGFloat = 0.5
    ///背景view
    let backgroundView = UIView()
    ///弹框即将显示时执行所需要的操作
    private var presentationTransitionWillBeginHandler: XKAlertPresentControllerHandler?
    ///弹框显示完毕时执行所需要的操作
    private var presentationTransitionDidEndHandler: XKAlertPresentControllerHandler?
    ///弹框即将消失时执行所需要的操作
    private var dismissalTransitionWillBeginHandler: XKAlertPresentControllerHandler?
    ///弹框消失之后执行所需要的操作
    private var dismissalTransitionDidEndHandler: XKAlertPresentControllerHandler?
    
    
}

extension XKAlertPresentController {
    
    //MARK: - 接口
    
    //MARK: 弹框即将显示时执行所需要的操作
    func xk_presentationTransitionWillBegin(handler: XKAlertPresentControllerHandler?) {
        presentationTransitionWillBeginHandler = handler
    }
    //MARK: 弹框显示完毕时执行所需要的操作
    func xk_presentationTransitionDidEnd(handler: XKAlertPresentControllerHandler?) {
        presentationTransitionDidEndHandler = handler
    }
    //MARK: 弹框即将消失时执行所需要的操作
    func xk_dismissalTransitionWillBegin(handler: XKAlertPresentControllerHandler?) {
        dismissalTransitionWillBeginHandler = handler
    }
    //MARK: 弹框消失之后执行所需要的操作
    func xk_dismissalTransitionDidEnd(handler: XKAlertPresentControllerHandler?) {
        dismissalTransitionDidEndHandler = handler
    }
    
}

extension XKAlertPresentController {
    
    //MARK: - override
    
    //MARK: 决定了弹出框的frame
    override var frameOfPresentedViewInContainerView: CGRect {
        return frameOfPresentedView ?? CGRect.zero
    }
    //MARK: 重写此方法可以在弹框即将显示时执行所需要的操作
    override func presentationTransitionWillBegin() {
        super.presentationTransitionWillBegin()
        
        guard let containerBounds      = containerView?.bounds else { return }
        backgroundView.frame           = containerBounds
        backgroundView.backgroundColor = UIColor.black.withAlphaComponent(0)
        containerView?.addSubview(backgroundView)
        
        UIView.animate(withDuration: animationDuration) {
            
            self.backgroundView.backgroundColor = UIColor.black.withAlphaComponent(self.maskViewAlpha)
        }
        
        presentationTransitionWillBeginHandler?()
        
    }
    //MARK: 重写此方法可以在弹框显示完毕时执行所需要的操作
    override func presentationTransitionDidEnd(_ completed: Bool) {
        super.presentationTransitionDidEnd(completed)
        
        presentationTransitionDidEndHandler?()
    }
    //MARK: 重写此方法可以在弹框即将消失时执行所需要的操作
    override func dismissalTransitionWillBegin() {
        super.dismissalTransitionWillBegin()
        
        UIView.animate(withDuration: animationDuration) {
            self.backgroundView.backgroundColor = UIColor.black.withAlphaComponent(0.0)
        }
        dismissalTransitionWillBeginHandler?()
    }
    //MARK: 重写此方法可以在弹框消失之后执行所需要的操作
    override func dismissalTransitionDidEnd(_ completed: Bool) {
        super.dismissalTransitionDidEnd(completed)
        
        dismissalTransitionDidEndHandler?()
    }
    
}
