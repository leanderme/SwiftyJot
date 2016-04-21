//
//  JotTouchPoint.h
//  jot
//
//  Created by Laura Skelton on 4/30/15.
//
//
import UIKit
import Foundation
/**
 *  Private class to handle timestamped touch events for drawing
 *  variable-width bezier curves in a JotDrawView, and for 
 *  representing single-touch-point events for drawing dots of
 *  a given width and color in the JotDrawView.
 */
class JotTouchPoint: NSObject {
    /**
     *  The CGPoint where the touch event occurred.
     */
    var point: CGPoint!
    /**
     *  The timestamp of the touch event, used later to calculate the
     *  speed that a variable-width bezier curve was drawn with so that
     *  the stroke width can be made thinner or wider accordingly.
     */
    var timestamp: NSDate!
    /**
     *  The stroke color to use for drawing this as a single-touch-point dot.
     */
    var strokeColor: UIColor!
    /**
     *  The stroke width to use for drawing this as a single-touch-point dot.
     */
    var strokeWidth: CGFloat = 0.0
    /**
     *  Returns an instance of JotTouchPoint with the given CGPoint
     *
     *  @param point The CGPoint where the touch event occurred
     *
     *  @return An instance of JotTouchPoint
     */

    class func withPoint(point: CGPoint) -> JotTouchPoint {
        let touchPoint: JotTouchPoint = JotTouchPoint()
        touchPoint.point = point
        touchPoint.timestamp = NSDate()
        return touchPoint
    }
    /**
     *  Calculates the velocity between two points, based on their locations
     *  and the time interval between them.
     *
     *  @param point The point from which to calculate the velocity of the touch movement.
     *
     *  @return The velocity between the two points
     */

    func velocityFromPoint(fromPoint: JotTouchPoint) -> CGFloat {
        let distance: CGFloat = sqrt((pow((self.point!.x - fromPoint.point!.x), 2)
            + pow((self.point!.y - fromPoint.point!.y),2)));
        
        let timeInterval = CGFloat(fabs(Double((self.timestamp!.timeIntervalSinceDate(fromPoint.timestamp!)))))
        return distance / timeInterval
    }
    /**
     *  The CGPoint representing the location of the touch event for this JotTouchPoint.
     *
     *  @return The CGPoint value of this JotTouchPoint
     */

    func CGPointValue() -> CGPoint {
        return self.point
    }
}
//
//  JotTouchPoint.m
//  jot
//
//  Created by Laura Skelton on 4/30/15.
//
//