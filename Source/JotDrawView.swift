//
//  JotDrawView.h
//  jot
//
//  Created by Laura Skelton on 4/30/15.
//
//
import UIKit
import Foundation

//
//  JotDrawView.m
//  jot
//
//  Created by Laura Skelton on 4/30/15.
//
//

let kJotVelocityFilterWeight: CGFloat = 0.9

let kJotInitialVelocity: CGFloat = 220.0

let kJotRelativeMinStrokeWidth: CGFloat = 0.4


/**
 *  Private class to handle touch drawing. Change the properties
 *  in a JotViewController instance to configure this private class.
 */
class JotDrawView: UIView {
    
    var cachedImage: UIImage!
    var pathsArray: [AnyObject]!
    var touchBezier:JotTouchBezier = JotTouchBezier()
    var bezierPath: JotTouchBezier {
     get {
        self.bezierPath = JotTouchBezier.withColor(self.strokeColor)
        self.pathsArray.append(self.bezierPath)
        self.bezierPath.constantWidth = self.constantStrokeWidth
        return self.bezierPath
     }
        set(strokeColor) {
            self.bezierPath = JotTouchBezier.withColor(self.strokeColor)
        }
    }
    var pointsArray: [AnyObject]!
    var pointsCounter: Int!
    var lastVelocity: CGFloat!
    var lastWidth: CGFloat!
    var initialVelocity: CGFloat!
    
    /**
     *  Set to YES if you want the stroke width to be constant,
     *  NO if the stroke width should vary depending on drawing
     *  speed.
     *
     *  @note Set drawingConstantStrokeWidth in JotViewController
     *  to control this setting.
     */
    var constantStrokeWidth: Bool {
        get {
            return self.constantStrokeWidth
        }
        set(constantStrokeWidth) {
            if constantStrokeWidth != constantStrokeWidth {
                self.constantStrokeWidth = constantStrokeWidth
                //self.bezierPath = nil
                self.pointsArray.removeAll()
                self.pointsCounter = 0
            }
        }
    }

    /**
     *  Sets the stroke width if constantStrokeWidth is true,
     *  or sets the base strokeWidth for variable drawing paths.
     *
     *  @note Set drawingStrokeWidth in JotViewController
     *  to control this setting.
     */
    var strokeWidth: CGFloat = 0.0
    /**
     *  Sets the stroke color. Each path can have its own stroke color.
     *
     *  @note Set drawingColor in JotViewController
     *  to control this setting.
     */
    var strokeColor: UIColor {
        get {
            return self.strokeColor
        }
        set(strokeColor) {
            self.strokeColor = strokeColor
            //self.bezierPath = nil
        }
    }

    /**
     *  Clears all paths from the drawing, giving a blank slate.
     *
     *  @note Call clearDrawing or clearAll in JotViewController
     *  to trigger this method.
     */

    func clearDrawing() {
        self.cachedImage = UIImage()//nil
        self.pathsArray.removeAll()
        //self.bezierPath = nil
        self.pointsCounter = 0
        self.pointsArray.removeAll()
        self.lastVelocity = self.initialVelocity
        self.lastWidth = self.strokeWidth
        UIView.transitionWithView(self, duration: 0.2, options: .TransitionCrossDissolve, animations: {() -> Void in
            self.setNeedsDisplay()
        }, completion: { _ in })
    }
    /**
     *  Tells the JotDrawView to handle a touchesBegan event.
     *
     *  @param touchPoint The point in this view's coordinate
     *  system where the touch began.
     *
     *  @note This method is triggered by the JotDrawController's
     *  touchesBegan event.
     */

    func drawTouchBeganAtPoint(touchPoint: CGPoint) {
        self.lastVelocity = self.initialVelocity
        self.lastWidth = self.strokeWidth
        self.pointsCounter = 0
        self.pointsArray.removeAll()
        self.pointsArray.append(JotTouchPoint.withPoint(touchPoint))
    }
    /**
     *  Tells the JotDrawView to handle a touchesMoved event.
     *
     *  @param touchPoint The point in this view's coordinate
     *  system where the touch moved.
     *
     *  @note This method is triggered by the JotDrawController's
     *  touchesMoved event.
     */

    func drawTouchMovedToPoint(touchPoint: CGPoint) {
        self.pointsCounter = self.pointsCounter + 1
        self.pointsArray.append(JotTouchPoint.withPoint(touchPoint))
        if self.pointsCounter == 4 {
            self.pointsArray[3] = JotTouchPoint.withPoint(CGPointMake((self.pointsArray[2].CGPointValue.x + self.pointsArray[4].CGPointValue.x) / 2.0, (self.pointsArray[2].CGPointValue.y + self.pointsArray[4].CGPointValue.y) / 2.0))
            self.bezierPath.startPoint = self.pointsArray[0].CGPointValue
            self.bezierPath.endPoint = self.pointsArray[3].CGPointValue
            self.bezierPath.controlPoint1 = self.pointsArray[1].CGPointValue
            self.bezierPath.controlPoint2 = self.pointsArray[2].CGPointValue
            if self.constantStrokeWidth {
                self.bezierPath.startWidth = self.strokeWidth
                self.bezierPath.endWidth = self.strokeWidth
            }
            else {
                var velocity: CGFloat = (self.pointsArray[3] as! JotTouchPoint).velocityFromPoint((self.pointsArray[0] as! JotTouchPoint))
                velocity = (kJotVelocityFilterWeight * velocity) + ((1.0 - kJotVelocityFilterWeight) * self.lastVelocity)
                let strokeWidth: CGFloat = self.strokeWidthForVelocity(velocity)
                self.bezierPath.startWidth = self.lastWidth
                self.bezierPath.endWidth = strokeWidth
                self.lastWidth = strokeWidth
                self.lastVelocity = velocity
            }
            self.pointsArray[0] = self.pointsArray[3]
            self.pointsArray[1] = self.pointsArray[4]
            self.drawBitmap()
            self.pointsArray.removeLast()
            self.pointsArray.removeLast()
            self.pointsArray.removeLast()
            self.pointsCounter = 1
        }
    }
    /**
     *  Tells the JotDrawView to handle a touchesEnded event.
     *
     *  @note This method is triggered by the JotDrawController's
     *  touchesEnded event.
     */

