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
        
        // Add arrow
        self.view.addSubview(arrow)
        // Add Instagrid title
        instagridTitle.image = UIImage(named: "Instagrid")
        view.addSubview(instagridTitle)
        // Set composition view
        //composition.backgroundColor = UIColor(red: 16, green: 102, blue: 152, alpha: 1)
        composition.frame = CGRect(x:0,y:0,width:300,height:300)
        // And add AutoLayout.
        //autoLayout()
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
    }
    
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        // We can now watch Device orientation
        // And update subviews to match orientation change
        if UIDevice.current.orientation.isLandscape {
            isLandscape = true
            
        }else{
            isLandscape = false
            
        }
        
        autoLayout()
        

    }
    
    override func viewDidLayoutSubviews() {
        autoLayout()
        updateInstagridTitle()
        updateArrow()
        
    }
    
    
    func autoLayout() {
        if isLandscape {
            composition.center = CGPoint(x: view.bounds.midX, y: view.bounds.maxY - 160)
            placeStyleButtonsInStack(inAxis: .vertical)
            
        }else {
            composition.center = CGPoint(x: view.bounds.midX, y: view.bounds.midY)
            placeStyleButtonsInStack(inAxis: .horizontal)
        }
        
        //composition.autoresizingMask = [UIView.AutoresizingMask.flexibleLeftMargin, UIView.AutoresizingMask.flexibleRightMargin, UIView.AutoresizingMask.flexibleTopMargin, UIView.AutoresizingMask.flexibleBottomMargin]
        
    
    }
    

    func updateArrow() {
        var center = CGPoint()
        var ref = CGPoint()
        var shift = CGPoint()
        arrow.frame = CGRect(x: 0, y: 0, width: 10, height: 10)

        if isLandscape{
            ref = CGPoint(x: composition.frame.minX, y: composition.frame.midY)
            shift = CGPoint (x : -25, y: 0)
            arrow.image = UIImage(named: "Arrow Left")
            center = CGPoint(x: ref.x + shift.x, y: ref.y)
           
        }
        else{
            ref = CGPoint(x: composition.frame.midX, y: composition.frame.minY)
            shift = CGPoint (x : 0, y: -25)
            arrow.image = UIImage(named: "Arrow Up")
            center = CGPoint(x: ref.x, y: ref.y + shift.y )
        
        }

        arrow.center = center
       
    }
    
    
    func updateInstagridTitle(){
        var center = CGPoint()
        var ref = CGPoint()
        var shift = CGPoint()
        instagridTitle.frame = CGRect(x: 0, y: 0, width: 116, height: 30)
        
        if isLandscape{
            //center = CGPoint(x: view.frame.midX , y: view.frame.midY - 150 - 15)
            ref = CGPoint(x: composition.frame.midX, y: composition.frame.minY)
            shift = CGPoint (x : 0, y: -40)
            center = CGPoint(x: ref.x, y: ref.y + shift.y )
        }
        else{
            //center = CGPoint(x: view.frame.midX , y: view.frame.minY + 30 + 15 )
            ref = CGPoint(x: view.frame.midX, y: view.frame.minY)
            shift = CGPoint (x : 0, y: 50)
            center = CGPoint(x: ref.x, y: ref.y + shift.y)
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
        let screenBounds = UIScreen.main.bounds
        let translation = gesture.translation(in: composition)
        var translationTransform = CGAffineTransform()

        if isLandscape == true && translation.x < -50{
            translationTransform = CGAffineTransform(translationX: -screenBounds.width, y: 0)
            UIView.animate(withDuration: 0.3, animations: {self.composition.transform = translationTransform}, completion: nil)
            gestureOnlyLeftAndUp = true
        }
        else if isLandscape == false && translation.y < -50{
            translationTransform = CGAffineTransform(translationX: 0, y: -screenBounds.height)
            UIView.animate(withDuration: 0.3, animations: {self.composition.transform = translationTransform}, completion: nil)
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
        composition.imageToShare = composition.asImage()
        
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
        var shift = CGPoint()
        
        switch inAxis {
        
        case .horizontal:
            stackStyleButtons.axis = .horizontal
            shift = CGPoint(x:0,y:-60)
            frame = CGRect(x:0,y:0,width:300,height:80)
            center = CGPoint(x: view.frame.midX, y: view.frame.maxY + shift.y )
        default:
            stackStyleButtons.axis = .vertical
            shift = CGPoint(x:-60,y:10)
            frame = CGRect(x:0,y:0,width:80,height:300)
            center = CGPoint(x: view.frame.maxX + shift.x , y: view.frame.maxY - 160)
        }
        
        stackStyleButtons.frame = frame
        stackStyleButtons.center = center
 
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

