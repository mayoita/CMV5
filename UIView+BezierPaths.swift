//
//  UIView+BezierPaths.swift
//  CustomPinsMap
//
//  Created by Ignacio Nieto Carvajal on 8/12/16.
//  Copyright © 2016 Ignacio Nieto Carvajal. All rights reserved.
//

import UIKit
//Utilizzato per creare un array di classi (array contenente le immagini generate da PaintCode da utilizzare nel Menu)

public struct MyConstants{
    static let immaginiSelezionate = [StyleKit.imageOfEventi(imageSize: CGSize(width: 100, height: 100), highlited: true),
                                      StyleKit.imageOfGiochi(imageSize: CGSize(width: 100, height: 100), highlited: true),
                                      StyleKit.imageOfGiochiLista(imageSize: CGSize(width: 100, height: 100), highlited: true),
                                      StyleKit.imageOfPromozioni(imageSize: CGSize(width: 100, height: 100), highlited: true),
                                      StyleKit.imageOfEvents(imageSize: CGSize(width: 100, height: 100), highlited: true),
                                      StyleKit.imageOfHome(imageSize: CGSize(width: 100, height: 100), highlited: true)]
    static let immagini = [StyleKit.imageOfEventi(imageSize: CGSize(width: 100, height: 100), highlited: false),
                           StyleKit.imageOfGiochi(imageSize: CGSize(width: 100, height: 100), highlited: false),
                           StyleKit.imageOfGiochiLista(imageSize: CGSize(width: 100, height: 100), highlited: false),
                           StyleKit.imageOfPromozioni(imageSize: CGSize(width: 100, height: 100), highlited: false),
                           StyleKit.imageOfEvents(imageSize: CGSize(width: 100, height: 100), highlited: false),
                           StyleKit.imageOfHome(imageSize: CGSize(width: 100, height: 100), highlited: false)]
}
enum TipoController {
    case Evento
    case Gioco
}
enum nomeSedi: Int {
    case VE = 0
    case CN = 1
}
extension UIColor {
    convenience init(colorWithHexValue value: Int, alpha:CGFloat = 1.0){
        self.init(
            red: CGFloat((value & 0xFF0000) >> 16) / 255.0,
            green: CGFloat((value & 0x00FF00) >> 8) / 255.0,
            blue: CGFloat(value & 0x0000FF) / 255.0,
            alpha: alpha
        )
    }
}
struct giochiDB: Codable {
    var immagine: String
    var immagine_tavolo: String
    var main: String
    var titolo: String
    var office: [String]
    var probabilita: String
    var regola: [[String: String]]
    var orari: String
}


extension String {
    var localized: String {
        return NSLocalizedString(self, tableName: nil, bundle: Bundle.main, value: "", comment: "")
    }
}

func degreesToRadians (_ value:CGFloat) -> CGFloat {
    return value * CGFloat(Double.pi) / 180.0
}

func radiansToDegrees (_ value:CGFloat) -> CGFloat {
    return value * 180.0 / CGFloat(Double.pi)
}
func isIPhoneX () -> Bool {
    if UIDevice().userInterfaceIdiom == .phone {
        switch UIScreen.main.nativeBounds.height {
        case 1136:
            //print("iPhone 5 or 5S or 5C")
            return false
        case 1334:
            //print("iPhone 6/6S/7/8")
            return false
        case 1920, 2208:
            //print("iPhone 6+/6S+/7+/8+")
            return false
        case 2436:
            return true
        default:
            return false
        }
    }
    return false
}

func dialogBezierPathWithFrame(_ frame: CGRect, arrowOrientation orientation: UIImageOrientation, arrowLength: CGFloat = 20.0) -> UIBezierPath {
    // Translate frame to neutral coordinate system & transpose it to fit the orientation.
    var transposedFrame = CGRect.zero
    switch orientation {
    case .up, .down, .upMirrored, .downMirrored:
        transposedFrame = CGRect(x: 0, y: 0, width: frame.size.width - frame.origin.x, height: frame.size.height - frame.origin.y)
    case .left, .right, .leftMirrored, .rightMirrored:
        transposedFrame = CGRect(x: 0, y: 0,  width: frame.size.height - frame.origin.y, height: frame.size.width - frame.origin.x)
    }
    
    // We need 7 points for our Bezier path
    let midX = transposedFrame.midX
    let point1 = CGPoint(x: transposedFrame.minX, y: transposedFrame.minY + arrowLength)
    let point2 = CGPoint(x: midX - (arrowLength / 2), y: transposedFrame.minY + arrowLength)
    let point3 = CGPoint(x: midX, y: transposedFrame.minY)
    let point4 = CGPoint(x: midX + (arrowLength / 2), y: transposedFrame.minY + arrowLength)
    let point5 = CGPoint(x: transposedFrame.maxX, y: transposedFrame.minY + arrowLength)
    let point6 = CGPoint(x: transposedFrame.maxX, y: transposedFrame.maxY)
    let point7 = CGPoint(x: transposedFrame.minX, y: transposedFrame.maxY)
    
    // Build our Bezier path
    let path = UIBezierPath()
    path.move(to: point1)
    path.addLine(to: point2)
    path.addLine(to: point3)
    path.addLine(to: point4)
    path.addLine(to: point5)
    path.addLine(to: point6)
    path.addLine(to: point7)
    path.close()
    
    // Rotate our path to fit orientation
    switch orientation {
    case .up, .upMirrored:
    break // do nothing
    case .down, .downMirrored:
        path.apply(CGAffineTransform(rotationAngle: degreesToRadians(180.0)))
        path.apply(CGAffineTransform(translationX: transposedFrame.size.width, y: transposedFrame.size.height))
    case .left, .leftMirrored:
        path.apply(CGAffineTransform(rotationAngle: degreesToRadians(-90.0)))
        path.apply(CGAffineTransform(translationX: 0, y: transposedFrame.size.width))
    case .right, .rightMirrored:
        path.apply(CGAffineTransform(rotationAngle: degreesToRadians(90.0)))
        path.apply(CGAffineTransform(translationX: transposedFrame.size.height, y: 0))
    }
    
    return path
}
extension UIView {
    func addConstraintsWithFormnat(format: String, views: UIView...) {
        var viewsDictionary = [String: UIView]()
        for (index, view) in views.enumerated() {
            let key = "v\(index)"
            view.translatesAutoresizingMaskIntoConstraints = false
            viewsDictionary[key] = view
        }
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: format, options: NSLayoutFormatOptions(), metrics: nil, views: viewsDictionary))
    }
}

