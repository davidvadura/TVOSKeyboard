//
//  File.swift
//  
//
//  Created by Stanislav Belsky on 04.07.2020.
//

import UIKit

@objc
open class KeyboardButton: UIButton {

    @objc
    @IBInspectable public var selectedBackgroundColor: UIColor = .black {
        didSet { updateView() }
    }

    @objc
    @IBInspectable public var selectedBackgroundEndColor: UIColor? {
        didSet { updateView() }
    }

    @objc
    @IBInspectable public var focusedBackgroundColor: UIColor = .red {
        didSet { updateView() }
    }

    @objc
    @IBInspectable public var focusedBackgroundEndColor: UIColor? {
        didSet { updateView() }
    }

    @objc
    @IBInspectable public var normalBackgroundColor: UIColor = .white {
        didSet { updateView() }
    }

    @objc
    @IBInspectable public var normalBackgroundEndColor: UIColor? {
        didSet { updateView() }
    }

    @objc
    @IBInspectable public var cornerRadius: CGFloat = 6.0 {
        didSet { updateView() }
    }

    @objc
    @IBInspectable public var focusedScaleFactor: CGFloat = 1.2 {
        didSet { updateView() }
    }

    @objc
    @IBInspectable public var focusedShadowRadius: CGFloat = 10 {
        didSet { updateView() }
    }

    @objc
    @IBInspectable public var focusedShadowOpacity: Float = 0.25 {
        didSet { updateView() }
    }

    @objc
    @IBInspectable public var shadowColor: CGColor = UIColor.black.cgColor {
        didSet { updateView() }
    }

    @objc
    @IBInspectable public var shadowOffSetFocused: CGSize = CGSize(width: 0, height: 15) {
        didSet { updateView() }
    }

    @objc
    @IBInspectable public var animationDuration: TimeInterval = 0.2 {
        didSet { updateView() }
    }

    @objc
    @IBInspectable public var focusedTitleColor: UIColor = .white {
        didSet { updateView() }
    }
    
    @objc
    @IBInspectable public var focusedSpaceTitleColor: UIColor = .white {
        didSet { updateView() }
    }
    
    @objc
    @IBInspectable public var normalSpaceTitleColor: UIColor = .white {
        didSet { updateView() }
    }
    
    @objc
    @IBInspectable public var focusedSpaceBackgroundColor: UIColor = .darkGray {
        didSet { updateView() }
    }
    
    @objc
    @IBInspectable public var normalSpaceBackgroundColor: UIColor = .gray {
        didSet { updateView() }
    }

    @objc
    @IBInspectable public var titleFont: UIFont = UIFont.systemFont(ofSize: 30) {
        didSet { updateView() }
    }
    
    @objc
    @IBInspectable public var extraTitle: String? = nil {
        didSet { updateView() }
    }
    
    @objc
    @IBInspectable public var normalTitleColor: UIColor = .white {
        didSet { updateView() }
    }

    @objc
    @IBInspectable public var gradientStartPoint: CGPoint = .zero {
        didSet { updateView() }
    }

    @objc
    @IBInspectable public var gradientEndPoint: CGPoint = CGPoint(x: 1, y: 1) {
        didSet { updateView() }
    }
    
    open override var isSelected: Bool {
        didSet { updateView() }
    }
    
