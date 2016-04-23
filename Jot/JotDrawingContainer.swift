//
//  JotDrawingContainer.h
//  jot
//
//  Created by Laura Skelton on 5/12/15.
//
//
import UIKit
import Foundation

protocol JotDrawingContainerDelegate: class {
    
    /**
     *  Tells the delegate to handle a touchesBegan event.
     *
     *  @param touchPoint The point in this view's coordinate
     *  system where the touch began.
     */
    func jotDrawingContainerTouchBeganAtPoint(touchPoint: CGPoint)
    
    /**
     *  Tells the delegate to handle a touchesMoved event.
     *
     *  @param touchPoint The point in this view's coordinate
     *  system to which the touch moved.
     */
    
    func jotDrawingContainerTouchMovedToPoint(touchPoint: CGPoint)
    
    /**
     *  Tells the delegate to handle a touchesEnded event.
     */
    func jotDrawingContainerTouchEnded()
}

class JotDrawingContainer: UIView {
    /**
     *  The delegate of the JotDrawingContainer, which receives
     *  updates about touch events in the drawing container.
     */
    weak var delegate: JotDrawingContainerDelegate?

    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        super.touchesBegan(touches, withEvent: event)
        print("touchesBegan")
        self.delegate!.jotDrawingContainerTouchBeganAtPoint(touches.first!.locationInView(self))
    }
    
    override func touchesMoved(touches: Set<UITouch>, withEvent event: UIEvent?) {
        super.touchesMoved(touches, withEvent: event)
        print("touchesMoved")
        self.delegate!.jotDrawingContainerTouchMovedToPoint(touches.first!.locationInView(self))
    }


    override func touchesEnded(touches: Set<UITouch>, withEvent event: UIEvent?) {
        super.touchesEnded(touches, withEvent: event)
        print("touchesEnded")
        self.delegate!.jotDrawingContainerTouchEnded()
    }
}