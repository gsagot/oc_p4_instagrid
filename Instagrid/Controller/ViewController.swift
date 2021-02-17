//
//  ViewController.swift
//  Teki
//
//  Created by Gilles Sagot on 28/01/2021.
//

import UIKit

class ViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    let stackHorizontalTop      = UIStackView()
    let stackHorizontalBottom   = UIStackView()
    let stackVertical           = UIStackView()
    var gridLayout              = [UIButton]()
    var styleButtons            = [UIButton]()
    var stackStyleButtons       = UIStackView()
    var composition                  = UIView()
    var currentStyle:Style      = .standard
    var index = Int()
    var imagePicker = UIImagePickerController()
    var currentImage = UIImage()
    var isLandscape:Bool = false
    
    enum Style {
        case bigtop, bigbottom, standard
    }
    
    // MARK: - PREPARE ALL SUBVIEWS
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        // Do any additional setup after loading the view.

        // On load, the device orientation can be .Unknown or .FaceUp ...
        // We need to find something else to hang on. This is a way to fix this
        let orientation = UIApplication.shared.windows.first?.windowScene?.interfaceOrientation
        
        if orientation == .portrait {
            isLandscape = false
        } else if orientation == .landscapeRight || orientation == .landscapeLeft {
            isLandscape = true
        }
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
        // Set composition view
        composition.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 1)
        composition.frame = CGRect(x:0,y:0,width:300,height:300)
        // And add AutoLayout.
        composition.center = CGPoint(x: view.bounds.midX, y: view.bounds.midY)
        composition.autoresizingMask = [UIView.AutoresizingMask.flexibleLeftMargin, UIView.AutoresizingMask.flexibleRightMargin, UIView.AutoresizingMask.flexibleTopMargin, UIView.AutoresizingMask.flexibleBottomMargin]
        // Add to main view.
        view.addSubview(composition)
        
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
        composition.addSubview(stackVertical)
        
        // Prepare Buttons that choose layout ...
        createStyleButtons ()
        
        // Selected
        styleButtons[2].setImage(UIImage(named: "Selected"), for: .normal)
        
        // Put them in a stack
        view.addSubview(stackStyleButtons)
        
        updateSubviews()
    }
    
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        // We can now watch Device orientation
        // And update subviews to match orientation change
        if UIDevice.current.orientation.isLandscape {
            isLandscape = true
            
        }else{
            isLandscape = false
            
        }
        updateSubviews()

    }
    
    func updateSubviews() {
 
        if isLandscape == true {
            placeStyleButtonsInStack(inAxis: .vertical)
            
        } else {
            placeStyleButtonsInStack(inAxis: .horizontal)
            
        }
    
    }
    
    // MARK: - SET COMPOSITION
    
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
    
    // MARK: - ADD USER IMAGE CHOICE IN COMPOSITION
    
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
                    self.present(imagePicker, animated: false, completion: nil)
            
        }

    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        if let pickedImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            currentImage = pickedImage
        }
        self.dismiss(animated: true, completion: nil)
        gridLayout[index].setImage(currentImage, for: .normal)
        
    }
    
    // MARK: - CHANGE APPLICATION LAYOUT BY USER CHOICE
    
    // prepare all buttons
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

    // put buttons in a stack
    
    func placeStyleButtonsInStack (inAxis: NSLayoutConstraint.Axis){
        
        stackStyleButtons.distribution = .fillEqually;
        stackStyleButtons.alignment = .fill;
        stackStyleButtons.spacing = 30;
        var center = CGPoint()
        var frame = CGRect()
        
        
        switch inAxis {
            
        case .horizontal:
            stackStyleButtons.axis = .horizontal
            center = CGPoint(x: view.bounds.midX, y: view.bounds.maxY - 80 - 20)
            frame = CGRect(x:0,y:0,width:300,height:80)
            
        default:
            stackStyleButtons.axis = .vertical
            center = CGPoint(x: view.bounds.maxX - 80 - 20, y: view.bounds.midY )
            frame = CGRect(x:0,y:0,width:80,height:300)
        }
        
   
        stackStyleButtons.frame = frame
        stackStyleButtons.center = center
        stackStyleButtons.autoresizingMask = [UIView.AutoresizingMask.flexibleLeftMargin, UIView.AutoresizingMask.flexibleRightMargin, UIView.AutoresizingMask.flexibleTopMargin, UIView.AutoresizingMask.flexibleBottomMargin]

    }
    
    // Change layout
    
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


    
}

