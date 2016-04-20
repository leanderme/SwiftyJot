//
//  JotViewController.h
//  jot
//
//  Created by Laura Skelton on 4/30/15.
//
//
import UIKit
import Foundation
import SnapKit
/**
 *  The possible states of the JotViewController
 */
enum JotViewState : Int    /**
         *  The default state, which does not allow
         *  any touch interactions.
         */
 {
    case Default
    /**
         *  The drawing state, where drawing with touch
         *  gestures will create colored lines in the view.
         */
    case Drawing
    /**
         *  The text state, where pinch, pan, and rotate
         *  gestures will manipulate the displayed text, and
         *  a tap gesture will switch to text editing mode.
         */
    case Text
    /**
         *  The text editing state, where the contents of
         *  the text string can be edited with the keyboard.
         */
    case EditingText
}


@objc protocol JotViewControllerDelegate: class {
    /**
     *  Called whenever the JotViewController begins or ends text editing (keyboard entry) mode.
     *
     *  @param jotViewController The draw text view controller
     *  @param isEditing    YES if entering edit (keyboard text entry) mode, NO if exiting edit mode
     */
    @objc func jotViewController(jotViewController: JotViewController, isEditingText isEditing: Bool)
}

/**
 *  Public class for you to use to create a jot view! Import <jot.h>
 *  into your view controller, then create an instance of JotViewController
 *  and add it as a child of your view controller. Set the state of the
 *  JotViewController to switch between manipulating text and drawing.
 *
 *  @note You will be able to see your view controller's view through
 *  the jot view, so you can display the jot view above either a colored
 *  background for a sketchpad/whiteboard-like interface, or above a photo
 *  for a photo annotation interface.
 */
public class JotViewController: UIViewController {
    /**
     *  The delegate of the JotViewController instance.
     */
    weak var delegate: JotViewControllerDelegate?
    
    var tapRecognizer: UITapGestureRecognizer!
    var pinchRecognizer: UIPinchGestureRecognizer!
    var rotationRecognizer: UIRotationGestureRecognizer!
    var panRecognizer: UIPanGestureRecognizer!
    var drawView: JotDrawView!
    var textEditView: JotTextEditView!
    var textView: JotTextView!
    
    
    /**
     *  The state of the JotViewController. Change the state between JotViewStateDrawing
     *  and JotViewStateText in response to your own editing controls to toggle between
     *  the different modes. Tapping while in JotViewStateText will automatically switch
     *  to JotViewStateEditingText, and tapping the keyboard's Done button will automatically
     *  switch back to JotViewStateText.
     *
     *  @note The JotViewController's delegate will get updates when it enters and exits
     *  text editing mode, in case you need to update your interface to reflect this.
     */
     var state: JotViewState {
        get {
            return self.state
        }
        set(state) {
            if state != state {
                self.state = state
                self.textView.hidden = self.textEditView.isEditing == (state == .EditingText)
                //let isEditing = (state == .EditingText)
                //func jotViewController(jotViewController: JotViewController, isEditingText isEditing: Bool)
                if state == .EditingText {
                    self.delegate!.jotViewController(self, isEditingText: true)
                }
                /*
                self.drawingContainer.multipleTouchEnabled =
                    self.tapRecognizer.enabled =
                    self.panRecognizer.enabled =
                    self.pinchRecognizer.enabled =
                    self.rotationRecognizer.enabled = (state == .Text)
                */
            }
        }
    }

    /**
     *  The font of the text displayed in the JotTextView and JotTextEditView.
     *
     *  @note To change the default size of the font, you must also set the
     *  fontSize property to the desired font size.
     */
    var font: UIFont {
        get {
            return self.font
        }
        set(font) {
            if font != font {
                self.font = font
                self.textView.font = self.textEditView.font
                //self.textView.font = self.textEditView.font = font
            }
        }
    }

    /**
     *  The initial font size of the text displayed in the JotTextView before pinch zooming,
     *  and the fixed font size of the JotTextEditView.
     *
     *  @note This property overrides the size of the font property.
     */
    var fontSize: CGFloat {
        get {
            return self.fontSize
        }
        set(fontSize) {
            if fontSize != fontSize {
                self.fontSize = fontSize
                self.textView.fontSize = self.textEditView.fontSize
                //self.textView.fontSize = self.textEditView.fontSize = fontSize
            }
        }
    }

