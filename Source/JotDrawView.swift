//
//  JotDrawView.h
//  jot
//
//  Created by Laura Skelton on 4/30/15.
//
//
import UIKit
import Foundation

let kJotVelocityFilterWeight: CGFloat = 0.9
let kJotInitialVelocity: CGFloat = 220.0
let kJotRelativeMinStrokeWidth: CGFloat = 0.4


/**
 *  Private class to handle touch drawing. Change the properties
 *  in a JotViewController instance to configure this private class.
 */
public class JotDrawView: UIView {
    
    var cachedImage: UIImage?
    var pathsArray: NSMutableArray?
    var pointsArray: NSMutableArray?
    var pointsCounter: Int?
    var lastVelocity: CGFloat?
    var lastWidth: CGFloat?
    var initialVelocity: CGFloat?
    
    var bezierPath:JotTouchBezier! = JotTouchBezier()
    
    /*
    public var bezierPath: JotTouchBezier! {
        //First this
        willSet {
            if bezierPath != newValue {
                self.bezierPath = newValue
            }
            print("Old berzierpath value is \(bezierPath), new value is \(newValue)")
        }
        
        didSet {
            print("bezierPath Old value is \(bezierPath), old value is \(oldValue)")
            self.bezierPath.strokeColor = self.strokeColor!
            self.pathsArray!.addObject(self.bezierPath)
            self.bezierPath.constantWidth = self.constantStrokeWidth
        }
    }
    */
    
    /**
     *  Set to YES if you want the stroke width to be constant,
     *  NO if the stroke width should vary depending on drawing
     *  speed.
     *
     *  @note Set drawingConstantStrokeWidth in JotViewController
     *  to control this setting.
     */
    //true model data
    public var constantStrokeWidth: Bool = true {
        //First this
        willSet {
            print("Old value is \(constantStrokeWidth), new value is \(newValue)")
            //self.bezierPath = nil
            self.pointsArray!.removeAllObjects()
            self.pointsCounter = 0
        }
        
        //value is set
        
        //Finaly this
        didSet {
            print("Old value is \(oldValue), new value is \(constantStrokeWidth)")
            self.pointsArray!.removeAllObjects()
            self.pointsCounter = 0
        }
    }
    
    /**
     *  Sets the stroke width if constantStrokeWidth is true,
     *  or sets the base strokeWidth for variable drawing paths.
     *
     *  @note Set drawingStrokeWidth in JotViewController
     *  to control this setting.
     */
    var strokeWidth: CGFloat?
    
    /**
     *  Sets the stroke color. Each path can have its own stroke color.
     *
     *  @note Set drawingColor in JotViewController
     *  to control this setting.
     */
    public var strokeColor: UIColor? {
        didSet {
            print("strokeColor Old value is \(oldValue), new value is \(strokeColor)")
        }
    }
    
    /**
     *  Clears all paths from the drawing, giving a blank slate.
     *
     *  @note Call clearDrawing or clearAll in JotViewController
     *  to trigger this method.
     */

