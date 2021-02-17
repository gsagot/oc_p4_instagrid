//
//  CompoView.swift
//  Teki
//
//  Created by Gilles Sagot on 01/02/2021.
//

import UIKit

class CompoView: UIView {
    
    /*
     // Only override draw() if you perform custom drawing.
     // An empty implementation adversely affects performance during animation.
     override func draw(_ rect: CGRect) {
     // Drawing code
     }
     */
    
    var images   = [UIImageView]()
    var buttons  = [UIButton]()
    var currentImage = UIImage()
    var index = Int()
    var imageToShare = UIImage()
    
    let imgSize: Double = round(127.5)

    
    enum Style {
        case bigtop, bigbottom, standard
    }
    
    // Watch properties and update with selection
    var style: Style = .bigbottom{
        didSet {
            presentStyle(style)
            imageToShare = asImage()
        }
    }
    
    
    // Image that could be share is updated
    func asImage() -> UIImage {
        let renderer = UIGraphicsImageRenderer(bounds: bounds)
        return renderer.image { rendererContext in
            layer.render(in: rendererContext.cgContext)
        }
    }
    
    // MARK: - PREPARE ALL SUBVIEWS
    
    // Prepare all images
    func layoutImages (){
        for i in 0...1
        {
            for j in 0...1
            {
                // FIND POSITION
                // THEN POSITION IN ARRAY IS LIKE THIS
                // |0|2|
                // |1|3|
                let positionX:Double = (Double(i) * imgSize) + (Double(i) * 15) + 15.0
                let positionY:Double = (Double(j) * imgSize) + (Double(j) * 15) + 15.0
                // LOAD IMAGE
                //let newImage = UIGraphicsGetImageFromCurrentImageContext()
                let newImage = UIImage()
                // SET IMAGE VIEW
                let imageView = UIImageView(image: newImage)
                imageView.backgroundColor = UIColor(red: 255.0/255.0, green: 255.0/255.0, blue: 255.0/255.0, alpha: 1)
                imageView.clipsToBounds = true
                imageView.contentMode = .scaleAspectFill
                imageView.frame = CGRect(x:positionX,y:positionY,width:imgSize,height:imgSize)
                // APPEND TO COLLECTION
                images.append(imageView)
                images[i*2+j].isHidden = false
                self.addSubview(images[i*2+j])
            }
        }
    }
    // prepare all buttons
    func layoutButtons () {
        for i in 0...3 {
            let buttonImage = UIImage(named: "Plus")
            let button = UIButton()
            
            button.setBackgroundImage(buttonImage, for: .normal)
            button.frame = CGRect(x:0,y:0,width:40,height:40)
            button.center = images[i].center
            button.tag = i
            
            buttons.append(button)
            self.addSubview(buttons[i])
        }
    }
    
    // MARK: - UPDATE LAYOUT WITH USER CHOICE
    
    // reset all images and buttons are in 2X2 grid
    func reset () {
        for i in 0...1 {
            for j in 0...1 {
                // FIND POSITION
                // THEN POSITION IN ARRAY IS LIKE THIS
                // |0|2|
                // |1|3|
                let positionX:Double = (Double(i) * imgSize) + (Double(i) * 15) + 15.0
                let positionY:Double = (Double(j) * imgSize) + (Double(j) * 15) + 15.0
                images[i*2+j].frame = CGRect(x:positionX,y:positionY,width:imgSize,height:imgSize)
                images[i*2+j].isHidden = false
                
                buttons[i*2+j].isHidden = false
                buttons[i*2+j].center = images[i*2+j].center
            }
        }
    }
    // Update everything with user choose 
    func presentStyle(_ style: Style) {
        reset()
        switch style {
        case .bigtop:
            images[0].frame = CGRect(x:15,y:15,width:270,height:imgSize)
            images[1].frame = CGRect(x:15,y:(imgSize + 30),width:127.5,height:imgSize)
            images[2].isHidden = true
            buttons[0].center = images[0].center
            buttons[1].center = images[1].center
            buttons[2].isHidden = true
        case .bigbottom:
            images[0].frame = CGRect(x:15,y:15,width:imgSize,height:imgSize)
            images[1].frame = CGRect(x:15,y:(imgSize + 30),width:270,height:imgSize)
            images[3].isHidden = true
            buttons[0].center = images[0].center
            buttons[1].center = images[1].center
            buttons[3].isHidden = true
        case .standard:
            reset()
        }//End Style switch
        
    }//End SetStyle Function
}