    /**
     *  The color of the text displayed in the JotTextView and the JotTextEditView.
     */
    var textColor: UIColor {
        get {
            return self.textColor
        }
        set(textColor) {
            if textColor != textColor {
                self.textColor = textColor
                self.textView.textColor = self.textEditView.textColor
                //self.textView.textColor = self.textEditView.textColor = textColor
            }
        }
    }

    /**
     *  The text string the JotTextView and JotTextEditView are displaying.
     */
    var textString: String {
        get {
            return self.textString
        }
        set(textString) {
            if !(textString == textString) {
                self.textString = textString
                if !(self.textView.textString == textString) {
                    self.textView.textString = textString
                }
                if !(self.textEditView.textString == textString) {
                    self.textEditView.textString = textString
                }
            }
        }
    }

    /**
     *  The alignment of the text displayed in the JotTextView, which only
     *  applies if fitOriginalFontSizeToViewWidth is true, and the alignment of the
     *  text displayed in the JotTextEditView regardless of other settings.
     */
    var textAlignment: NSTextAlignment {
        get {
            return self.textAlignment
        }
        set(textAlignment) {
            if textAlignment != textAlignment {
                self.textAlignment = textAlignment
                self.textView.textAlignment = self.textEditView.textAlignment
                //self.textView.textAlignment = self.textEditView.textAlignment = textAlignment
            }
        }
    }

    /**
     *  Sets the stroke color for drawing. Each drawing path can have its own stroke color.
     */
    var drawingColor: UIColor {
        get {
            return self.drawingColor
        }
        set(drawingColor) {
            if drawingColor != drawingColor {
                self.drawingColor = drawingColor
                self.drawView.strokeColor = drawingColor
            }
        }
    }

    /**
     *  Sets the stroke width for drawing if constantStrokeWidth is true, or sets
     *  the base strokeWidth for variable drawing paths constantStrokeWidth is false.
     */
    var drawingStrokeWidth: CGFloat {
        get {
            return self.drawingStrokeWidth
        }
        set(drawingStrokeWidth) {
            if drawingStrokeWidth != drawingStrokeWidth {
                self.drawingStrokeWidth = drawingStrokeWidth
                self.drawView.strokeWidth = drawingStrokeWidth
            }
        }
    }

    /**
     *  Set to YES if you want the stroke width for drawing to be constant,
     *  NO if the stroke width should vary depending on drawing speed.
     */
    var drawingConstantStrokeWidth: Bool {
        get {
            return self.drawingConstantStrokeWidth
        }
        set(drawingConstantStrokeWidth) {
            if drawingConstantStrokeWidth != drawingConstantStrokeWidth {
                self.drawingConstantStrokeWidth = drawingConstantStrokeWidth
                self.drawView.constantStrokeWidth = drawingConstantStrokeWidth
            }
        }
    }

    /**
     *  The view insets of the text displayed in the JotTextEditView. By default,
     *  the text that extends beyond the insets of the text input view will fade out
     *  with a gradient to the edges of the JotTextEditView. If clipBoundsToEditingInsets
     *  is true, then the text will be clipped at the inset instead of fading out.
     */
    var textEditingInsets: UIEdgeInsets {
        get {
            return self.textEditingInsets
        }
        set(textEditingInsets) {
            if !UIEdgeInsetsEqualToEdgeInsets(textEditingInsets, textEditingInsets) {
                self.textEditingInsets = textEditingInsets
                self.textEditView.textEditingInsets = textEditingInsets
            }
        }
    }

    /**
     *  The initial insets of the text displayed in the JotTextView, which only
     *  applies if fitOriginalFontSizeToViewWidth is true. If fitOriginalFontSizeToViewWidth
     *  is true, then initialTextInsets sets the initial insets of the displayed text relative to the
     *  full size of the JotTextView. The user can resize, move, and rotate the text from that
     *  starting position, but the overall proportions of the text will stay the same.
     *
     *  @note This will be ignored if fitOriginalFontSizeToViewWidth is false.
     */
    var initialTextInsets: UIEdgeInsets {
        get {
            return self.initialTextInsets
        }
        set(initialTextInsets) {
            if !UIEdgeInsetsEqualToEdgeInsets(initialTextInsets, initialTextInsets) {
                self.initialTextInsets = initialTextInsets
                self.textView.initialTextInsets = initialTextInsets
            }
        }
    }

