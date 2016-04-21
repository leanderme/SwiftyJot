//
//  JotTextEditView.h
//  jot
//
//  Created by Laura Skelton on 4/30/15.
//
//
import UIKit
import Foundation
import QuartzCore
import SnapKit


@objc public protocol JotTextEditViewDelegate: class {
    /**
     *  Called whenever the JotTextEditView ends text editing (keyboard entry) mode.
     *
     *  @param textString    The new text string after editing
     */
    optional func jotTextEditViewFinishedEditingWithNewTextString(textString: String)
}

/**
 *  Private class to handle text editing. Change the properties
 *  in a JotViewController instance to configure this private class.
 */
public class JotTextEditView: UIView, JotTextEditViewDelegate {
    
    public var textView: UITextView!
    public var textContainer: UIView!
    var topGradient: CAGradientLayer!
    var bottomGradient: CAGradientLayer!
    
    
    /**
     *  The delegate of the JotTextEditView, which receives an update
     *  when the JotTextEditView is finished editing text, with the
     *  revised textString.
     */
    weak var delegate: JotTextEditViewDelegate?
    /**
     *  Whether or not the JotTextEditView is actively in edit mode.
     *  This property controls whether or not the keyboard is displayed
     *  and the JotTextEditView is visible.
     *
     *  @note Set the JotViewController state to JotViewStateEditingText
     *  to turn on editing mode in JotTextEditView.
     */
    var isEditing: Bool {
        get {
            return self.isEditing
        }
        set(isEditing) {
            if isEditing != isEditing {
                self.isEditing = isEditing
                self.textContainer.hidden = !isEditing
                self.userInteractionEnabled = isEditing
                if isEditing {
                    self.backgroundColor = UIColor(white: 0.0, alpha: 0.5)
                    self.textView.becomeFirstResponder()
                }
                else {
                    self.backgroundColor = UIColor.clearColor()
                    self.textString = self.textView.text!
                    self.textView.resignFirstResponder()
                    //if self.delegate.respondsToSelector("jotTextEditViewFinishedEditingWithNewTextString:") {
                        self.delegate!.jotTextEditViewFinishedEditingWithNewTextString!(textString)
                    //}
                }
            }
        }
    }

    /**
     *  The text string the JotTextEditView is currently displaying.
     *
     *  @note Set textString in JotViewController
     *  to control or read this property.
     */
    public var textString : String = " " {
        
        //First this
        willSet {
            print("Old value is \(textString), new value is \(newValue)")
        }
        
        //value is set
        
        //Finaly this
        didSet {
            print("Old value is \(oldValue), new value is \(textString)")
            textView.text = textString
            textView.setContentOffset(CGPointZero, animated: false)
        }
    }
    /**
     *  The color of the text displayed in the JotTextEditView.
     *
     *  @note Set textColor in JotViewController
     *  to control this property.
     */
    /*
    var textColor: UIColor {
        get {
            return self.textColor
        }
        set(textColor) {
            if textColor != textColor {
                self.textColor = textColor
                self.textView.textColor = textColor
            }
        }
    }
    */
    
    //True model data
    var textColor : UIColor = UIColor.blackColor() {
        
        //First this
        willSet {
            print("Old value is \(textColor), new value is \(newValue)")
        }
        
        //value is set
        
        //Finaly this
        didSet {
            print("Old value is \(oldValue), new value is \(textColor)")
            self.textView.textColor = textColor
        }
    }

    /**
     *  The font of the text displayed in the JotTextEditView.
     *
     *  @note Set font in JotViewController to control this property.
     *  To change the default size of the font, you must also set the
     *  fontSize property to the desired font size.
     */
    /*
    var font: UIFont {
        get {
            return self.font
        }
        set(font) {
            if font != font {
                self.font = font
                //self.textView.font = font(size: fontSize)
            }
        }
    }
    */
    //True model data
    var font : UIFont = UIFont.systemFontOfSize(20) {
        
        //First this
        willSet {
            print("Old value is \(font), new value is \(newValue)")
        }
        
        //value is set
        
        //Finaly this
        didSet {
            print("Old value is \(oldValue), new value is \(font)")
        }
    }

    /**
     *  The font size of the text displayed in the JotTextEditView.
     *
     *  @note Set fontSize in JotViewController to control this property,
     *  which overrides the size of the font property.
     */
    /*
    var fontSize: CGFloat {
        get {
            return self.fontSize
        }
        set(fontSize) {
            if fontSize != fontSize {
                self.fontSize = fontSize
                //self.textView.font = font(size: fontSize)
            }
        }
    }
    */
    //True model data
    var fontSize : CGFloat = 0 {
        
        //First this
        willSet {
            print("Old value is \(fontSize), new value is \(newValue)")
        }
        
        //value is set
        
        //Finaly this
        didSet {
            print("Old value is \(oldValue), new value is \(fontSize)")
        }
    }

