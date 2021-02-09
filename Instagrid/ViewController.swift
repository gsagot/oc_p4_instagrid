//
//  ViewController.swift
//  Teki
//
//  Created by Gilles Sagot on 28/01/2021.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet var arrow: UIButton!
    @IBOutlet weak var composition: CompoView!
    @IBOutlet weak var selectedImage: UIImageView!
    @IBOutlet weak var layoutButtonLeft: UIButton!
    @IBOutlet weak var layoutButtonMiddle: UIButton!
    @IBOutlet weak var layoutButtonRight: UIButton!
    @IBOutlet weak var selectedLayoutConstraintX: NSLayoutConstraint!
    @IBOutlet weak var selectedLayoutConstraintY: NSLayoutConstraint!
    
    let imageLeft = UIImage(named: "Arrow Left")
    let imageUp = UIImage(named: "Arrow Up")
    
    var landscapeMode:Bool?
    
    var authorizedGesture:Bool?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        
        buildInsideViewController()

        let panGestureRecognizer = UIPanGestureRecognizer(target: self, action: #selector(dragImageLayout(_:)))
        composition.addGestureRecognizer(panGestureRecognizer)
        
        
    }
    
    
    override func viewDidAppear(_ animated: Bool) {
        if layoutButtonMiddle.center.x > composition.center.x {
            arrow.setBackgroundImage(imageLeft, for: .normal)
            landscapeMode = true
        }
        else{
            arrow.setBackgroundImage(imageUp, for: .normal)
            landscapeMode = false
        }
    }

    
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        if UIDevice.current.orientation.isLandscape {
            arrow.setBackgroundImage(imageLeft, for: .normal)
            landscapeMode = true
        } else {
            arrow.setBackgroundImage(imageUp, for: .normal)
            landscapeMode = false
        }
    }
    
    func buildInsideViewController() {
        composition.buildLayout()
        composition.buildButtons()
        composition.controller = self
        composition.setStyle(.bigbottom)
        
    }
    

    @IBAction func setStyleBigBottom(_ sender: Any) {
        composition.setStyle(.bigbottom)
        selectedImage.frame = layoutButtonLeft.frame
        selectedLayoutConstraintX.constant = 30
        selectedLayoutConstraintY.constant = 30
    }
    
  
    @IBAction func setStyleBigTop(_ sender: Any) {
        composition.setStyle(.bigtop)
        selectedImage.frame = layoutButtonMiddle.frame
        selectedLayoutConstraintX.constant = -80
        selectedLayoutConstraintY.constant = -80
    }
    
    @IBAction func setStyleStandard(_ sender: Any) {
        composition.setStyle(.standard)
        selectedImage.frame = layoutButtonRight.frame
        selectedLayoutConstraintX.constant = -190
        selectedLayoutConstraintY.constant = -190
    }
    
    @objc func dragImageLayout(_ sender: UIPanGestureRecognizer) {
        /*
        switch sender.state {
        case .began, .changed:
            moveCompositionViewWith(gesture: sender)
        case .ended, .cancelled:
            shareCompositionView()
        default:
            break
        }
        */
        if sender.state == .began || sender.state == .changed {
            moveCompositionViewWith(gesture: sender)
        }
        else if (sender.state == .ended || sender.state == .cancelled) && authorizedGesture==true{
            shareCompositionView()
        }
        
    }
    
    private func moveCompositionViewWith(gesture: UIPanGestureRecognizer) {
        let translation = gesture.translation(in: composition)
        // switch UIDevice.current.orientation

        if landscapeMode == true && translation.x < -0 {
            composition.transform = CGAffineTransform(translationX: translation.x, y: 0)
            authorizedGesture = true
        }
        else if landscapeMode == false && translation.y < -0 {
            composition.transform = CGAffineTransform(translationX: 0, y: translation.y)
            authorizedGesture = true
        }
        else
        {
            authorizedGesture = false
            
        }
    
    }
  
       
        


    private func shareCompositionView() {
        let item = [composition.imageToShare]
        let ac = UIActivityViewController(activityItems: item as [Any], applicationActivities: nil)
        present(ac, animated: true)
        composition.transform = .identity
    }
}