    /**
     *  If fitOriginalFontSizeToViewWidth is true, then the text will wrap to fit within the width
     *  of the JotTextView, with the given initialTextInsets, if any. The layout will reflect
     *  the textAlignment property as well as the initialTextInsets property. If this is false,
     *  then the text will be displayed as a single line, and will ignore any initialTextInsets and
     *  textAlignment settings
     */
    var fitOriginalFontSizeToViewWidth: Bool {
        get {
            return self.fitOriginalFontSizeToViewWidth
        }
        set(fitOriginalFontSizeToViewWidth) {
            if fitOriginalFontSizeToViewWidth != fitOriginalFontSizeToViewWidth {
                self.fitOriginalFontSizeToViewWidth = fitOriginalFontSizeToViewWidth
                self.textView.fitOriginalFontSizeToViewWidth = fitOriginalFontSizeToViewWidth
                if fitOriginalFontSizeToViewWidth {
                    self.textEditView.textAlignment = self.textAlignment
                }
                else {
                    self.textEditView.textAlignment = .Left
                }
            }
        }
    }

    /**
     *  By default, clipBoundsToEditingInsets is false, and the text that extends
     *  beyond the insets of the text input view in the JotTextEditView will fade out with
     *  a gradient to the edges of the JotTextEditView. If clipBoundsToEditingInsets is true,
     *  then the text will be clipped at the inset instead of fading out in the JotTextEditView.
     */
    var clipBoundsToEditingInsets: Bool {
        get {
            return self.clipBoundsToEditingInsets
        }
        set(clipBoundsToEditingInsets) {
            if clipBoundsToEditingInsets != clipBoundsToEditingInsets {
                self.clipBoundsToEditingInsets = clipBoundsToEditingInsets
                self.textEditView.clipBoundsToEditingInsets = clipBoundsToEditingInsets
            }
        }
    }

    var drawingContainer: JotDrawingContainer!

    /**
     *  Clears all paths from the drawing in and sets the text to an empty string, giving a blank slate.
     */

    func clearAll() {
        self.clearDrawing()
        self.clearText()
    }
    /**
     *  Clears only the drawing, leaving the text alone.
     */

    func clearDrawing() {
        self.drawView.clearDrawing()
    }
    /**
     *  Clears only the text, leaving the drawing alone.
     */

    func clearText() {
        self.textString = ""
        self.textView.clearText()
    }
    /**
     *  Overlays the drawing and text on the given background image at the full
     *  resolution of the image.
     *
     *  @param image The background image to draw on top of.
     *
     *  @return An image of the rendered drawing and text on the background image.
     */

    public func drawOnImage(image: UIImage) -> UIImage {
        let drawImage: UIImage = self.drawView.drawOnImage(image)
        return self.textView.drawTextOnImage(drawImage)
    }
    /**
     *  Renders the drawing and text at the view's size with a transparent background.
     *
     *  @return An image of the rendered drawing and text.
     */

    public func renderImage() -> UIImage {
        return self.renderImageWithScale(1.0)
    }
    /**
     *  Renders the drawing and text at the view's size with a colored background.
     *
     *  @return An image of the rendered drawing and text on a colored background.
     */

    public func renderImageOnColor(color: UIColor) -> UIImage {
        return self.renderImageWithScale(1.0, onColor: color)
    }
    /**
     *  Renders the drawing and text at the view's size multiplied by the given scale
     *  with a transparent background.
     *
     *  @return An image of the rendered drawing and text.
     */

    public func renderImageWithScale(scale: CGFloat) -> UIImage {
        return self.renderImageWithSize(CGSizeMake(CGRectGetWidth(self.drawingContainer.frame) * scale, CGRectGetHeight(self.drawingContainer.frame) * scale))
    }
    /**
     *  Renders the drawing and text at the view's size multiplied by the given scale
     *  with a colored background.
     *
     *  @return An image of the rendered drawing and text on a colored background.
     */

    public func renderImageWithScale(scale: CGFloat, onColor color: UIColor) -> UIImage {
        return self.renderImageWithSize(CGSizeMake(CGRectGetWidth(self.drawingContainer.frame) * scale, CGRectGetHeight(self.drawingContainer.frame) * scale), onColor: color)
    }

