//
//  XKNormalAlertController.swift
//  Pods
//
//  Created by kenneth on 2022/3/15.
//

import UIKit
import SnapKit
import XKExtensions

open class XKNormalAlertController: XKAlertContainerViewController {
    
    public typealias XKNormalAlertLayoutTuple = (contentView: UIView,
                                                   titleLabel: UILabel,
                                                   topLine: UIView,
                                                   contentLabel: UILabel,
                                                   bottomLine: UIView,
                                                   leftButton: UIButton,
                                                   rightButton: UIButton,
                                                   buttonLine: UIView,
                                                   topStackView: UIStackView,
                                                   buttonStackView: UIStackView)
    public typealias XKNormalAlertUILayoutClosure = ((_ tuple: XKNormalAlertLayoutTuple) -> Void)
    
    @objc public lazy var contentContainer = createContentContainer()
    ///顶部容器
    @objc public lazy var contentStackView: UIStackView = createContentStackView()
    ///按钮的容器，默认有两个按钮，需要增加的话自己往该容器上加
    @objc public lazy var buttonStackView: UIStackView = createButtonStackView()
    @objc public lazy var titleLabel: UILabel = createTitleLabel()
    ///标题和内容的分割线
    @objc public lazy var topLine: UIView = createTopLine()
    @objc public lazy var contentLabel: UILabel = createContentLabel()
    ///内容和按钮的分割线
    @objc public lazy var bottomLine: UIView = createBottomLine()
    @objc public lazy var leftButton: UIButton = createLeftButton()
    ///左右按钮的分割线
    @objc public lazy var buttonLine: UIView = createButtonLine()
    @objc public lazy var rightButton: UIButton = createRightButton()
    /// 点击左按钮是否dismiss
    @objc public var dissmissOnPressedLeftButton: Bool = true
    /// OC使用，swift初始化设置即可
    @objc public var ocSubViewsConfiguredAction: ((_ contentView: UIView,
                                            _ titleLabel: UILabel,
                                            _ topLine: UIView,
                                            _ contentLabel: UILabel,
                                            _ bottomLine: UIView,
                                            _ leftButton: UIButton,
                                            _ rightButton: UIButton,
                                            _ buttonLine: UIView,
                                            _ topStackView: UIStackView,
                                            _ buttonStackView: UIStackView) -> Void)? = nil
    
    public var layoutClosure: XKNormalAlertUILayoutClosure?

    open override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
        ocSubViewsConfiguredAction?(contentContainer, titleLabel, topLine, contentLabel, bottomLine, leftButton, rightButton, buttonLine, contentStackView, buttonStackView)
        layoutClosure?((contentContainer, titleLabel, topLine, contentLabel, bottomLine, leftButton, rightButton, buttonLine, contentStackView, buttonStackView))
        titleLabel.superview?.isHidden   = titleLabel.isHidden
        topLine.superview?.isHidden      = topLine.isHidden
        contentLabel.superview?.isHidden = contentLabel.isHidden
        bottomLine.superview?.isHidden   = bottomLine.isHidden
        buttonLine.isHidden              = leftButton.isHidden || rightButton.isHidden
        
    }
}

public extension XKNormalAlertController {
    
    /// 初始化
    /// - Parameter layoutClosure: 布局，可通过子视图的snp修改
    /// buttonStackView: 按钮的容器，默认有两个按钮，需要增加的话自己往该容器上加。
    /// - Returns: 控制器
    class func initController(layoutClosure: XKNormalAlertUILayoutClosure?) -> UIViewController? {
        let vc = XKNormalAlertController.defaultController()
        vc?.layoutClosure = layoutClosure
        return vc
    }
}

fileprivate extension XKNormalAlertController {
    
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
        titleLabel.textColor = UIColor.color33
        titleLabel.font      = UIFont.xk_pingFangSC(size: 18.0, name: .medium)
        return titleLabel
    }
    func createTopLine() -> UIView {
        let topLine = UIView()
        topLine.backgroundColor = UIColor.lightGray
        return topLine
    }
    func createContentLabel() -> UILabel {
        let contentLabel = UILabel()
        contentLabel.text          = "内容"
        contentLabel.textColor     = UIColor.color33
        contentLabel.font          = UIFont.xk_pingFangSC(size: 18.0, name: .medium)
        contentLabel.numberOfLines = 0
        contentLabel.textAlignment = .center
        return contentLabel
    }
    func createBottomLine() -> UIView {
        let bottomLine = UIView()
        bottomLine.backgroundColor = UIColor.lightGray
        return bottomLine
    }
    func createLeftButton() -> UIButton {
        let leftButton = UIButton(type: .custom)
        leftButton.backgroundColor = .clear
        leftButton.setTitle("左", for: .normal)
        leftButton.setTitleColor(UIColor.color33, for: .normal)
        leftButton.addTarget(self, action: #selector(onPressedLeftButton), for: .touchUpInside)
        return leftButton
    }
    func createRightButton() -> UIButton {
        let rightButton = UIButton(type: .custom)
        rightButton.backgroundColor = .clear
        rightButton.setTitle("右", for: .normal)
        rightButton.setTitleColor(UIColor.color33, for: .normal)
        return rightButton
    }
    func createButtonLine() -> UIView {
        let buttonLine = UIView()
        buttonLine.backgroundColor = UIColor.lightGray
        return buttonLine
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
        buttonStackView.addArrangedSubviews([leftButton, buttonLine, rightButton])
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
        buttonLine.snp.makeConstraints { make in
            make.width.equalTo(0.5)
        }
        buttonStackView.snp.makeConstraints { make in
            make.height.equalTo(49.0)
        }
        leftButton.snp.makeConstraints { make in
            make.width.equalTo(rightButton)
        }
    }
}

extension XKNormalAlertController {
    
    @objc func onPressedLeftButton() {
        guard dissmissOnPressedLeftButton else { return }
        dismiss(animated: true) {}
    }
}
