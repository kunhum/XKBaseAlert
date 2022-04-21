//
//  UIViewControllerEntension.swift
//  Health
//
//  Created by Nicholas on 2020/4/19.
//  Copyright © 2020 Nicholas. All rights reserved.
//

import Foundation
import UIKit
import SwifterSwift

public extension UIViewController {
    /// 导航栏黑线
    var barBlackLine: UIView? {
        guard let bar = navigationController?.navigationBar else {
            return nil
        }
        return findBlackLine(view: bar)
    }

    // MARK: 从storyboard中获取控制器
    @objc static func xk_initFromStoryBoard(storyboardName: String, bundle: Bundle? = nil) -> UIViewController {

        let sb = UIStoryboard(name: storyboardName, bundle: bundle)
        return sb.instantiateViewController(withIdentifier: xk_className)
    }
    // MARK: 从xib中获取控制器，swift
    @objc static func xk_initFromXIB(bundle: Bundle? = nil) -> UIViewController {

        return self.init(nibName: xk_className, bundle: bundle)
    }
    // MARK: 获取退顶层present过来的controller
    @objc func xk_topPresentingViewController(controller: UIViewController) -> UIViewController {

        if let presentingVC = controller.presentingViewController {
            return xk_topPresentingViewController(controller: presentingVC)
        } else {
            return controller
        }
    }
    // MARK: 隐藏导航栏
    @objc func xk_hideNagationBar() {
        navigationController?.setNavigationBarHidden(true, animated: true)
    }
    // MARK: 显示导航栏
    @objc func xk_showNavigationBar() {
        navigationController?.setNavigationBarHidden(false, animated: true)
    }
    // MARK: 透明导航栏
    @objc func xk_setClearNavigationBar() {

        guard #available(iOS 15.0, *) else {
            let image = UIImage.init(color: UIColor.white.withAlphaComponent(0.0), size: CGSize(width: 1.0, height: 1.0))
            navigationController?.navigationBar.setBackgroundImage(image, for: .default)
            barBlackLine?.isHidden = true
            return
        }

        xk_setApprance(backgroundColor: .clear)
    }
    // MARK: 重置导航栏
    @objc func xk_resetNavigationBar() {

        guard #available(iOS 15.0, *) else {
            barBlackLine?.isHidden = false
            navigationController?.navigationBar.setBackgroundImage(nil, for: .default)
            navigationController?.navigationBar.barTintColor = UIColor.white
            return
        }

        xk_setApprance(backgroundColor: .white)
    }

    // MARK: 设置控制器外观
    @objc func xk_setApprance(backgroundColor: UIColor = .white, shadowColor: UIColor = .clear) {

        guard #available(iOS 15.0, *) else { return }

        guard let navigationBar = navigationController?.navigationBar else { return }

        let appearance = UINavigationBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor         = backgroundColor
        appearance.shadowColor             = shadowColor
        navigationBar.standardAppearance   = appearance
        navigationBar.scrollEdgeAppearance = appearance
    }

    // MARK: 显示导航栏下的黑线
    func xk_showNavigationBarBlackLine() {
        guard navigationController?.navigationBar != nil else {
            return
        }
        barBlackLine?.isHidden = false
    }
    // MARK: 隐藏导航栏下的黑线
    func xk_hideNavigationBarBlackLine() {
        guard navigationController?.navigationBar != nil else {
            return
        }
        barBlackLine?.isHidden = true
    }

    private func findBlackLine(view: UIView) -> UIView? {

        if view.isKind(of: UIImageView.self) && view.bounds.height <= 1.0 {
            return view
        }
        for subView in view.subviews {
            let imageView = findBlackLine(view: subView)
            if imageView != nil {
                return imageView
            }
        }
        return nil
    }

}
