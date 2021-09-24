//
//  XKAlertPresentController.swift
//  Pods-XKBaseAlert_Example
//
//  Created by Nicholas on 2020/5/26.
//

import UIKit

open class XKAlertPresentController: UIPresentationController {
    
    typealias XKAlertPresentControllerHandler = () -> Void
    
    public var animationDuration = 0.5
    
    ///default is UIBlurEffectStyleDark
    public var effectStyle = UIBlurEffectStyle.dark
    ///必须指定
    public var frameOfPresentedView = UIApplication.shared.keyWindow?.bounds
    ///遮罩的透明度,默认0.5
    public var maskViewAlpha: CGFloat = 0.5
    ///背景view
    public let backgroundView = UIView()
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
    override public var frameOfPresentedViewInContainerView: CGRect {
        return frameOfPresentedView ?? CGRect.zero
    }
    //MARK: 重写此方法可以在弹框即将显示时执行所需要的操作
    public override func presentationTransitionWillBegin() {
        super.presentationTransitionWillBegin()
        
        guard let containerBounds      = frameOfPresentedView else { return }
        backgroundView.frame           = containerBounds
        backgroundView.backgroundColor = UIColor.black.withAlphaComponent(0)
        containerView?.frame           = containerBounds;
        containerView?.addSubview(backgroundView)
        
        UIView.animate(withDuration: animationDuration) {
            
            self.backgroundView.backgroundColor = UIColor.black.withAlphaComponent(self.maskViewAlpha)
        }
        
        presentationTransitionWillBeginHandler?()
        
    }
    //MARK: 重写此方法可以在弹框显示完毕时执行所需要的操作
    public override func presentationTransitionDidEnd(_ completed: Bool) {
        super.presentationTransitionDidEnd(completed)
        presentationTransitionDidEndHandler?()
    }
    
    //MARK: 重写此方法可以在弹框即将消失时执行所需要的操作
    public override func dismissalTransitionWillBegin() {
        super.dismissalTransitionWillBegin()
        
        UIView.animate(withDuration: animationDuration) {
            self.backgroundView.backgroundColor = UIColor.black.withAlphaComponent(0.0)
        }
        dismissalTransitionWillBeginHandler?()
    }
    //MARK: 重写此方法可以在弹框消失之后执行所需要的操作
    public override func dismissalTransitionDidEnd(_ completed: Bool) {
        super.dismissalTransitionDidEnd(completed)
        
        dismissalTransitionDidEndHandler?()
    }
    
}