    func drawTouchEnded() {
        self.drawBitmap()
        self.lastVelocity = self.initialVelocity
        self.lastWidth = self.strokeWidth
    }
    /**
     *  Overlays the drawing on the given background image, rendering
     *  the drawing at the full resolution of the image.
     *
     *  @param image The background image to draw on top of.
     *
     *  @return An image of the rendered drawing on the background image.
     *
     *  @note Call drawOnImage: in JotViewController
     *  to trigger this method.
     */

    func drawOnImage(image: UIImage) -> UIImage {
        return self.drawAllPathsImageWithSize(image.size, backgroundImage: image)
    }
    /**
     *  Renders the drawing at full resolution for the given size.
     *
     *  @param size The size of the image to return.
     *
     *  @return An image of the rendered drawing.
     *
     *  @note Call renderWithSize: in JotViewController
     *  to trigger this method.
     */

    func renderDrawingWithSize(size: CGSize) -> UIImage {
        //return self.drawAllPathsImageWithSize(size, backgroundImage: nil)
        return self.drawAllPathsImageWithSize(size, backgroundImage: UIImage())
    }

    convenience init() {
        self.init()
            self.backgroundColor = UIColor.clearColor()
            self.strokeWidth = 10.0
            self.strokeColor = UIColor.blackColor()
            self.pathsArray = NSMutableArray() as [AnyObject]
            self.constantStrokeWidth = false
            self.pointsArray = NSMutableArray() as [AnyObject]
            self.initialVelocity = kJotInitialVelocity
            self.lastVelocity = initialVelocity
            self.lastWidth = strokeWidth
            self.userInteractionEnabled = false
    }

    func drawBitmap() {
        UIGraphicsBeginImageContextWithOptions(self.bounds.size, false, UIScreen.mainScreen().scale)
        //if let image = self.cachedImage {
            self.cachedImage.drawAtPoint(CGPointZero)
        //}
        self.bezierPath.jotDrawBezier()
        //self.bezierPath = nil
        if self.pointsArray.count == 1 {
            let touchPoint: JotTouchPoint = self.pointsArray.first as! JotTouchPoint
            touchPoint.strokeColor = self.strokeColor
            touchPoint.strokeWidth = 1.5 * self.strokeWidthForVelocity(1.0)
            self.pathsArray.append(touchPoint)
            touchPoint.strokeColor.setFill()
            self.touchBezier.jotDrawBezierPoint(touchPoint.CGPointValue(), withWidth: touchPoint.strokeWidth)
        }
        self.cachedImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        self.setNeedsDisplay()
    }

    override func drawRect(rect: CGRect) {
        self.cachedImage.drawInRect(rect)
        self.bezierPath.jotDrawBezier()
    }

    func strokeWidthForVelocity(velocity: CGFloat) -> CGFloat {
        let a = ( self.strokeWidth * (1.0 - kJotRelativeMinStrokeWidth) )
        return self.strokeWidth - ( a / (1.0 + CGFloat( pow(M_E, Double((-( (velocity - self.initialVelocity) / self.initialVelocity ) )) ))))

    }

    /*
    func bezierPath() -> JotTouchBezier {
        if !bezierPath {
            self.bezierPath = JotTouchBezier.withColor(self.strokeColor)
            self.pathsArray.append(bezierPath)
            self.bezierPath.constantWidth = self.constantStrokeWidth
        }
        return bezierPath
    }
    */

    func drawAllPathsImageWithSize(size: CGSize, backgroundImage: UIImage) -> UIImage {
        let scale: CGFloat = size.width / CGRectGetWidth(self.bounds)
        UIGraphicsBeginImageContextWithOptions(self.bounds.size, false, scale)
        backgroundImage.drawInRect(CGRectMake(0.0, 0.0, CGRectGetWidth(self.bounds), CGRectGetHeight(self.bounds)))
        self.drawAllPaths()
        let drawnImage: UIImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return UIImage(CGImage:drawnImage.CGImage!, scale: 1.0, orientation:drawnImage.imageOrientation)
    }

    func drawAllPaths() {
        for path in self.pathsArray {
            if path.isKindOfClass(JotTouchBezier) {
                (path as! JotTouchBezier).jotDrawBezier()
            } else if path.isKindOfClass(JotTouchPoint) {
                (path as! JotTouchPoint).strokeColor.setFill()
                self.touchBezier.jotDrawBezierPoint((path as! JotTouchPoint).CGPointValue(), withWidth: (path as! JotTouchPoint).strokeWidth)
            }
        }
    }

}