    func clearDrawing() {
        self.cachedImage = nil
        self.pathsArray!.removeAllObjects()
        //self.setupBezierPath(self.strokeColor!)
        //self.bezierPath = JotTouchBezier()
        self.pointsCounter = 0
        self.pointsArray!.removeAllObjects()
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
        self.pointsArray!.removeAllObjects()
        self.pointsArray!.addObject(JotTouchPoint.withPoint(touchPoint))
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
        self.pointsCounter! += 1
        self.pointsArray!.addObject(JotTouchPoint.withPoint(touchPoint))
        
        print("touchPoint: \(touchPoint) and pointsCounter: \(pointsCounter)")
        
        if self.pointsCounter == 4 {
            self.pointsArray![3] = JotTouchPoint.withPoint(CGPointMake((self.pointsArray![2].CGPointValue.x + self.pointsArray![4].CGPointValue.x) / 2.0, (self.pointsArray![2].CGPointValue.y + self.pointsArray![4].CGPointValue.y) / 2.0))
            
            print("attempting to set \(self.bezierPathInstance().startPoint)")
            self.bezierPathInstance().startPoint = self.pointsArray![0].CGPointValue
            self.bezierPathInstance().endPoint = self.pointsArray![3].CGPointValue
            self.bezierPathInstance().controlPoint1 = self.pointsArray![1].CGPointValue
            self.bezierPathInstance().controlPoint2 = self.pointsArray![2].CGPointValue

            print("is constantStrokeWidth \(self.constantStrokeWidth)") // crashes when true -> out of range
            
            if self.constantStrokeWidth {
                self.bezierPathInstance().startWidth = self.strokeWidth
                self.bezierPathInstance().endWidth = self.strokeWidth
            } else {
                var velocity: CGFloat = (self.pointsArray![3] as! JotTouchPoint).velocityFromPoint((self.pointsArray![0] as! JotTouchPoint))
                velocity = (kJotVelocityFilterWeight * velocity) + ((1.0 - kJotVelocityFilterWeight) * self.lastVelocity!)
                let strokeWidth: CGFloat = self.strokeWidthForVelocity(velocity)
                self.bezierPathInstance().startWidth = self.lastWidth!
                self.bezierPathInstance().endWidth = strokeWidth
                self.lastWidth = strokeWidth
                self.lastVelocity = velocity
            }
            
            /*
            print(self.pathsArray![0])
            print(self.pathsArray![1])
            print(self.pathsArray![3])
            print(self.pathsArray![4])
            */
            self.pointsArray![0] = self.pointsArray![3]
            self.pointsArray![1] = self.pointsArray![4]
            self.drawBitmap()
            self.pointsArray!.removeLastObject()
            self.pointsArray!.removeLastObject()
            self.pointsArray!.removeLastObject()
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
        print("touch ended")
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
        print("drawonimage")
        print(image.size)
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
        return self.drawAllPathsImageWithSize(size, backgroundImage: nil)
    }

    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override init(frame:CGRect) {
        super.init(frame: frame)
            self.backgroundColor = UIColor.clearColor()
            self.strokeWidth = 10.0
            self.strokeColor = UIColor.blackColor()
            self.pathsArray = NSMutableArray()
            self.constantStrokeWidth = false
            self.pointsArray = NSMutableArray()
            self.initialVelocity = kJotInitialVelocity
            self.lastVelocity = initialVelocity
            self.lastWidth = strokeWidth
            self.userInteractionEnabled = false
            //self.setupBezierPath(self.strokeColor!)
    }

    func drawBitmap() {
        UIGraphicsBeginImageContextWithOptions(self.bounds.size, false, UIScreen.mainScreen().scale)
        let image: UIImage? = self.cachedImage
        if image != nil {
            self.cachedImage!.drawAtPoint(CGPointZero)
        }
        self.bezierPathInstance().jotDrawBezier()
        //self.setupBezierPath(self.strokeColor!)
        //self.bezierPath = JotTouchBezier()
        print("pointsArray \(self.pointsArray?.count)")
        if self.pointsArray!.count == 1 {
            print("drawing point")
            let touchPoint: JotTouchPoint = self.pointsArray!.firstObject as! JotTouchPoint
            touchPoint.strokeColor = self.strokeColor
            touchPoint.strokeWidth = 1.5 * self.strokeWidthForVelocity(1.0)
            self.pathsArray!.addObject(touchPoint)
            touchPoint.strokeColor.setFill()
            self.bezierPathInstance().jotDrawBezierPoint(touchPoint.CGPointValue(), withWidth: touchPoint.strokeWidth)
        }
        self.cachedImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        self.setNeedsDisplay()
    }

    override public func drawRect(rect: CGRect) {
        let image:UIImage? = self.cachedImage
        let path: JotTouchBezier? = self.bezierPathInstance()
        if image != nil && path != nil {
            //self.bezierPath! = JotTouchBezier()
            self.cachedImage!.drawInRect(rect)
            self.bezierPathInstance().jotDrawBezier()
        }
    }

    func strokeWidthForVelocity(velocity: CGFloat) -> CGFloat {
        let a = ( self.strokeWidth! * (1.0 - kJotRelativeMinStrokeWidth) )
        return self.strokeWidth! - ( a / (1.0 + CGFloat( pow(M_E, Double((-( (velocity - self.initialVelocity!) / self.initialVelocity! ) )) ))))

    }

    func bezierPathInstance() -> JotTouchBezier {
        if (self.bezierPath == nil) {
            print("bezierPath is nil")
            self.bezierPath = JotTouchBezier.withColor(self.strokeColor!)
            self.pathsArray?.addObject(bezierPath)
            self.bezierPath.constantWidth = self.constantStrokeWidth
        }
        return bezierPath
    }

    func drawAllPathsImageWithSize(size: CGSize, backgroundImage: UIImage?) -> UIImage {
        let scale: CGFloat = size.width / CGRectGetWidth(self.bounds)
        print("drawAllPathsImageWithSize")
        print(scale)
        
        UIGraphicsBeginImageContextWithOptions(self.bounds.size, false, scale)
        if let image = backgroundImage {
            print("isbackgroundimage")
            image.drawInRect(CGRectMake(0.0, 0.0, CGRectGetWidth(self.bounds), CGRectGetHeight(self.bounds)))
        }
        self.drawAllPaths()
        let drawnImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        if let theDrawnImage = drawnImage {
          return UIImage(CGImage:theDrawnImage.CGImage!, scale: 1.0, orientation:theDrawnImage.imageOrientation)
        } else {
            print("failing. no theDrawnImage")
            return UIImage()
        }
    }

    func drawAllPaths() {
        print("pathsArray is")
        print(self.pathsArray!)
        for path in self.pathsArray! {
            print(path)
            if path is JotTouchBezier {
                let bezierPath = path as! JotTouchBezier
                bezierPath.jotDrawBezier()
                print("jotDrawbezier called by drawAllPath")
            } else if path is JotTouchPoint {
                let pointPath = path as! JotTouchPoint
                pointPath.strokeColor.setFill()
                self.bezierPathInstance().jotDrawBezierPoint(pointPath.CGPointValue(), withWidth: pointPath.strokeWidth!)
                print("jotDrawBezierPoint called by drawAllPaths")
            }
        }
    }

}