//
//  TZYKNormalAlertController.swift
//  Pods
//
//  Created by kenneth on 2022/3/15.
//

import UIKit
import XKCategorySwift
import SnapKit

public class TZYKNormalAlertController: XKAlertContainerViewController {
    
    public typealias TZYKNormalAlertLayoutTuple = (contentView: UIView,
                                                   titleLabel: UILabel,
                                                   topLine: UIView,
                                                   contentLabel: UILabel,
                                                   bottomLine: UIView,
                                                   leftButton: UIButton,
                                                   rightButton: UIButton,
                                                   topStackView: UIStackView,
                                                   buttonStackView: UIStackView)
    
    public typealias TZYKNormalAlertUILayoutClosure = ((_ tuple: TZYKNormalAlertLayoutTuple) -> Void)
    
    lazy var contentContainer = createContentContainer()
    ///顶部容器
    lazy var contentStackView: UIStackView = createContentStackView()
    ///按钮的容器，默认有两个按钮，需要增加的话自己往该容器上加
    lazy var buttonStackView: UIStackView = createButtonStackView()
    lazy var titleLabel: UILabel = createTitleLabel()
    ///标题和内容的分割线
    lazy var topLine: UIView = createTopLine()
    lazy var contentLabel: UILabel = createContentLabel()
    ///内容和按钮的分割线
    lazy var bottomLine: UIView = createBottomLine()
    lazy var leftButton: UIButton = createLeftButton()
    lazy var rightButton: UIButton = createRightButton()
    
    var layoutClosure: TZYKNormalAlertUILayoutClosure?

    public override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
        
        layoutClosure?((contentContainer, titleLabel, topLine, contentLabel, bottomLine, leftButton, rightButton, contentStackView, buttonStackView))
        titleLabel.superview?.isHidden   = titleLabel.isHidden
        topLine.superview?.isHidden      = topLine.isHidden
        contentLabel.superview?.isHidden = contentLabel.isHidden
        bottomLine.superview?.isHidden   = bottomLine.isHidden
    }
    
}

public extension TZYKNormalAlertController {
    
    /// 初始化
    /// - Parameter layoutClosure: 布局，可通过子视图的snp修改
    /// buttonStackView: 按钮的容器，默认有两个按钮，需要增加的话自己往该容器上加。
    /// - Returns: 控制器
    class func initController(layoutClosure: TZYKNormalAlertUILayoutClosure?) -> UIViewController? {
        let vc = TZYKNormalAlertController.defaultController()
        vc?.layoutClosure = layoutClosure
        return vc
    }
}

fileprivate extension TZYKNormalAlertController {
    
    func createContentContainer() -> UIView {
        let contentContainer = UIView()
        contentContainer.backgroundColor = .white
        contentContainer.layer.cornerRadius = 12.0
        return contentContainer
    }
    func createContentStackView() -> UIStackView {
        let contentStackView = UIStackView()
        contentStackView.axis    = .vertical
        contentStackView.spacing = 0.0
        return contentStackView
    }
    func createButtonStackView() -> UIStackView {
        let buttonStackView = UIStackView()
        buttonStackView.axis         = .horizontal
        buttonStackView.spacing      = 0.0
        return buttonStackView
    }
    func createTitleLabel() -> UILabel {
        let titleLabel = UILabel()
        titleLabel.text      = "标题"
        titleLabel.textColor = UIColor(hexString: "333333")
        titleLabel.font      = UIFont.xk_pingFangSC(size: 18.0, name: .medium)
        return titleLabel
    }
    func createTopLine() -> UIView {
        let topLine = UIView()
        topLine.backgroundColor = UIColor(hexString: "#F2F2F2")
        return topLine
    }
    func createContentLabel() -> UILabel {
        let contentLabel = UILabel()
        contentLabel.text      = "内容"
        contentLabel.textColor = UIColor(hexString: "333333")
        contentLabel.font      = UIFont.xk_pingFangSC(size: 18.0, name: .medium)
        return contentLabel
    }
    func createBottomLine() -> UIView {
        let bottomLine = UIView()
        bottomLine.backgroundColor = UIColor(hexString: "#F2F2F2")
        return bottomLine
    }
    func createLeftButton() -> UIButton {
        let leftButton = UIButton(type: .custom)
        leftButton.backgroundColor = .clear
        leftButton.setTitle("左", for: .normal)
        leftButton.setTitleColor(UIColor(hexString: "333333"), for: .normal)
        return leftButton
    }
    func createRightButton() -> UIButton {
        let rightButton = UIButton(type: .custom)
        rightButton.backgroundColor = .clear
        rightButton.setTitle("右", for: .normal)
        rightButton.setTitleColor(UIColor(hexString: "333333"), for: .normal)
        return rightButton
    }
    
    func setupUI() {
        
        contentView = contentContainer
        
        let titleContainer                    = UIView()
        titleContainer.backgroundColor        = .clear
        let topLineContainer                  = UIView()
        topLineContainer.backgroundColor      = .clear
        let contentLabelContainer             = UIView()
        contentLabelContainer.backgroundColor = .clear
        let bottomLineContainer               = UIView()
        bottomLineContainer.backgroundColor   = .clear
        
        titleContainer.addSubview(titleLabel)
        topLineContainer.addSubview(topLine)
        contentLabelContainer.addSubview(contentLabel)
        bottomLineContainer.addSubview(bottomLine)
        
        view.addSubview(contentContainer)
        contentContainer.addSubview(contentStackView)
        contentStackView.addArrangedSubview(titleContainer)
        contentStackView.addArrangedSubview(topLineContainer)
        contentStackView.addArrangedSubview(contentLabelContainer)
        contentStackView.addArrangedSubview(bottomLineContainer)
        buttonStackView.addArrangedSubviews([leftButton, rightButton])
        contentStackView.addArrangedSubview(buttonStackView)
        
        contentContainer.snp.makeConstraints { make in
            make.left.equalTo(40.0)
            make.center.equalToSuperview()
        }
        contentStackView.snp.makeConstraints { make in
            make.left.right.top.bottom.equalToSuperview()
        }
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(14.0)
            make.bottom.equalTo(-12.0)
            make.centerX.equalToSuperview()
        }
        topLine.snp.makeConstraints { make in
            make.top.left.right.bottom.equalToSuperview()
            make.height.equalTo(0.5)
        }
        contentLabel.snp.makeConstraints { make in
            make.top.equalTo(18.0)
            make.left.equalTo(20.0)
            make.right.equalTo(-20.0)
            make.bottom.equalTo(-28.0)
        }
        bottomLine.snp.makeConstraints { make in
            make.edges.equalToSuperview()
            make.height.equalTo(0.5)
        }
        buttonStackView.snp.makeConstraints { make in
            make.height.equalTo(49.0)
        }
        leftButton.snp.makeConstraints { make in
            make.width.equalTo(rightButton)
        }
    }
}