    /**
     *  The alignment of the text displayed in the JotTextEditView.
     *
     *  @note Set textAlignment in JotViewController to control this property.
     */
    var textAlignment: NSTextAlignment {
        get {
            return self.textAlignment
        }
        set(textAlignment) {
            if textAlignment != textAlignment {
                self.textAlignment = textAlignment
                self.textView.textAlignment = textAlignment
            }
        }
    }

    /**
     *  The view insets of the text displayed in the JotTextEditView. By default,
     *  the text that extends beyond the insets of the text input view will fade out
     *  with a gradient to the edges of the JotTextEditView. If clipBoundsToEditingInsets
     *  is true, then the text will be clipped at the inset instead of fading out.
     *
     *  @note Set textEditingInsets in JotViewController to control this property.
     */
    /*
    var textEditingInsets: UIEdgeInsets {
        get {
            return self.textEditingInsets
        }
        set(textEditingInsets) {
            if !UIEdgeInsetsEqualToEdgeInsets(textEditingInsets, textEditingInsets) {
                self.textEditingInsets = textEditingInsets
                self.textView.snp_makeConstraints { (make) -> Void in
                    make.edges.equalTo(self.textContainer).inset(textEditingInsets)
                }
                self.textView.layoutIfNeeded()
                self.textView.setContentOffset(CGPointZero, animated: false)
            }
        }
    } */
    
    //True model data
    var textEditingInsets : UIEdgeInsets = UIEdgeInsets.init(top: 0, left: 0, bottom: 0, right: 0) {
        
        //First this
        willSet {
            print("Old value is \(textEditingInsets), new value is \(newValue)")
        }
        
        //value is set
        
        //Finaly this
        didSet {
            print("Old value is \(oldValue), new value is \(textEditingInsets)")
            self.textView.snp_makeConstraints { (make) -> Void in
                make.edges.equalTo(self.textContainer).inset(textEditingInsets)
            }
            self.textView.layoutIfNeeded()
            self.textView.setContentOffset(CGPointZero, animated: false)
        }
    }

    /**
     *  By default, clipBoundsToEditingInsets is false, and the text that extends 
     *  beyond the insets of the text input view will fade out with a gradient 
     *  to the edges of the JotTextEditView. If clipBoundsToEditingInsets is true, 
     *  then the text will be clipped at the inset instead of fading out.
     *
     *  @note Set clipBoundsToEditingInsets in JotViewController to control this property.
     */
    /*
    var clipBoundsToEditingInsets: Bool {
        get {
            return self.clipBoundsToEditingInsets
        }
        set(clipBoundsToEditingInsets) {
            if clipBoundsToEditingInsets != clipBoundsToEditingInsets {
                self.clipBoundsToEditingInsets = clipBoundsToEditingInsets
                self.textView.clipsToBounds = clipBoundsToEditingInsets
                self.setupGradientMask()
            }
        }
    } */
    
