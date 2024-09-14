//
//  XKAlertContainerViewController.swift
//  Pods
//
//  Created by Nicholas on 2020/5/26.
//

import UIKit

open class XKAlertContainerViewController: UIViewController {
    
    typealias XKAlertContainerViewControllerHandler = () -> Void
    
    ///内容视图
    @IBOutlet public var contentView: UIView?
    ///动画时间
    public var animationDuration = 0.5
    //消失动画时间
    public var dismissAnimationDuration = 0.25
    ///风格
    @objc public var style = XKAlertStyle.alert
    ///default is UIBlurEffectStyleDark
    public var effectStyle = UIBlurEffect.Style.dark
    ///必须指定
    public var frameOfPresentedView = UIApplication.shared.keyWindow?.bounds
    ///遮罩的透明度,默认0.5
    public var maskViewAlpha: CGFloat = 0.5
    ///点击contentView以外区域dismiss，默认为yes，在确认给contentView赋值后才会生效
    public var dismissWhenTapOutsideContentView = true
    
    ///弹框即将显示时执行所需要的操作
    private var presentationTransitionWillBeginHandler: XKAlertContainerViewControllerHandler?
    ///弹框显示完毕时执行所需要的操作
    private var presentationTransitionDidEndHandler: XKAlertContainerViewControllerHandler?
    ///弹框即将消失时执行所需要的操作
    private var dismissalTransitionWillBeginHandler: XKAlertContainerViewControllerHandler?
    ///弹框消失之后执行所需要的操作
    private var dismissalTransitionDidEndHandler: XKAlertContainerViewControllerHandler?
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        initMethod()
    }
    required public init?(coder: NSCoder) {
        super.init(coder: coder)
        initMethod()
    }
    public static func defaultController() -> Self? {
        let vc = Self() as XKAlertContainerViewController
        vc.initMethod()
        return vc as? Self
    }
    
    public class func instance() -> Self {
        let vc = Self() as XKAlertContainerViewController
        vc.initMethod()
        return vc as! Self
    }
    
    public init(style: XKAlertStyle = .alert) {
        self.init()
        self.style = style
        initMethod()
    }
    
    open override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        view.backgroundColor = UIColor.clear
    }
    
    func initMethod() {
        
        transitioningDelegate  = self
        modalPresentationStyle = .custom
    }
    
    public override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        guard dismissWhenTapOutsideContentView else {
            return
        }
        guard let contentView = self.contentView else { return }
        guard let touch = touches.first else { return }
        
        let point = touch.location(in: view)
        let containPoint = contentView.frame.contains(point)
        guard containPoint == false else { return }
        
        dismiss(animated: true, completion: nil)
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

extension XKAlertContainerViewController: UIViewControllerTransitioningDelegate {
    
    public func presentationController(forPresented presented: UIViewController, presenting: UIViewController?, source: UIViewController) -> UIPresentationController? {
        
        let presentController = XKAlertPresentController.init(presentedViewController: presented, presenting: presenting)
        
        presentController.maskViewAlpha        = maskViewAlpha
        presentController.effectStyle          = effectStyle
        presentController.frameOfPresentedView = frameOfPresentedView
        presentController.animationDuration    = animationDuration
        
        return presentController
    }
    
    public func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        let transition = XKTransition()
        transition.style             = style
        transition.animationDuration = animationDuration
        return transition
    }
    
    public func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        let transition = XKTransition()
        transition.style             = style
        transition.isDismissed       = true
        transition.animationDuration = dismissAnimationDuration
        return transition
    }
    
}