extension UIView {
    func applyArrowDialogAppearanceWithOrientation(arrowOrientation: UIImageOrientation) {
        let shapeLayer = CAShapeLayer()
        shapeLayer.path = dialogBezierPathWithFrame(self.frame, arrowOrientation: arrowOrientation).cgPath
        shapeLayer.fillColor = UIColor.white.cgColor
        shapeLayer.fillRule = kCAFillRuleEvenOdd
        self.layer.mask = shapeLayer
    }
    
}

extension UIView {
    func scaleIn(_ duration: TimeInterval = 1.0, delay: TimeInterval = 0.0, completion: @escaping ((Bool) -> Void) = {(finished: Bool) -> Void in}) {
        UIView.animate(withDuration: duration, delay: delay, options: UIViewAnimationOptions.curveEaseIn, animations: {
            
             self.transform = CGAffineTransform(scaleX: 1, y: 0.01)
        }, completion: completion)  }
    
    func scaleOut(_ duration: TimeInterval = 1.0, delay: TimeInterval = 0.0, completion: @escaping (Bool) -> Void = {(finished: Bool) -> Void in}) {
        UIView.animate(withDuration: duration, delay: delay, options: UIViewAnimationOptions.curveEaseIn, animations: {
            self.alpha = 0.0
        }, completion: completion)
    }
    
    func scaleInOut () {
        UIView.animate(withDuration: 0.3,
                       animations: {
                        self.transform = CGAffineTransform(scaleX: 1, y: 0.01)
        },
                       completion: { _ in
                        UIView.animate(withDuration: 0.2, animations: {
                            self.transform = CGAffineTransform(scaleX: 1, y: 1)
                        }, completion: { _ in
                            UIView.animate(withDuration: 0.2, delay: 1, options: UIViewAnimationOptions(rawValue: 0), animations: {
                                self.transform = CGAffineTransform(scaleX: 1, y: 0.01)
                            }, completion: { _ in
                                UIView.animate(withDuration: 0.3, animations: {
                                    self.transform = CGAffineTransform(scaleX: 0.01, y: 0.01)
                                }, completion: { _ in
                                    self.removeFromSuperview()
                                })
                            })
                        })
        })
    }
}

class EdgeInsetLabel: UILabel {
    var textInsets = UIEdgeInsets.zero {
        didSet { invalidateIntrinsicContentSize() }
    }
    
    override func textRect(forBounds bounds: CGRect, limitedToNumberOfLines numberOfLines: Int) -> CGRect {
        let insetRect = UIEdgeInsetsInsetRect(bounds, textInsets)
        let textRect = super.textRect(forBounds: insetRect, limitedToNumberOfLines: numberOfLines)
        let invertedInsets = UIEdgeInsets(top: -textInsets.top,
                                          left: -textInsets.left,
                                          bottom: -textInsets.bottom,
                                          right: -textInsets.right)
        return UIEdgeInsetsInsetRect(textRect, invertedInsets)
    }
    
    override func drawText(in rect: CGRect) {
        super.drawText(in: UIEdgeInsetsInsetRect(rect, textInsets))
    }
}

extension EdgeInsetLabel {

    var leftTextInset: CGFloat {
        set { textInsets.left = newValue }
        get { return textInsets.left }
    }
    
    @IBInspectable
    var rightTextInset: CGFloat {
        set { textInsets.right = newValue }
        get { return textInsets.right }
    }
    
    @IBInspectable
    var topTextInset: CGFloat {
        set { textInsets.top = newValue }
        get { return textInsets.top }
    }
    
    @IBInspectable
    var bottomTextInset: CGFloat {
        set { textInsets.bottom = newValue }
        get { return textInsets.bottom }
    }
}