    //True model data
    var clipBoundsToEditingInsets : Bool = true {
        
        //First this
        willSet {
            print("Old value is \(clipBoundsToEditingInsets), new value is \(newValue)")
        }
        
        //value is set
        
        //Finaly this
        didSet {
            print("Old value is \(oldValue), new value is \(clipBoundsToEditingInsets)")
            self.textView.clipsToBounds = clipBoundsToEditingInsets
            self.setupGradientMask()
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame:frame)
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder);
    }

    convenience init() {
        self.init(frame: CGRectZero)
            self.backgroundColor = UIColor.clearColor()
            self.font = UIFont.systemFontOfSize(40.0)
            self.fontSize = 40.0
            self.textEditingInsets = UIEdgeInsetsMake(0.0, 0.0, 0.0, 0.0)
            self.textContainer = UIView()
            self.textContainer.layer.masksToBounds = true
            self.addSubview(self.textContainer)
            /*
            self.textContainer.mas_makeConstraints({(make: MASConstraintMaker) -> Void in
                make.top.and.left.and.right.equalTo(self)
                make.bottom.equalTo(self).offset(0.0)
            })
            */
            self.textContainer.snp_makeConstraints { (make) -> Void in
                make.top.equalTo(self)
                make.left.equalTo(self)
                make.right.equalTo(self)
                make.bottom.equalTo(self).offset(0)
            }
            self.textView = UITextView()
            self.textView.backgroundColor = UIColor.clearColor()
            self.textView.text = self.textString
            self.textView.keyboardType = .Default
            self.textView.returnKeyType = .Done
            self.textView.clipsToBounds = false
            //self.textView.delegate = self
            self.textContainer.addSubview(self.textView)
            self.textView.snp_makeConstraints { (make) -> Void in
                //make.edges.equalTo(self.textContainer).inset(textEditingInsets!)
            }
            /*
            self.textView.mas_makeConstraints({(make: MASConstraintMaker) -> Void in
                make.edges.equalTo(self.textContainer).insets(textEditingInsets)
            })
            */
            self.textContainer.hidden = true
            self.userInteractionEnabled = false
            NSNotificationCenter.defaultCenter().addObserverForName(UIKeyboardWillChangeFrameNotification, object: nil, queue: nil, usingBlock: {(note: NSNotification) -> Void in
                self.textContainer.layer.removeAllAnimations()
                let keyboardRectEnd: CGRect = note.userInfo![UIKeyboardFrameEndUserInfoKey]!.CGRectValue
                let duration:NSTimeInterval = note.userInfo![UIKeyboardAnimationDurationUserInfoKey] as! Double
                /*
                self.textContainer.mas_updateConstraints({(make: MASConstraintMaker) -> Void in
                    make.bottom.equalTo(self).offset(-CGRectGetHeight(keyboardRectEnd))
                })
                */
                self.textContainer.snp_makeConstraints { (make) -> Void in
                    make.bottom.equalTo(self).offset(-CGRectGetHeight(keyboardRectEnd))
                }
                UIView.animateWithDuration(duration, delay: 0.0, options: .BeginFromCurrentState, animations: {() -> Void in
                    self.textContainer.layoutIfNeeded()
                }, completion: { _ in })
            })

    }

    deinit {
        self.textView.delegate = nil
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }

    override public func layoutSubviews() {
        super.layoutSubviews()
        self.setupGradientMask()
    }

    func setupGradientMask() {
        if !self.clipBoundsToEditingInsets {
            self.textContainer.layer.mask = self.gradientMask
            let percentTopOffset: CGFloat = self.textEditingInsets.top / CGRectGetHeight(self.textContainer.bounds)
            let percentBottomOffset: CGFloat = self.textEditingInsets.bottom / CGRectGetHeight(self.textContainer.bounds)
            self.gradientMask.locations = [0.0 * percentTopOffset, 0.8 * percentTopOffset, 0.9 * percentTopOffset, 1.0 * percentTopOffset, 1.0 - (1.0 * percentBottomOffset), 1.0 - (0.9 * percentBottomOffset), 1.0 - (0.8 * percentBottomOffset), 1.0 - (0.0 * percentBottomOffset)]
            self.gradientMask.frame = CGRectMake(0.0, 0.0, CGRectGetWidth(self.textContainer.bounds), CGRectGetHeight(self.textContainer.bounds))
        }
        else {
            self.textContainer.layer.mask = nil
        }
    }
    
    var gradientMask: CAGradientLayer {
        get {
            //if !gradientMask {
                self.gradientMask = CAGradientLayer()
                self.gradientMask.colors = [UIColor(white:1.0,alpha:0.0).CGColor,
                                            UIColor(white:1.0,alpha:0.4).CGColor,
                                            UIColor(white:1.0,alpha:0.7).CGColor,
                                            UIColor(white:1.0,alpha:1.0).CGColor,
                                            UIColor(white:1.0,alpha:1.0).CGColor,
                                            UIColor(white:1.0,alpha:0.7).CGColor,
                                            UIColor(white:1.0,alpha:0.4).CGColor,
                                            UIColor(white:1.0,alpha:0.0).CGColor]
            //}
            return self.gradientMask
        }
        set(layer) {
            self.gradientMask = CAGradientLayer()
        }
    }
    
    
    //#pragma mark - Text Editing
    
    func textView(textView:UITextView, shouldChangeTextInRange range: NSRange, replacementText text: NSString)-> Bool {
        var replacementText: Bool{
            if (text == "\n") {
                self.isEditing = false
                return false
            }
            /*
            if count(textView.text as String) + (text.length - range.length) > 70 {
                return false
            }
            */
            if text.rangeOfCharacterFromSet(NSCharacterSet.newlineCharacterSet()).location != NSNotFound {
                return false
            }
            return true
        }
        return replacementText
    }
}