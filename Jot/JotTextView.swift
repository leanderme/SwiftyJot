import UIKit
import Foundation

/**
 *  Private class to handle text display and gesture interactions.
 *  Change the properties in a JotViewController instance to 
 *  configure this private class.
 */
class JotTextView: UIView {
    
    var textLabel: UILabel!
    var textEditingContainer: UIView!
    var textEditingView: UITextView!
    var referenceRotateTransform: CGAffineTransform!
    var currentRotateTransform: CGAffineTransform!
    var referenceCenter: CGPoint!
    var activePinchRecognizer: UIPinchGestureRecognizer!
    var activeRotationRecognizer: UIRotationGestureRecognizer!
    
    /**
     *  The text string the JotTextView is currently displaying.
     *
     *  @note Set textString in JotViewController
     *  to control or read this property.
     */
    var textString : String = " " {
        willSet {
            if !(textString == newValue) {
                self.textString = newValue
            }
        }
        didSet {
            let center: CGPoint = self.textLabel.center
            self.textLabel.text = textString
            self.sizeLabel()
            self.textLabel.center = center
        }
    }

    /**
     *  The color of the text displayed in the JotTextView.
     *
     *  @note Set textColor in JotViewController
     *  to control this property.
     */
    var textColor : UIColor = UIColor.blueColor() {
        willSet {
            if textColor != newValue {
                self.textColor = newValue
            }
        }
        didSet {
            self.textLabel.textColor = textColor
        }
    }

    /**
     *  The font of the text displayed in the JotTextView.
     *
     *  @note Set font in JotViewController to control this property.
     *  To change the default size of the font, you must also set the
     *  fontSize property to the desired font size.
     */
    //True model data
    var font : UIFont = UIFont() {
        
        //First this
        willSet {
            if font != newValue {
                self.font = newValue
            }
        }
        didSet {
            self.adjustLabelFont()
        }
    }

    /**
     *  The initial font size of the text displayed in the JotTextView. The
     *  displayed text's font size will get proportionally larger or smaller 
     *  than this size if the viewer pinch zooms the text.
     *
     *  @note Set fontSize in JotViewController to control this property,
     *  which overrides the size of the font property.
     */
    //True model data
    var fontSize : CGFloat = 0 {
        willSet {
            if fontSize != newValue {
                self.fontSize = newValue
            }
        }
        didSet {
            self.adjustLabelFont()
        }
    }

    /**
     *  The alignment of the text displayed in the JotTextView, which only
     *  applies if fitOriginalFontSizeToViewWidth is true.
     *
     *  @note Set textAlignment in JotViewController to control this property,
     *  which will be ignored if fitOriginalFontSizeToViewWidth is false.
     */
    /*
    var textAlignment: NSTextAlignment {
        get {
            return self.textAlignment
        }
        set(textAlignment) {
            if textAlignment != textAlignment {
                self.textAlignment = textAlignment
                self.textLabel.textAlignment = self.textAlignment
                self.sizeLabel()
            }
        }
    }
    */
    //True model data
    var textAlignment : NSTextAlignment = NSTextAlignment.Center {
        willSet {
            if textAlignment != newValue {
                self.textAlignment = newValue
            }
        }
        didSet {
            self.textLabel.textAlignment = self.textAlignment
            self.sizeLabel()
        }
    }
    

    /**
     *  The initial insets of the text displayed in the JotTextView, which only
     *  applies if fitOriginalFontSizeToViewWidth is true. If fitOriginalFontSizeToViewWidth
     *  is true, then initialTextInsets sets the initial insets of the displayed text relative to the
     *  full size of the JotTextView. The user can resize, move, and rotate the text from that
     *  starting position, but the overall proportions of the text will stay the same.
     *
     *  @note Set initialTextInsets in JotViewController to control this property,
     *  which will be ignored if fitOriginalFontSizeToViewWidth is false.
     */
    var initialTextInsets : UIEdgeInsets = UIEdgeInsets.init(top: 0, left: 0, bottom: 0, right: 0) {
        willSet {
            if !UIEdgeInsetsEqualToEdgeInsets(initialTextInsets, newValue) {
                self.initialTextInsets = newValue
            }
        }
        didSet {
            self.sizeLabel()
        }
    }

