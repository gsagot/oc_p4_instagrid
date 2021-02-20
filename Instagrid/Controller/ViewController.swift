//
//  ViewController.swift
//  Teki
//
//  Created by Gilles Sagot on 28/01/2021.
//

import UIKit

class ViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    var arrow                   = UIImageView()
    var styleButtons            = [UIButton]()
    var stackStyleButtons       = UIStackView()
    var composition             = CompoView()
    var instagridTitle          = UIImageView()
    var index = Int()
    var imagePicker = UIImagePickerController()
    var currentImage = UIImage()
    var isLandscape:Bool = false
    
    var gestureOnlyLeftAndUp:Bool = false
    
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
        //composition.backgroundColor = UIColor(red: 16, green: 102, blue: 152, alpha: 1)
        composition.frame = CGRect(x:0,y:0,width:300,height:300)
        // And add AutoLayout.
        composition.center = CGPoint(x: view.bounds.midX, y: view.bounds.midY)
        composition.autoresizingMask = [UIView.AutoresizingMask.flexibleLeftMargin, UIView.AutoresizingMask.flexibleRightMargin, UIView.AutoresizingMask.flexibleTopMargin, UIView.AutoresizingMask.flexibleBottomMargin]
        // Layout subviews in composition
        composition.layoutCompoViewOnLoad()
        // Prepare  buttons
        addAction()
        // Add composition to main view.
        view.addSubview(composition)

        // Prepare Buttons that choose layout ...
        createStyleButtons ()
        
        // Selected
        styleButtons[2].setImage(UIImage(named: "Selected"), for: .normal)
        
        // Put them in a stack and add to main view
        view.addSubview(stackStyleButtons)
        
        // Add arrow
        view.addSubview(arrow)
        
        // Add Instagrid title
        instagridTitle.image = UIImage(named: "Instagrid")
        view.addSubview(instagridTitle)
  
    }
    
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        // We can now watch Device orientation
        // And update subviews to match orientation change
        if UIDevice.current.orientation.isLandscape {
            isLandscape = true
            
        }else{
            isLandscape = false
            
        }
        

    }
    
    override func viewDidLayoutSubviews() {
        if isLandscape == true {
            placeStyleButtonsInStack(inAxis: .vertical)
            
        } else {
            placeStyleButtonsInStack(inAxis: .horizontal)
        }
        updateArrow()
        updateInstagridTitle()
        
    }
    
    
    func updateArrow(){
        var center = CGPoint()
        let ref = composition.center
        arrow.frame = CGRect(x: 0, y: 0, width: 10, height: 10)
        
        if isLandscape{
            arrow.image = UIImage(named: "Arrow Left")
            center = CGPoint(x: view.frame.maxX - ref.x - 150 - 20 - 10 , y: view.frame.midY)
        }
        else{
            arrow.image = UIImage(named: "Arrow Up")
            center = CGPoint(x: view.frame.midX, y: view.frame.maxY - ref.y - 150 - 20 - 10 )
        }

        arrow.center = center
        arrow.autoresizingMask = [UIView.AutoresizingMask.flexibleLeftMargin, UIView.AutoresizingMask.flexibleRightMargin, UIView.AutoresizingMask.flexibleTopMargin, UIView.AutoresizingMask.flexibleBottomMargin]
    }
    
    func updateInstagridTitle(){
        var center = CGPoint()
        instagridTitle.frame = CGRect(x: 0, y: 0, width: 116, height: 30)
        
        if isLandscape{
            center = CGPoint(x: view.frame.midX , y: view.frame.midY - 150 - 15)
        }
        else{
            center = CGPoint(x: view.frame.midX , y: view.frame.minY + 30 + 15 )
        }

        instagridTitle.center = center
        instagridTitle.autoresizingMask = [UIView.AutoresizingMask.flexibleLeftMargin, UIView.AutoresizingMask.flexibleRightMargin, UIView.AutoresizingMask.flexibleTopMargin, UIView.AutoresizingMask.flexibleBottomMargin]
    }
    

    // MARK: - ADD ACTION TO BUTTONS IN CODE
     
     private func addAction(){
        let panGestureRecognizer = UIPanGestureRecognizer(target: self, action: #selector(dragImageLayout(_:)))
         composition.addGestureRecognizer(panGestureRecognizer)
        for i in 0..<composition.gridLayout.count{
            composition.gridLayout[i].addTarget(self, action:#selector(buttonClicked), for: .touchUpInside)
        }
     }
     
     // MARK: - POPUP
     
     private func presentUIAlertController() {
         
         let ac = UIAlertController(title: "Instagrid", message: "Setting up your creation first.\n Then you'll be able to share it.", preferredStyle: .alert)
     
         ac.view.tintColor = .blue
         let test = UIAlertAction(title: "Create", style: .default, handler: nil)
         ac.addAction(test)
         present(ac, animated: true)
         
     }
     
     private func presentUIActivityController() {
         
         let item = [composition.imageToShare]
         let ac = UIActivityViewController(activityItems: item as [Any], applicationActivities: nil)
         present(ac, animated: true)
         
     }
    
    // MARK: - SHARE IMAGE
    
    // check if user setting up his creation and put all images in slots
    private func checkCompoIsReady() -> Bool{
        var tests = composition.gridLayout
        var result:Bool=true

        switch composition.style {
        case .bigbottom:
            tests.remove(at: 3)
        case .bigtop:
            tests.remove(at: 2)
        default:
            break
        }
        for i in 0..<tests.count where __CGSizeEqualToSize((tests[i].imageView?.image!.size)! , CGSize(width: 13.5,height: 13.5)){
            
                result = false
                break
        }

       return result
            
    }
    
    // User Drag inside composition...
    @objc func dragImageLayout(_ sender: UIPanGestureRecognizer) {
        if (sender.state == .began || sender.state == .changed) {
            moveCompositionViewWith(gesture: sender)
        }
        else if (sender.state == .ended || sender.state == .cancelled) && gestureOnlyLeftAndUp == true{
            shareCompositionView()
        }
    }
    
    // ...Composition moves for began and changed states...
    private func moveCompositionViewWith(gesture: UIPanGestureRecognizer) {
        let translation = gesture.translation(in: composition)
        if isLandscape == true && translation.x < -0 {
            composition.transform = CGAffineTransform(translationX: translation.x, y: 0)
            gestureOnlyLeftAndUp = true
        }
        else if isLandscape == false && translation.y < -0 {
            composition.transform = CGAffineTransform(translationX: 0, y: translation.y)
            gestureOnlyLeftAndUp = true
        }
    }
    
    // ...Then composition is share with cancelled or ended states
    private func shareCompositionView() {
        
        if checkCompoIsReady() {
            presentUIActivityController()
        }
        else {
            presentUIAlertController()
        }
        composition.transform = .identity
        gestureOnlyLeftAndUp = false

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
        composition.gridLayout[index].setImage(currentImage, for: .normal)
        
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
            frame = CGRect(x:0,y:0,width:300,height:80)
            center = CGPoint(x: view.frame.midX, y: view.frame.maxY - 20 - 40)
        default:
            stackStyleButtons.axis = .vertical
            frame = CGRect(x:0,y:0,width:80,height:300)
            center = CGPoint(x: view.frame.maxX - 20 - 40, y: view.frame.midY)
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
            composition.style = .bigbottom
            
        case 1:
            composition.style = .bigtop
            
        default:
            composition.style = .standard
            
        }
        
    }


    
}

