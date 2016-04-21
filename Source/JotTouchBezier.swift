//
//  JotTouchBezier.h
//  jot
//
//  Created by Laura Skelton on 4/30/15.
//
//
import UIKit
import Foundation

let kJotDrawStepsPerBezier: Int = 300

/**
 *  Private class to handle drawing variable-width cubic bezier paths in a JotDrawView.
 */
public class JotTouchBezier: NSObject {
    /**
     *  The start point of the cubic bezier path.
     */
    var startPoint: CGPoint?
    /**
     *  The end point of the cubic bezier path.
     */
    var endPoint: CGPoint?
    /**
     *  The first control point of the cubic bezier path.
     */
    var controlPoint1: CGPoint?
    /**
     *  The second control point of the cubic bezier path.
     */
    var controlPoint2: CGPoint?
    /**
     *  The starting width of the cubic bezier path.
     */
    var startWidth: CGFloat?
    /**
     *  The ending width of the cubic bezier path.
     */
    var endWidth: CGFloat?
    /**
     *  The stroke color of the cubic bezier path.
     */
    var strokeColor: UIColor! = UIColor.cyanColor()
    /**
     *  YES if the line is a constant width, NO if variable width.
     */
    var constantWidth: Bool?
    /**
     *  Returns an instance of JotTouchBezier with the given stroke color.
     *
     *  @param color       The color to use for drawing the bezier path.
     *
     *  @return An instance of JotTouchBezier
     */

    class func withColor(color: UIColor) -> JotTouchBezier {
        let touchBezier: JotTouchBezier = JotTouchBezier()
        touchBezier.strokeColor = color
        return touchBezier
    }
    
    /**
     *  Draws the JotTouchBezier in the current graphics context, using the
     *  strokeColor and transitioning from the start width to the end width
     *  along the length of the curve.
     */
    func jotDrawBezier() {
        if (self.constantWidth == true) {
            let bezierPath: UIBezierPath = UIBezierPath()
            print(self.startPoint)
            bezierPath.moveToPoint(self.startPoint!)
            bezierPath.addCurveToPoint(self.endPoint!, controlPoint1: self.controlPoint1!, controlPoint2: self.controlPoint2!)
            bezierPath.lineWidth = self.startWidth!
            bezierPath.lineCapStyle = .Round
            self.strokeColor.setStroke()
            bezierPath.strokeWithBlendMode(.Normal, alpha: 1.0)
        }
        else {
            self.strokeColor.setFill()
            let widthDelta: CGFloat = self.endWidth! - self.startWidth!
            for i in 0..<kJotDrawStepsPerBezier {
                let cgfloat = CGFloat(i)
                let t:CGFloat = cgfloat / CGFloat(kJotDrawStepsPerBezier)
                let tt:CGFloat = t * t
                let ttt:CGFloat = tt * t
                let u:CGFloat = 1 - t
                let uu:CGFloat = u * u
                let uuu:CGFloat = uu * u
                var x: CGFloat = uuu * self.startPoint!.x
                x += 3 * uu * t * self.controlPoint1!.x
                x += 3 * u * tt * self.controlPoint2!.x
                x += ttt * self.endPoint!.x
                var y: CGFloat = uuu * self.startPoint!.y
                y += 3 * uu * t * self.controlPoint1!.y
                y += 3 * u * tt * self.controlPoint2!.y
                y += ttt * self.endPoint!.y
                let pointWidth: CGFloat = self.startWidth! + (ttt * widthDelta)
                self.jotDrawBezierPoint(CGPointMake(x, y), withWidth:pointWidth)
            }
        }
    }
    /**
     *  Draws a single circle at the given point in the current graphics context,
     *  using the current fillColor of the context and the given width.
     *
     *  @param point       The CGPoint to use as the center of the circle to be drawn.
     *  @param width       The diameter of the circle to be drawn at the given point.
     */

    func jotDrawBezierPoint(point: CGPoint, withWidth width: CGFloat) {
        if let context = UIGraphicsGetCurrentContext() {
            return CGContextFillEllipseInRect(context, CGRectInset(CGRectMake(point.x, point.y, 0, 0), -width / 2, -width / 2));
        } else {
            return
        }
    }
}