    /**
     *  If fitOriginalFontSizeToViewWidth is true, then the text will wrap to fit within the width
     *  of the JotTextView, with the given initialTextInsets, if any. The layout will reflect
     *  the textAlignment property as well as the initialTextInsets property. If this is false,
     *  then the text will be displayed as a single line, and will ignore any initialTextInsets and
     *  textAlignment settings
     *
     *  @note Set fitOriginalFontSizeToViewWidth in JotViewController to control this property.
     */
    //True model data
    var fitOriginalFontSizeToViewWidth : Bool = true {
        willSet {
            if fitOriginalFontSizeToViewWidth != newValue {
                self.fitOriginalFontSizeToViewWidth = newValue
            }
        }
        didSet {
            self.textLabel.numberOfLines = (fitOriginalFontSizeToViewWidth ? 0 : 1)
            self.sizeLabel()
        }
    }

    /**
     *  Clears text from the drawing, giving a blank slate.
     *
     *  @note Call clearText or clearAll in JotViewController
     *  to trigger this method.
     */
    func clearText() {
        self.theScale = 1.0
        self.textLabel.transform = CGAffineTransformIdentity
        self.textString = ""
    }
    
    
    /**
     *  Tells the JotTextView to handle a pan gesture.
     *
     *  @param recognizer The pan gesture recognizer to handle.
     *
     *  @note This method is triggered by the JotDrawController's
     *  internal pan gesture recognizer.
     */
    func handlePanGesture(recognizer: UIGestureRecognizer) {
        if !(recognizer is UIPanGestureRecognizer) {
            return
        }
        switch recognizer.state {
            case .Began:
                self.referenceCenter = self.textLabel.center

            case .Changed:
                let panTranslation: CGPoint = (recognizer as! UIPanGestureRecognizer).translationInView(self)
                self.textLabel.center = CGPointMake(self.referenceCenter.x + panTranslation.x, self.referenceCenter.y + panTranslation.y)
            case .Ended:
                self.referenceCenter = self.textLabel.center

            default:
                break
        }

    }
    
    /**
     *  Tells the JotTextView to handle a pinch or rotate gesture.
     *
     *  @param recognizer The pinch or rotation gesture recognizer to handle.
     *
     *  @note This method is triggered by the JotDrawController's
     *  internal pinch and rotation gesture recognizers.
     */
    func handlePinchOrRotateGesture(recognizer: UIGestureRecognizer) {
        switch recognizer.state {
            case .Began:
                if (recognizer is UIRotationGestureRecognizer) {
                    self.currentRotateTransform = self.referenceRotateTransform
                    self.activeRotationRecognizer = (recognizer as! UIRotationGestureRecognizer)
                }
                else {
                    self.activePinchRecognizer = (recognizer as! UIPinchGestureRecognizer)
                }

            case .Changed:
                var currentTransform: CGAffineTransform = self.referenceRotateTransform
                if (recognizer is UIRotationGestureRecognizer) {
                    self.currentRotateTransform = self.applyRecognizer(recognizer, toTransform: self.referenceRotateTransform)
                }
                currentTransform = self.self.applyRecognizer(self.activePinchRecognizer, toTransform: currentTransform)
                currentTransform = self.self.applyRecognizer(self.activeRotationRecognizer, toTransform: currentTransform)
                self.textLabel.transform = currentTransform

            case .Ended:
               if (recognizer is UIRotationGestureRecognizer) {
                    self.referenceRotateTransform = self.self.applyRecognizer(recognizer, toTransform: self.referenceRotateTransform)
                    self.currentRotateTransform = self.referenceRotateTransform
                    //self.activeRotationRecognizer = nil
                }
                else if (recognizer is UIPinchGestureRecognizer) {
                    self.theScale *= (recognizer as! UIPinchGestureRecognizer).scale
                    //self.activePinchRecognizer = nil
                }


            default:
                break
        }

    }

