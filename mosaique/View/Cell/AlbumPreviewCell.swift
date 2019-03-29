//
//  AlbumPreviewCell.swift
//  mosaique
//
//  Created by Klemen Zagar on 21/03/2019.
//  Copyright © 2019 Klemen Zagar. All rights reserved.
//

import UIKit


class AlbumPreviewCell: UITableViewCell {
  @IBOutlet weak var infoContainerView: UIView!
  @IBOutlet weak var titleLabel: UILabel!
  @IBOutlet weak var subtitleLabel: UILabel!
  @IBOutlet weak var firstPreview: UIImageView!
  @IBOutlet weak var secondPreview: UIImageView!
  @IBOutlet weak var indicator: UIImageView!
  @IBOutlet weak var loaderView: UIActivityIndicatorView!
  @IBOutlet weak var firstPreviewTopConstraint: NSLayoutConstraint!
  @IBOutlet weak var secondPreviewTopConstraint: NSLayoutConstraint!
  
  
  var modelIdentifier: Int = 0
  var loading = false {
    didSet {
      if loading {
        enableLoading()
      } else {
        disableLoading()
      }
    }
  }
  
  static let previewPositions = [PreviewPositions(first: Position(topOffset: -9, angle: 2), second: Position(topOffset: -5, angle: -4)),
                                 PreviewPositions(first: Position(topOffset: -19, angle: 3), second: Position(topOffset: -8, angle: -3)),
                                 PreviewPositions(first: Position(topOffset: -13, angle: 2), second: Position(topOffset: -6, angle: -5)),
                                 PreviewPositions(first: Position(topOffset: -5, angle: 5), second: Position(topOffset: -13, angle: -6)),
                                 PreviewPositions(first: Position(topOffset: -7, angle: 2), second: Position(topOffset: -16, angle: -5))
  ]
  
  override func awakeFromNib() {
    super.awakeFromNib()
    selectionStyle = .none
    infoContainerView.layer.cornerRadius = 5.0;
    indicator.image = indicator.image?.withRenderingMode(.alwaysTemplate)
    indicator.tintColor = UIColor.App.accent
    backgroundColor = .clear
    subtitleLabel.textColor = UIColor(white: 0.4, alpha: 1.0)
    isOpaque = true
    enablePlaceholder()
    rotateWithAnglePreset()
    firstPreview.layer.allowsEdgeAntialiasing = true
    secondPreview.layer.allowsEdgeAntialiasing = true
    firstPreview.layer.shadowColor = UIColor.black.cgColor
    firstPreview.layer.shadowRadius = 10.0
    firstPreview.layer.shadowOffset = CGSize(width: 2.0, height: 2.0)
    firstPreview.layer.shadowOpacity = 0.2
  }
  
  override func setHighlighted(_ highlighted: Bool, animated: Bool) {
    super.setHighlighted(highlighted, animated: animated)
    if highlighted {
      UIView.animate(withDuration: 0.10, delay: 0.0, options: .beginFromCurrentState, animations: { [weak self] in
        self?.indicator.alpha = 0.7
        self?.infoContainerView.backgroundColor = UIColor(white: 0.82, alpha: 1.0)
      })
    } else {
      UIView.animate(withDuration: 0.10, delay: 0.0, options: .beginFromCurrentState, animations: { [weak self] in
        self?.indicator.alpha = 1.0
        self?.infoContainerView.backgroundColor = .white
      })
    }
  }
  
  override func setSelected(_ selected: Bool, animated: Bool) {
    super.setSelected(selected, animated: animated)
    if selected {
      UIView.animate(withDuration: 0.24, delay: 0.0, options: .beginFromCurrentState, animations: { [weak self] in
        self?.indicator.alpha = 0.7
        self?.infoContainerView.backgroundColor = UIColor(white: 0.84, alpha: 1.0)
      })
    } else {
      UIView.animate(withDuration: 0.55, delay: 0.0, options: .beginFromCurrentState, animations: { [weak self] in
        self?.indicator.alpha = 1.0
        self?.infoContainerView.backgroundColor = .white
      })
    }
  }
  
  func assign(modelIdentifier: Int) {
    self.modelIdentifier = modelIdentifier
    rotateWithAnglePreset()
  }
  
  func setup(for album: AlbumViewModel) {
    setup(albumId: album.albumId, title: album.title, subtitle: album.photosCountSubtitle)
    firstPreview.image = album.firstPreviewImageObserver.value
    secondPreview.image = album.secondPreviewImageObserver.value
    
    album.photoViewModelsObserver.valueChanged = { [weak self] photos in
      if let strongSelf = self {
        DispatchQueue.main.async {
          strongSelf.setup(albumId: album.albumId, title: album.title, subtitle: album.photosCountSubtitle)
          if photos.count > 0 {
            strongSelf.disableLoading()
          } else {
            strongSelf.enableLoading()
          }
        }
      }
    }
    album.firstPreviewImageObserver.valueChanged = { [weak self] preview in
      if let strongSelf = self {
        DispatchQueue.main.async {
          strongSelf.firstPreview.image = preview
        }
      }
    }
    album.secondPreviewImageObserver.valueChanged = { [weak self] preview in
      if let strongSelf = self {
        DispatchQueue.main.async {
          strongSelf.secondPreview.image = preview
        }
      }
    }
    
  }
  
  func setup(albumId: Int, title: String, subtitle: String) {
    disablePlaceholder()
    modelIdentifier = albumId
    titleLabel.text = title.capitalizingFirstLetter()
    subtitleLabel.text = subtitle
  }
  
  func disablePlaceholder() {
    indicator.alpha = 0.8
  }
  
  func enablePlaceholder() {
    titleLabel.text = " "
    subtitleLabel.text = " "
    indicator.alpha = 0.2
  }
  
  func reset() {
    modelIdentifier = 0
    loading = false
    enablePlaceholder()
  }
  
  func enableLoading() {
    indicator.isHidden = true
    loaderView.startAnimating()
  }
  
  func disableLoading() {
    indicator.isHidden = false
    loaderView.stopAnimating()
  }
  
  func rotateWithAnglePreset() {
    if let previewPositions = AlbumPreviewCell.previewPositions.randomElement() {
      rotate(view: firstPreview, with: previewPositions.first.angle)
      rotate(view: secondPreview, with: previewPositions.second.angle)
      firstPreviewTopConstraint.constant = previewPositions.first.topOffset
      secondPreviewTopConstraint.constant = previewPositions.second.topOffset
    }
  }
  
  
  func rotate(view: UIView, with angle: DegreeAngle) {
    let radians = angle / 180.0 * CGFloat.pi
    let rotation = self.transform.rotated(by: radians)
    view.transform = rotation
  }
}






extension AlbumPreviewCell {
  typealias DegreeAngle = CGFloat
  
  struct Position {
    let topOffset: CGFloat
    let angle: DegreeAngle
  }
  
  struct PreviewPositions {
    let first: Position
    let second: Position
  }
  
}
