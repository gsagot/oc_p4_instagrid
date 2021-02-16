//
//  ViewLayout.swift
//  Instagrid
//
//  Created by Gilles Sagot on 15/02/2021.
//

import UIKit

class MainView: UIView, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    let stackHorizontalTop      = UIStackView()
    let stackHorizontalBottom   = UIStackView()
    let stackVertical           = UIStackView()
    var gridLayout              = [UIButton]()
    var styleButtons            = [UIButton]()
    var stackStyleButtons       = UIStackView()
    var myView                  = UIView()
    var currentStyle:Style      = .standard
    var index = Int()
    var imagePicker = UIImagePickerController()
    var currentImage = UIImage()
    var currentController = UIViewController()
    var isLandscape:Bool = false
    
    enum Style {
        case bigtop, bigbottom, standard
    }
    
    
    func layoutSubview(controller : UIViewController) {
        // Do any additional setup after loading the view.
        currentController = controller
        // Create View Container.
        // Add Color background and give size.
        myView.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 1)
        myView.frame = CGRect(x:0,y:0,width:300,height:300)
        // And add AutoLayout.
        myView.center = CGPoint(x: self.bounds.midX, y: self.bounds.midY)
        myView.autoresizingMask = [UIView.AutoresizingMask.flexibleLeftMargin, UIView.AutoresizingMask.flexibleRightMargin, UIView.AutoresizingMask.flexibleTopMargin, UIView.AutoresizingMask.flexibleBottomMargin]
        // Add to main view.
        self.addSubview(myView)
        
        
        // Array of 4 UIImageView
        prepareAllImages()
        
        // Prepare a first horizontal stack view with first images from previous array (index 0 and 1).
        stackHorizontalTop.frame = CGRect(x:0,y:0,width:271,height:128)
        arrangeStack(stackHorizontalTop, axis: .horizontal, with: [gridLayout[0],gridLayout[1]])
        
        // Prepare a second horizontal stack view with first images from previous array (index 2 and 3).
        stackHorizontalBottom.frame = CGRect(x:0,y:0,width:271,height:128)
        arrangeStack (stackHorizontalBottom, axis: .horizontal, with: [gridLayout[2],gridLayout[3]])
        
        // Prepare a vertical stack in order to host the two previous horizontal stack.
        stackVertical.frame = CGRect(x:15,y:15,width:271,height:271)
        arrangeStack (stackVertical, axis:.vertical, with: [stackHorizontalTop,stackHorizontalBottom])
        
        // Add StackVertical in myView
        myView.addSubview(stackVertical)
        
        
        
        // Prepare Buttons that choose layout ...
        createStyleButtons ()
        
        // Selected
        styleButtons[2].setImage(UIImage(named: "Selected"), for: .normal)
        
        // Put them in a stack
        self.addSubview(stackStyleButtons)
        
        updateSubviews()
    
        
        
        /*
        for i in 0...3 {
            gridLayout[i].imageView?.contentMode = .scaleAspectFill
        }
         */
        
    }
    
    
    func updateSubviews() {
 
        if isLandscape == true {
            placeStyleButtonsInStack(inAxis: .vertical)
            
        } else {
            placeStyleButtonsInStack(inAxis: .horizontal)
            
        }
    
    }

    
    func arrangeStack (_ stack: UIStackView, axis: NSLayoutConstraint.Axis, with: [UIView]){
        stack.axis = axis
        stack.distribution = .fillEqually;
        stack.alignment = .fill;
        stack.spacing = 15;
        stack.translatesAutoresizingMaskIntoConstraints = true
        
        for i in 0...1{
            stack.addArrangedSubview(with[i])
        }

    }
    
    func prepareAllImages () {
        for i in 0...3 {
            let newButton = UIButton()
            newButton.backgroundColor = UIColor(white: CGFloat(Float.random(in: 1...1)), alpha: 1)
            newButton.setImage(UIImage(named: "Plus"), for: .normal)
            newButton.tag = i
            newButton.addTarget(self, action:#selector(buttonClicked), for: .touchUpInside)
            newButton.imageView?.contentMode = .scaleAspectFill
            
            gridLayout.append(newButton)
            
        }
        
    }
    
    
    @objc func buttonClicked(sender:UIButton) {

        pickImage()
        
        index = sender.tag

    }
    
    
    func pickImage ()
    {
        if UIImagePickerController.isSourceTypeAvailable(.savedPhotosAlbum){
                    imagePicker.sourceType = .savedPhotosAlbum
                    imagePicker.allowsEditing = false
                    imagePicker.delegate = self
                    currentController.present(imagePicker, animated: false, completion: nil)
            
        }

    }
    
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        if let pickedImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            currentImage = pickedImage
        }
        currentController.dismiss(animated: true, completion: nil)
        gridLayout[index].setImage(currentImage, for: .normal)
        
    }
    
    func createStyleButtons (){
        
        for i in 0...2{
            
            let newButton = UIButton()
            let newImage = UIImage(named: "Layout " + String(i+1))
            newButton.setBackgroundImage(newImage, for: .normal)
            newButton.tag = i
            newButton.addTarget(self, action: #selector(chooseStyle), for: .touchUpInside)
            newButton.contentHorizontalAlignment = .fill
            newButton.contentVerticalAlignment = .fill
            styleButtons.append(newButton)
            stackStyleButtons.addArrangedSubview(styleButtons[i])
            
        }
        
    }

    
    func placeStyleButtonsInStack (inAxis: NSLayoutConstraint.Axis){
        
        stackStyleButtons.distribution = .fillEqually;
        stackStyleButtons.alignment = .fill;
        stackStyleButtons.spacing = 30;
        var center = CGPoint()
        var frame = CGRect()
        
        
        switch inAxis {
            
        case .horizontal:
            stackStyleButtons.axis = .horizontal
            center = CGPoint(x: self.bounds.midX, y: self.bounds.maxY - 80 - 20)
            frame = CGRect(x:0,y:0,width:300,height:80)
            
        default:
            stackStyleButtons.axis = .vertical
            center = CGPoint(x: self.bounds.maxX - 80 - 20, y: self.bounds.midY )
            frame = CGRect(x:0,y:0,width:80,height:300)
        }
        
   
        stackStyleButtons.frame = frame
        stackStyleButtons.center = center
        stackStyleButtons.autoresizingMask = [UIView.AutoresizingMask.flexibleLeftMargin, UIView.AutoresizingMask.flexibleRightMargin, UIView.AutoresizingMask.flexibleTopMargin, UIView.AutoresizingMask.flexibleBottomMargin]

    }
    
    
    
    @objc func chooseStyle (sender:UIButton){
        
        for i in 0...2 {
            styleButtons[i].setImage(UIImage(), for: .normal)
        }

        sender.setImage(UIImage(named: "Selected"), for: .normal)

        switch sender.tag {
        
        case 0:
            stackHorizontalTop.removeArrangedSubview(gridLayout[1])
            stackHorizontalBottom.addArrangedSubview(gridLayout[3])
            gridLayout[1].isHidden = true
            gridLayout[3].isHidden = false
            
        case 1:
            stackHorizontalBottom.removeArrangedSubview(gridLayout[3])
            stackHorizontalTop.addArrangedSubview(gridLayout[1])
            gridLayout[3].isHidden = true
            gridLayout[1].isHidden = false
            
        default:
            stackHorizontalBottom.addArrangedSubview(gridLayout[3])
            stackHorizontalTop.addArrangedSubview(gridLayout[1])
            gridLayout[1].isHidden = false
            gridLayout[3].isHidden = false
            
        }
        
    }

    
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

}
