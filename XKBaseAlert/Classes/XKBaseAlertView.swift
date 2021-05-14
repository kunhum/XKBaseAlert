//
//  XKBaseAlertView.swift
//  TestDemo
//
//  Created by mac on 2020/9/1.
//  Copyright © 2020 Nicholas. All rights reserved.
//

import UIKit

enum XKAlertViewAnimation {
    
    ///底部弹出指frame位置
    case sheet
    ///从frame位置弹出
    case alert
}

public class XKBaseAlertView: UIView {
    
    let SCREEN_WIDTH  = UIScreen.main.bounds.width
    let SCREEN_HEIGHT = UIScreen.main.bounds.height
    ///内容
    @IBOutlet weak var contentView: UIView? {
        didSet {
            guard let contentView = self.contentView else { return }
            
            if subviews.contains(contentView) == false {
                addSubview(contentView)
            }
        }
    }
    
    ///背景
    var backgroundView = UIView()
    ///可以指定superView， 默认为keyWindow
    weak var customSuperView: UIView? = UIApplication.shared.keyWindow!
    ///动画持续时间，alert方式弹出的时间是这个的2倍
    var animationDuration     = 0.35
    ///背景颜色的透明度
    var backgroundViewOpacity = 0.5
    ///点击空白处是否自动隐藏，默认为true
    var dismissWhenTouchBlank = true
    ///隐藏后是否自动移除，默认为true
    var removeAfterHidden: Bool = true
    ///动画，默认为sheet
    var animationType = XKAlertViewAnimation.sheet
    
    init() {
        super.init(frame: CGRect.zero)
        setupSubViews()
    }
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupSubViews()
    }
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    public override func awakeFromNib() {
        super.awakeFromNib()
        
        setupSubViews()
    }
    
    func setupSubViews() {
        
        backgroundColor = UIColor.clear
        
        addSubview(backgroundView)
        
        frame = CGRect(x: 0.0, y: 0.0, width: SCREEN_WIDTH, height: SCREEN_HEIGHT)
        
        backgroundView.backgroundColor = UIColor.black.withAlphaComponent(0.0)
        
    }
    
    public override func layoutSubviews() {
        super.layoutSubviews()
        
        backgroundView.frame = bounds
    }
    
    public override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        
        guard let touch = touches.first else { return }
        
        let point = touch.location(in: backgroundView)
        
        guard let contentView = self.contentView else {
            if dismissWhenTouchBlank {
                xk_dismiss()
            }
            return
        }
        
        //允许点击空白隐藏并且点击contentView外
        if dismissWhenTouchBlank && !contentView.frame.contains(point) {
            xk_dismiss()
        }
    }
    
}

//MARK: - 公共方法
extension XKBaseAlertView {
    
    //MARK: 显示
    func xk_show() {
        
        sendSubview(toBack: backgroundView)
        
        switch animationType {
        case .sheet:
            sheetShow()
        case .alert:
            alertShow()
        }
        
    }
    
    //MARK: 隐藏
    func xk_dismiss() {
        
        switch animationType {
        case .sheet:
            sheetDismiss()
        case .alert:
            alertDismiss()
        }
    }
    
}

//MARK: - 私有
extension XKBaseAlertView {
    
    //MARK: sheet方式弹出
    private func sheetShow() {
        
        guard let contentView = self.contentView else { return }
        
        let transform = CGAffineTransform(translationX: 0, y: frame.height - contentView.frame.minY)
        
        contentView.transform = transform
        
        customSuperView?.addSubview(self)
        
        UIView.animate(withDuration: animationDuration) {
            
            self.backgroundView.backgroundColor = UIColor.black.withAlphaComponent(CGFloat(self.backgroundViewOpacity))
            
            let rTransfrom = CGAffineTransform(translationX: 0.0, y: 0.0)
            contentView.transform = rTransfrom
        }
        
    }
    
    //MARK: alert方式弹出
    private func alertShow() {
        
        guard let contentView = self.contentView else { return }
        
        let transform = CGAffineTransform(scaleX: 0.1, y: 0.1)
        
        contentView.transform = transform
        
        customSuperView?.addSubview(self)
        
        UIView.animate(withDuration: animationDuration * 1.5, delay: 0.0, usingSpringWithDamping: 0.6, initialSpringVelocity: 0.0, options: .curveEaseInOut, animations: {
            
            self.backgroundView.backgroundColor = UIColor.black.withAlphaComponent(CGFloat(self.backgroundViewOpacity))
            
            let rTransfrom = CGAffineTransform(scaleX: 1.0, y: 1.0)
            contentView.transform = rTransfrom
            
        }) { (_) in }
        
    }
    
    //MARK: sheet方式隐藏
    private func sheetDismiss() {
        
        guard let contentView = self.contentView else { return }
        
        let transform = CGAffineTransform(translationX: 0.0, y: frame.height - contentView.frame.minY)
        
        UIView.animate(withDuration: animationDuration, animations: {
            
            self.backgroundView.backgroundColor = UIColor.black.withAlphaComponent(0.0)
            
            contentView.transform = transform
            
        }) { (finish) in
            
            if finish && self.removeAfterHidden {
                self.removeFromSuperview()
            }
        }
        
    }
    
    //MARK: alert方式隐藏
    private func alertDismiss() {
        
        guard let contentView = self.contentView else { return }
        
        let transform = CGAffineTransform(scaleX: 0.01, y: 0.01)
        
        UIView.animate(withDuration: animationDuration, animations: {
            
            self.backgroundView.backgroundColor = UIColor.black.withAlphaComponent(0.0)
            
            contentView.transform = transform
            
        }) { (finish) in
            
            if finish && self.removeAfterHidden {
                self.removeFromSuperview()
            }
        }
        
    }
    
}