    /*
    override init(frame: CGRect) {
        super.init(frame:frame)
    }
    */
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder);
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
            self.backgroundColor = UIColor.clearColor()
            self.initialTextInsets = UIEdgeInsetsMake(0.0, 0.0, 0.0, 0.0)
            self.fontSize = 60.0
            self.theScale = 1.0
            self.font = UIFont.systemFontOfSize(self.fontSize)
            self.textAlignment = .Center
            self.textColor = UIColor.whiteColor()
            self.textString = "test"
            self.textLabel = UILabel()
            if self.fitOriginalFontSizeToViewWidth {
                self.textLabel.numberOfLines = 0
            }
            self.textLabel.font = self.font
            self.textLabel.textColor = self.textColor
            self.textLabel.textAlignment = self.textAlignment
            self.textLabel.center = CGPointMake(CGRectGetMidX(UIScreen.mainScreen().bounds), CGRectGetMidY(UIScreen.mainScreen().bounds))
            self.referenceCenter = CGPointZero
            self.sizeLabel()
            self.addSubview(self.textLabel)
            self.referenceRotateTransform = CGAffineTransformIdentity
            self.currentRotateTransform = CGAffineTransformIdentity
            self.userInteractionEnabled = false
    }
    
 
    override public func layoutSubviews() {
        super.layoutSubviews()
        if CGPointEqualToPoint(self.referenceCenter, CGPointZero) {
            self.textLabel.center = CGPointMake(CGRectGetMidX(self.bounds), CGRectGetMidY(self.bounds))
        }
    }

    func setScale(scale: CGFloat) {
        if scale != scale {
            self.theScale = scale
            self.textLabel.transform = CGAffineTransformIdentity
            let labelCenter: CGPoint = self.textLabel.center
            let scaledLabelFrame: CGRect = CGRectMake(0.0, 0.0, CGRectGetWidth(theLabelFrame) * scale * 1.05, CGRectGetHeight(theLabelFrame) * scale * 1.05)
            let currentFontSize: CGFloat = self.fontSize * scale
            self.textLabel.font = UIFont.systemFontOfSize(currentFontSize)
            self.textLabel.frame = scaledLabelFrame
            self.textLabel.center = labelCenter
            self.textLabel.transform = self.currentRotateTransform
        }
    }

    func setLabelFrame(labelFrame: CGRect) {
        if !CGRectEqualToRect(labelFrame, labelFrame) {
            self.theLabelFrame = labelFrame
            let labelCenter: CGPoint = self.textLabel.center
            let scaledLabelFrame: CGRect = CGRectMake(0.0, 0.0, CGRectGetWidth(labelFrame) * theScale * 1.05, CGRectGetHeight(labelFrame) * theScale * 1.05)
            let labelTransform: CGAffineTransform = self.textLabel.transform
            self.textLabel.transform = CGAffineTransformIdentity
            self.textLabel.frame = scaledLabelFrame
            self.textLabel.transform = labelTransform
            self.textLabel.center = labelCenter
        }
    }

    func adjustLabelFont() {
        var currentFontSize: CGFloat = fontSize * theScale
        var center: CGPoint = self.textLabel.center
        self.textLabel.font = UIFont.systemFontOfSize(currentFontSize)
        self.sizeLabel()
        self.textLabel.center = center
    }

    func sizeLabel() {
        let temporarySizingLabel: UILabel = UILabel()
        temporarySizingLabel.text = textString
        temporarySizingLabel.font = UIFont.systemFontOfSize(fontSize)
        temporarySizingLabel.textAlignment = textAlignment
            var insetViewRect: CGRect
        if fitOriginalFontSizeToViewWidth {
            temporarySizingLabel.numberOfLines = 0
            insetViewRect = CGRectInset(self.bounds, initialTextInsets.left + initialTextInsets.right, initialTextInsets.top + initialTextInsets.bottom)
        }
        else {
            temporarySizingLabel.numberOfLines = 1
            insetViewRect = CGRectMake(0.0, 0.0, CGFloat.max, CGFloat.max)
        }
        let originalSize: CGSize = temporarySizingLabel.sizeThatFits(insetViewRect.size)
        temporarySizingLabel.frame = CGRectMake(0.0, 0.0, originalSize.width * 1.05, originalSize.height * 1.05)
        temporarySizingLabel.center = self.textLabel.center
        self.theLabelFrame = temporarySizingLabel.frame
    }

    func applyRecognizer(recognizer: UIGestureRecognizer, toTransform transform: CGAffineTransform) -> CGAffineTransform {
        /*
        if !recognizer || !((recognizer is UIRotationGestureRecognizer) || (recognizer is UIPinchGestureRecognizer)) {
            return transform
        }
        */
        if (recognizer is UIRotationGestureRecognizer) {
            return CGAffineTransformRotate(transform, (recognizer as! UIRotationGestureRecognizer).rotation)
        }
        let scale: CGFloat = (recognizer as! UIPinchGestureRecognizer).scale
        return CGAffineTransformScale(transform, scale, scale)
    }
    
    //#pragma mark - Image Rendering
    
    /**
     *  Overlays the text on the given background image.
     *
     *  @param image The background image to render text on top of.
     *
     *  @return An image of the rendered drawing on the background image.
     *
     *  @note Call drawOnImage: in JotViewController
     *  to trigger this method.
     */
    func drawTextOnImage(image: UIImage) -> UIImage {
        print("image size is \(image.size)")
        return self.drawTextImageWithSize(image.size, backgroundImage: image)
    }
    
    /**
     *  Renders the text overlay at full resolution for the given size.
     *
     *  @param size The size of the image to return.
     *
     *  @return An image of the rendered text.
     *
     *  @note Call renderWithSize: in JotViewController
     *  to trigger this method.
     */
    func renderDrawTextViewWithSize(size: CGSize) -> UIImage {
        print("renderDrawTextViewWithSize: \(size)")
        return self.drawTextImageWithSize(size, backgroundImage: nil)
    }
    
    //http://stackoverflow.com/questions/12424690/uigraphicsgetcurrentcontext-seems-to-return-nil
    //init with GCSizeZero might be an issue
    func drawTextImageWithSize(size: CGSize, backgroundImage: UIImage?) -> UIImage {
        let scale: CGFloat = size.width / CGRectGetWidth(self.bounds)
        print("drawTextImageWithSize: \(size)")
        UIGraphicsBeginImageContextWithOptions(self.bounds.size, false, scale)
        backgroundImage!.drawInRect(CGRectMake(0.0, 0.0, CGRectGetWidth(self.bounds), CGRectGetHeight(self.bounds)))
        self.layer.renderInContext(UIGraphicsGetCurrentContext()!)
        let drawnImage: UIImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return UIImage(CGImage: drawnImage.CGImage!, scale: 1.0, orientation: drawnImage.imageOrientation)
    }
    
    //True model data
    var theScale : CGFloat = 0 {
        
        //First this
        willSet {
            if theScale != newValue {
                self.theScale = newValue
            }
        }
        didSet {
            self.textLabel.transform = CGAffineTransformIdentity
            let labelCenter: CGPoint = self.textLabel.center
            let scaledLabelFrame: CGRect = CGRectMake(0.0, 0.0, CGRectGetWidth(theLabelFrame) * theScale * 1.05, CGRectGetHeight(theLabelFrame) * theScale * 1.05)
            let currentFontSize: CGFloat = self.fontSize * theScale
            self.textLabel.font = UIFont.systemFontOfSize(currentFontSize)
            self.textLabel.frame = scaledLabelFrame
            self.textLabel.center = labelCenter
            self.textLabel.transform = self.currentRotateTransform
        }
    }

    // true data model
    var theLabelFrame: CGRect = CGRectMake(0.0, 0.0, 0.0, 0.0) {
        willSet {
            if !CGRectEqualToRect(theLabelFrame, newValue) {
                self.theLabelFrame = newValue
            }
        }
        didSet {
            let labelCenter: CGPoint = self.textLabel.center
            let scaledLabelFrame: CGRect = CGRectMake(0.0, 0.0, CGRectGetWidth(theLabelFrame) * theScale * 1.05, CGRectGetHeight(theLabelFrame) * theScale * 1.05)
            let labelTransform: CGAffineTransform = self.textLabel.transform
            self.textLabel.transform = CGAffineTransformIdentity
            self.textLabel.frame = scaledLabelFrame
            self.textLabel.transform = labelTransform
            self.textLabel.center = labelCenter
        }
    }
}