    open override var buttonType: UIButton.ButtonType {
        return .custom
    }
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        updateView()
    }
    
    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        updateView()
    }
    
    override open func awakeFromNib() {
        super.awakeFromNib()
        updateView()
    }
    
    override open func didUpdateFocus(in context: UIFocusUpdateContext, with coordinator: UIFocusAnimationCoordinator) {
        coordinator.addCoordinatedAnimations({
            self.isFocused ? self.applyFocusedStyle() : self.applyUnfocusedStyle()
        }, completion: nil)
    }
    
    override open func pressesBegan(_ presses: Set<UIPress>, with event: UIPressesEvent?) {
        guard presses.first?.type == .select else {
            return super.pressesBegan(presses, with: event)
        }
        
        UIView.animate(
            withDuration: animationDuration,
            animations: {
                [weak self] in
                guard let `self` = self else { return }
                self.transform = CGAffineTransform.identity
                self.layer.shadowOffset = CGSize(width: 0, height: 10)
        })
    }
    
    override open func pressesCancelled(_ presses: Set<UIPress>, with event: UIPressesEvent?) {
        guard presses.first?.type == .select else {
            return super.pressesCancelled(presses, with: event)
        }
        guard isFocused else { return }
        UIView.animate(
            withDuration: animationDuration,
            animations: {
                [weak self] in
                guard let `self` = self else { return }
                self.transform = CGAffineTransform(scaleX: self.focusedScaleFactor, y: self.focusedScaleFactor)
                self.layer.shadowOffset = self.shadowOffSetFocused
        })
    }
    
    override open func pressesEnded(_ presses: Set<UIPress>, with event: UIPressesEvent?) {
        guard presses.first?.type == .select else {
            return super.pressesEnded(presses, with: event)
        }
        guard isFocused else { return }
        UIView.animate(
            withDuration: animationDuration,
            animations: {
                [weak self] in
                guard let `self` = self else { return }
                self.transform = CGAffineTransform(scaleX: self.focusedScaleFactor, y: self.focusedScaleFactor)
                self.layer.shadowOffset = self.shadowOffSetFocused
        })
    }
    
    // MARK: - Private
    
    private var selectedGradientBackgroundColors: [CGColor] {
        let endColor = selectedBackgroundEndColor ?? selectedBackgroundColor
        return [selectedBackgroundColor.cgColor, endColor.cgColor]
    }
    
    private var focusedGradientBackgroundColors: [CGColor] {
        let endColor = focusedBackgroundEndColor ?? focusedBackgroundColor
        return [focusedBackgroundColor.cgColor, endColor.cgColor]
    }
    
    private var normalGradientBackgroundColors: [CGColor] {
        let endColor = normalBackgroundEndColor ?? normalBackgroundColor
        return [normalBackgroundColor.cgColor, endColor.cgColor]
    }
    
    private let gradientView = GradientView()
    
    private let moutionEffect = ParallaxStyle.defaultParallaxStyle.motionEffectGroup
    
    private func setShadow(){
        layer.shadowOpacity = focusedShadowOpacity
        layer.shadowRadius = focusedShadowRadius
        layer.shadowColor = shadowColor
        layer.shadowOffset = shadowOffSetFocused
    }
    
    private func removeShadow(){
        layer.shadowOpacity = 0
        layer.shadowRadius = 0
        layer.shadowColor = nil
        layer.shadowOffset = CGSize(width: 0, height: 0)
    }
    
    private func updateView() {
        setUpGradientView()
        titleLabel?.font = titleFont
        layer.cornerRadius = cornerRadius
        clipsToBounds = false
        setTitleColor(normalTitleColor, for: .normal)
        setTitleColor(focusedTitleColor, for: .focused)
        
        
        if extraTitle != nil{
            let normalImage = ExtraImage(text: extraTitle!, font: titleFont, textColor: normalSpaceTitleColor, backgroundColor: normalSpaceBackgroundColor).asImage()
            setImage(normalImage, for: .normal)
            
            let focusedImage = ExtraImage(text: extraTitle!, font: titleFont, textColor: focusedSpaceTitleColor, backgroundColor: focusedSpaceBackgroundColor).asImage()
            setImage(focusedImage, for: .focused)
        }
        
//        if extraTitle != nil{
//            transform = CGAffineTransform(scaleX: focusedScaleFactor, y: focusedScaleFactor)
//        }else if isFocused {
        if isFocused {
            tintColor = focusedTitleColor
            transform = CGAffineTransform(scaleX: focusedScaleFactor, y: focusedScaleFactor)
        }else{
            tintColor = normalTitleColor
            transform = CGAffineTransform.identity
        }
        
    }
    
    private func setUpGradientView() {
        gradientView.frame = bounds
        gradientView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        gradientView.layer.cornerRadius = cornerRadius
        gradientView.startPoint = gradientStartPoint
        gradientView.endPoint = gradientEndPoint

        if isFocused {
            gradientView.colors = focusedGradientBackgroundColors
        }
        else if isSelected {
            gradientView.colors = selectedGradientBackgroundColors
        }
        else {
            gradientView.colors = normalGradientBackgroundColors
        }
        
        if let imageView = imageView {
            insertSubview(gradientView, belowSubview: imageView)
        }
        else if let titleLabel = titleLabel {
            insertSubview(gradientView, belowSubview: titleLabel)
        }
        else {
            addSubview(gradientView)
        }
    }
    
    private func applyFocusedStyle() {
        
        setShadow()
        gradientView.addMotionEffect(moutionEffect)
        
        UIView.animate(
            withDuration: animationDuration,
            animations: {
                [weak self] in
                self?.updateView()
            },
            completion: nil)
    }
    
    private func applyUnfocusedStyle() {
        
        removeShadow()
        gradientView.removeMotionEffect(moutionEffect)
        
        UIView.animate(
            withDuration: animationDuration,
            animations: {
                [weak self] in
                self?.updateView()
            },
            completion: nil)
    }
}

final private class GradientView: UIView {
    
    override class var layerClass: AnyClass {
        return CAGradientLayer.self
    }
    
    var colors: [Any]? {
        set {
            gradientLayer.colors = newValue
        }
        
        get {
            return gradientLayer.colors
        }
    }
    
    var startPoint: CGPoint {
        set {
            gradientLayer.startPoint = newValue
        }
        
        get {
            return gradientLayer.startPoint
        }
    }
    
    var endPoint: CGPoint {
        set {
            gradientLayer.endPoint = newValue
        }
        
        get {
            return gradientLayer.endPoint
        }
    }
    
    // MARK: - Private
    
    private lazy var gradientLayer: CAGradientLayer = {
        return layer as! CAGradientLayer
    }()
}

