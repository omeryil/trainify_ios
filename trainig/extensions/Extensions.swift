//
//  Extensions.swift
//  trainig
//
//  Created by omer yildirim on 27.01.2025.
//

import UIKit
import AVFoundation

extension UITextField{
   @IBInspectable var placeHolderColor: UIColor? {
        get {
            return self.placeHolderColor
        }
        set {
            self.attributedPlaceholder = NSAttributedString(string:self.placeholder != nil ? self.placeholder! : "", attributes:[NSAttributedString.Key.foregroundColor: newValue!])
        }
    }
}

extension CustomSegmented{
    @IBInspectable var vHeight: UInt {
        get {
            return self.vHeight
        }
        set {
            var rect:CGRect=self.frame;
            rect.size.height=CGFloat(newValue);
            self.frame=rect;
        }
    }
}
public extension UICollectionView {
    func centerContentHorizontalyByInsetIfNeeded(minimumInset: UIEdgeInsets) {
        guard let layout = collectionViewLayout as? UICollectionViewFlowLayout,
            layout.scrollDirection == .horizontal else {
                assertionFailure("\(#function): layout.scrollDirection != .horizontal")
                return
        }

        if layout.collectionViewContentSize.width > frame.size.width {
            contentInset = minimumInset
        } else {
            contentInset = UIEdgeInsets(top: minimumInset.top,
                                        left: (frame.size.width - layout.collectionViewContentSize.width) / 8,
                                        bottom: minimumInset.bottom,
                                        right: (frame.size.width - layout.collectionViewContentSize.width) / 8)
        }
    }
}
extension UIView {
  func addTopBorderWithColor(color: UIColor, width: CGFloat) {
      let border = CALayer()
      border.backgroundColor = color.cgColor
      border.frame = CGRectMake(0, 0, self.frame.size.width, width)
      self.layer.addSublayer(border)
  }

  func addRightBorderWithColor(color: UIColor, width: CGFloat) {
      let border = CALayer()
      border.backgroundColor = color.cgColor
      border.frame = CGRectMake(self.frame.size.width - width, 0, width, self.frame.size.height)
      self.layer.addSublayer(border)
  }

  func addBottomBorderWithColor(color: UIColor, width: CGFloat) {
      let border = CALayer()
      border.backgroundColor = color.cgColor
      border.frame = CGRectMake(0, self.frame.size.height - width, self.frame.size.width, width)
      self.layer.addSublayer(border)
  }

  func addLeftBorderWithColor(color: UIColor, width: CGFloat) {
      let border = CALayer()
      border.backgroundColor = color.cgColor
      border.frame = CGRectMake(0, 0, width, self.frame.size.height)
      self.layer.addSublayer(border)
  }
}
public extension UIImage {
   
    func resize(_ width: Int, _ height: Int) -> UIImage {
        let maxSize = CGSize(width: width, height: height)

        let availableRect = AVFoundation.AVMakeRect(
            aspectRatio: self.size,
            insideRect: .init(origin: .zero, size: maxSize)
        )
        let targetSize = availableRect.size

        let format = UIGraphicsImageRendererFormat()
        format.scale = 1
        let renderer = UIGraphicsImageRenderer(size: targetSize, format: format)

        let resized = renderer.image { _ in
            self.draw(in: CGRect(origin: .zero, size: targetSize))
        }

        return resized
    }
}
extension UIView{
    func showLoader(_ message:String) -> Indicator?{
        let indicator=Bundle.main.loadNibNamed("Indicator", owner: self, options: nil)?.first as? Indicator
        indicator?.frame = CGRect(x: 0, y: 0, width: self.frame.width, height: self.frame.height)
        indicator?.tag = -888754
        indicator!.lbl.text = message
        self.addSubview(indicator!)
        return indicator
    }

    func dismissLoader(){
        self.viewWithTag(-888754)?.removeFromSuperview()
    }
}

