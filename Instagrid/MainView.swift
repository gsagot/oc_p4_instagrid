//
//  ViewLayout.swift
//  Instagrid
//
//  Created by Gilles Sagot on 15/02/2021.
//

import UIKit

class MainView: UIView {
    
    @IBOutlet weak var arrow: UIImageView!
    @IBOutlet weak var layoutButtonLeft: UIButton!
    @IBOutlet weak var layoutButtonMiddle: UIButton!
    @IBOutlet weak var layoutButtonRight: UIButton!
    @IBOutlet weak var composition: CompoView!
    @IBOutlet weak var selectedImage: UIImageView!
    @IBOutlet weak var selectedLayoutConstraintX: NSLayoutConstraint!
    @IBOutlet weak var selectedLayoutConstraintY: NSLayoutConstraint!
    
    var isLandscape:Bool = false
    var gestureOnlyLeftAndUp:Bool = false
    
    
    
    func updateWhenOrientationChange() {
        if isLandscape{
            arrow.image = UIImage(named: "Arrow Left")
        } else {
            arrow.image = UIImage(named: "Arrow Up")
        }
    }
    
    func arrangeSubViews(controller: UIViewController){
        updateWhenOrientationChange()
        composition.buildLayout()
        composition.buildButtons()
        composition.controller = controller
        composition.setStyle(.bigbottom)
        let panGestureRecognizer = UIPanGestureRecognizer(target: self, action: #selector(dragImageLayout(_:)))
        composition.addGestureRecognizer(panGestureRecognizer)
    }
    
    @objc func dragImageLayout(_ sender: UIPanGestureRecognizer) {
        if (sender.state == .began || sender.state == .changed) {
            moveCompositionViewWith(gesture: sender)
        }
        else if (sender.state == .ended || sender.state == .cancelled) && gestureOnlyLeftAndUp == true {
            shareCompositionView()
            
        }
        
    }
    
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
    
    private func shareCompositionView() {
        let item = [composition.imageToShare]
        let ac = UIActivityViewController(activityItems: item as [Any], applicationActivities: nil)
        composition.controller.present(ac, animated: true)
        composition.transform = .identity
        gestureOnlyLeftAndUp = false
    }
    
    
    // Update with user choices
    
    @IBAction func setStyleBigBottom(_ sender: Any) {
        composition.setStyle(.bigbottom)
        selectedImage.frame = layoutButtonLeft.frame
        selectedLayoutConstraintX.constant = 30 // update only for .portrait
        selectedLayoutConstraintY.constant = 30 // update only for .landscape
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
    
    
    
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

}
