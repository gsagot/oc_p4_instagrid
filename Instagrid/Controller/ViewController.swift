//
//  ViewController.swift
//  Teki
//
//  Created by Gilles Sagot on 28/01/2021.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet var mainView: MainView!
    
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        // Do any additional setup after loading the view.

        // On load, the device orientation can be .Unknown or .FaceUp ... We need to find something else to hang on. This is a way to fix this
        let orientation = UIApplication.shared.windows.first?.windowScene?.interfaceOrientation
        
        if orientation == .portrait {
            mainView.isLandscape = false
        } else if orientation == .landscapeRight || orientation == .landscapeLeft {
            mainView.isLandscape = true
        }

        // Build main view and all subviews
        mainView.arrangeSubViews (controller: self)

    }
    
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        // We can now watch Device orientation
        // And update subviews to match orientation change
        if UIDevice.current.orientation.isLandscape {
            mainView.isLandscape = true
            
        }else{
            mainView.isLandscape = false
            
        }
            mainView.updateWhenOrientationChange()
    }

    
}

