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
    let stackHorizontalTop      = UIStackView()
    let stackHorizontalBottom   = UIStackView()
    let stackVertical           = UIStackView()
    var gridLayout              = [UIButton]()
    var imageToShare            = UIImage()
    
    
    enum Style {
          case bigtop, bigbottom, standard
      }
      
      // Watch properties and update with selection
      var style: Style = .bigbottom {
          didSet {
            presentStyle(style)
            imageToShare = asImage()
          }
      }
    
    
    private func asImage() -> UIImage {
          let renderer = UIGraphicsImageRenderer(bounds: bounds)
          return renderer.image { rendererContext in
              layer.render(in: rendererContext.cgContext)
          }
    }
    
    // MARK: - SET COMPOSITION
    
    func layoutCompoViewOnLoad() {
        
        self.backgroundColor = UIColor(red: 16/255, green: 102/255, blue: 152/255, alpha: 1)
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
        
        self.addSubview(stackVertical)
        
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
            newButton.imageView?.contentMode = .scaleAspectFill
            
            gridLayout.append(newButton)
            
        }
        
    }
    
    
    func presentStyle(_ style: Style){

        switch style {
        
        case .bigbottom:
            stackHorizontalTop.removeArrangedSubview(gridLayout[1])
            stackHorizontalBottom.addArrangedSubview(gridLayout[3])
            gridLayout[1].isHidden = true
            gridLayout[3].isHidden = false
            
        case .bigtop:
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
