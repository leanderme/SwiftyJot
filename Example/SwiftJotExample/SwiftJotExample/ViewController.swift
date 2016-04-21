//
//  ViewController.swift
//  SwiftJotExample
//
//  Created by Leander Melms on 20.04.16.
//  Copyright © 2016 Leander Melms. All rights reserved.
//

import UIKit
import SwiftyJot


let kPencilImageName:String = ""
let kTextImageName:String = ""
let kClearImageName: String = ""
let kSaveImageName:String = ""

class ViewController: UIViewController, JotViewControllerDelegate{
    
    
    let jotViewController: JotViewController = JotViewController()

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.jotViewController.renderImageOnColor(UIColor.blueColor())
        
        
        self.jotViewController.delegate = self
        self.jotViewController.state = .Drawing;
        self.jotViewController.textColor = UIColor.blackColor()
        self.jotViewController.font = UIFont.boldSystemFontOfSize(64)
        self.jotViewController.fontSize = 64
        self.jotViewController.textEditingInsets = UIEdgeInsetsMake(12, 6, 0, 6)
        self.jotViewController.initialTextInsets = UIEdgeInsetsMake(6, 6, 6, 6)
        //self.jotViewController.fitOriginalFontSizeToViewWidth
        self.jotViewController.textAlignment = .Left
        self.jotViewController.drawingColor = UIColor.cyanColor()
        
        self.addChildViewController(self.jotViewController)
        self.view.addSubview(self.jotViewController.view)
        self.jotViewController.didMoveToParentViewController(self)
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