    public convenience init() {
        self.init()
            self.drawView = JotDrawView()
            self.textEditView = JotTextEditView()
            //self.textEditView.delegate = self
            self.textView = JotTextView()
            self.drawingContainer = JotDrawingContainer()
            //self.drawingContainer.delegate = self
            self.font = self.textView.font
            self.textEditView.font = self.font
            self.fontSize = self.textView.fontSize
            self.textEditView.fontSize = self.fontSize
            self.textAlignment = self.textView.textAlignment
            self.textEditView.textAlignment = .Left
            self.textColor = self.textView.textColor
            self.textEditView.textColor = self.textColor
            self.textString = ""
            self.drawingColor = self.drawView.strokeColor
            self.drawingStrokeWidth = self.drawView.strokeWidth
            self.textEditingInsets = self.textEditView.textEditingInsets
            self.initialTextInsets = self.textView.initialTextInsets
            self.state = .Default
            self.pinchRecognizer = UIPinchGestureRecognizer(target: self, action: #selector(JotViewController.handlePinchOrRotateGesture(_:)))
            self.pinchRecognizer.delegate = self
            self.rotationRecognizer = UIRotationGestureRecognizer(target: self, action: #selector(JotViewController.handlePinchOrRotateGesture(_:)))
            self.rotationRecognizer.delegate = self
            self.panRecognizer = UIPanGestureRecognizer(target: self, action: #selector(JotViewController.handlePanGesture(_:)))
            self.panRecognizer.delegate = self
            self.tapRecognizer = UITapGestureRecognizer(target: self, action: #selector(JotViewController.handleTapGesture(_:)))
            self.tapRecognizer.delegate = self
    }
    
    deinit {
        self.textEditView.delegate = nil
        self.drawingContainer.delegate = nil
    }

    override public func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.clearColor()
        self.drawingContainer.clipsToBounds = true
        self.view!.addSubview(self.drawingContainer)
        self.drawingContainer.snp_makeConstraints { (make) -> Void in
            make.edges.equalTo(self.view!)
        }
        self.drawingContainer.addSubview(self.drawView)
        self.drawView.snp_makeConstraints { (make) -> Void in
            make.edges.equalTo(self.drawingContainer)
        }
        self.drawingContainer.addSubview(self.textView)
        self.textView.snp_makeConstraints { (make) -> Void in
            make.edges.equalTo(self.drawingContainer)
        }
        self.view!.addSubview(self.textEditView)
        self.textEditView.snp_makeConstraints { (make) -> Void in
            make.edges.equalTo(self.view!)
        }
        self.drawingContainer.addGestureRecognizer(self.tapRecognizer)
        self.drawingContainer.addGestureRecognizer(self.panRecognizer)
        self.drawingContainer.addGestureRecognizer(self.rotationRecognizer)
        self.drawingContainer.addGestureRecognizer(self.pinchRecognizer)
    }

    public func renderImageWithSize(size: CGSize) -> UIImage {
        let renderDrawingImage: UIImage = self.drawView.renderDrawingWithSize(size)
        return self.textView.drawTextOnImage(renderDrawingImage)
    }

    public func renderImageWithSize(size: CGSize, onColor color: UIColor) -> UIImage {
        let colorImage: UIImage = UIImage.jotImageWithColor(color, size: size)
        let renderDrawingImage: UIImage = self.drawView.drawOnImage(colorImage)
        return self.textView.drawTextOnImage(renderDrawingImage)
    }

    func handleTapGesture(recognizer: UIGestureRecognizer) {
        if !(self.state == .EditingText) {
            self.state = .EditingText
        }
    }

    func handlePanGesture(recognizer: UIGestureRecognizer) {
        self.textView.handlePanGesture(recognizer)
    }

    func handlePinchOrRotateGesture(recognizer: UIGestureRecognizer) {
        self.textView.handlePinchOrRotateGesture(recognizer)
    }

    func jotDrawingContainerTouchBeganAtPoint(touchPoint: CGPoint) {
        if self.state == .Drawing {
            self.drawView.drawTouchBeganAtPoint(touchPoint)
        }
    }

    func jotDrawingContainerTouchMovedToPoint(touchPoint: CGPoint) {
        if self.state == .Drawing {
            self.drawView.drawTouchMovedToPoint(touchPoint)
        }
    }

    func jotDrawingContainerTouchEnded() {
        if self.state == .Drawing {
            self.drawView.drawTouchEnded()
        }
    }

    public func gestureRecognizer(gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWithGestureRecognizer otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }

    public func gestureRecognizer(gestureRecognizer: UIGestureRecognizer, shouldBeRequiredToFailByGestureRecognizer otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        if (gestureRecognizer is UITapGestureRecognizer) {
            return true
        }
        return false
    }

    func jotTextEditViewFinishedEditingWithNewTextString(textString: String) {
        if self.state == .EditingText {
            self.state = .Text
        }
        self.textString = textString
        self.delegate!.jotViewController(self, isEditingText: false)

    }

}

extension JotViewController: UIGestureRecognizerDelegate {
    
}
