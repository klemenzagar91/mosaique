//
//  AppButton.swift
//  mosaique
//
//  Created by Klemen Zagar on 23/03/2019.
//  Copyright © 2019 Klemen Zagar. All rights reserved.
//

import UIKit

enum AppButtonHeight {
  case compact
  case regular
}

class AppButton: UIButton {
  var defualtColor: UIColor?
  var highlightColor: UIColor?
  var selectedColor: UIColor?
  var disabledColor: UIColor?
  var cornerRadius: CGFloat = 10.0
  
  var isGhost: Bool = false {
    didSet {
      updateUI()
    }
  }
  
  var isShady: Bool = false {
    didSet {
      updateUI()
    }
  }
  
  var heightClass: AppButtonHeight = .regular {
    didSet {
      updateControl()
    }
  }
  var height: CGFloat = 50.0
  
  override var isHighlighted: Bool {
    didSet {
      updateUIColor()
    }
  }
  
  override var isSelected: Bool {
    didSet {
      updateUIColor()
    }
  }
  
  override var isEnabled: Bool {
    didSet {
      updateUIColor()
    }
  }
  
  override class var layerClass: AnyClass {
    get {
      return CAShapeLayer.self
    }
  }
  
  var shapeLayer: CAShapeLayer {
    return layer as! CAShapeLayer
  }
  
  
  func updateControl() {
    switch heightClass {
    case .regular:
      cornerRadius = 10.0
      height = 50.0
    case .compact:
      cornerRadius = 8.0
      height = 35.0
    }
    invalidateIntrinsicContentSize()
  }
  
  override open var intrinsicContentSize: CGSize {
    return CGSize(width: bounds.width + contentEdgeInsets.left/2.0 + contentEdgeInsets.right/2.0, height: height)
  }
  
  override func awakeFromNib() {
    super.awakeFromNib()
    updateUI()
    updateControl()
  }
  
  override func layoutSubviews() {
    super.layoutSubviews()
    shapeLayer.path = UIBezierPath(roundedRect: layer.bounds, cornerRadius: cornerRadius).cgPath
    if isGhost {
      layer.cornerRadius = cornerRadius
    } else {
      layer.cornerRadius = 0.0
    }
  }
  
  
  
  
  func updateUI() {
    backgroundColor = .clear
    if isGhost {
      defualtColor = nil
      selectedColor = nil
      highlightColor = nil
    } else {
      defualtColor = .white
      selectedColor = UIColor(white: 0.9, alpha: 1.0)
      highlightColor = UIColor(white: 0.9, alpha: 1.0)
      disabledColor = UIColor(red: 244.0 / 255.0, green: 246.0 / 255.0, blue: 247.0 / 255.0, alpha: 1.0)
    }
    setTitleColor(UIColor.App.accent, for: .normal)
    setTitleColor(UIColor.App.accent.withAlphaComponent(0.2), for: .disabled)
    
    
    updateUIColor()
  }
  
  func updateUIColor() {
    let shadowRadius: CGFloat = 10.0
    var shadowOpacity: Float = 0.2
    if isEnabled {
      if isHighlighted {
        shapeLayer.fillColor = highlightColor?.cgColor
      } else if isSelected {
        shapeLayer.fillColor = selectedColor?.cgColor
      } else {
        shapeLayer.fillColor = defualtColor?.cgColor
      }
    } else {
      shapeLayer.fillColor = disabledColor?.cgColor
      shadowOpacity = 0.07
    }
    if isShady {
      layer.shadowColor = UIColor.black.cgColor
      layer.shadowRadius = shadowRadius
      layer.shadowOffset = CGSize(width: 2.0, height: 2.0)
      layer.shadowOpacity = shadowOpacity
    } else {
      layer.shadowColor = nil
      layer.shadowOpacity = 0.0
    }
  }
}

extension UIButton {
  private func imageWith(color: UIColor) -> UIImage {
    let rect = CGRect(x: 0.0, y: 0.0, width: 1.0, height: 1.0)
    UIGraphicsBeginImageContext(rect.size)
    let context = UIGraphicsGetCurrentContext()
    context?.setFillColor(color.cgColor)
    context?.fill(rect)
    let image = UIGraphicsGetImageFromCurrentImageContext()
    UIGraphicsEndImageContext()
    return image!
  }
  
  func setBackgroundColor(color: UIColor?, for state: UIControl.State) {
    if let color = color {
      setBackgroundImage(imageWith(color: color), for: state)
    } else {
      setBackgroundImage(nil, for: state)
    }
  }
}



