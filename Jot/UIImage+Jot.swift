//
//  UIImage+Jot.h
//  Jot
//
//  Created by Laura Skelton on 4/30/15.
//
//
import UIKit
import Foundation
/**
 *  Private category to create single-color background images for
 *  rendering jot's drawing and text sketchpad or whiteboard-style
 *  instead of image annotation-style.
 */
extension UIImage {
    
    /**
     *  Creates a single-color image with the given color and size.
     *
     *  @param color The color for the image
     *  @param size  The size the image should be
     *
     *  @return An image of the given color and size
     */
    class func jotImageWithColor(color: UIColor, size: CGSize) -> UIImage {
        UIGraphicsBeginImageContextWithOptions(size, false, UIScreen.mainScreen().scale)
        color.setFill()
        CGContextFillRect(UIGraphicsGetCurrentContext(), CGRectMake(0.0, 0.0, size.width, size.height))
        var colorImage: UIImage = UIImage()
        colorImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return colorImage
    }
}