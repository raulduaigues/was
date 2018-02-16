//
//  GameViewController.swift
//  was
//
//  Created by Raül Duaigües on 15/02/2018.
//  Copyright © 2018 Raül Duaigües. All rights reserved.
//

import ARKit
import LBTAComponents

class GameViewController: UIViewController {
    
    let arView: ARSCNView = {                                       //create manually our AR Scene view
        let view = ARSCNView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    var plusButton: UIButton = {                                    //create button, create new elements into the scene
        var button = UIButton(type: .system)
        button.setImage(#imageLiteral(resourceName: "plusbutton").withRenderingMode(.alwaysTemplate), for: .normal)   //button needs texture
        button.tintColor = UIColor(red: 255, green: 255, blue: 255) //white color for the button
        
        button.addTarget(self, action: #selector(handlePlusButtonTapped), for: .touchUpInside) //add an action
        return button
    }()
    
    @objc func handlePlusButtonTapped() {                           //action for the button
        print("Tapped on plus button")
    }
    
    let plusButtonWidth = ScreenSize.width * 0.1                    //size of button depending on screensize
    
    let configuration = ARWorldTrackingConfiguration()
    
    override func viewDidLoad() {
        super.viewDidLoad()                                         //view controller set up

        
        setupViews()
        
        arView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true            //position our view
        arView.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true        //constraint it to our anchors
        arView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        arView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        
        arView.session.run(configuration, options: [])                                  //arview to our configuration
                                                                                        //we can reset anchors from options
        arView.debugOptions = [ARSCNDebugOptions.showFeaturePoints, ARSCNDebugOptions.showWorldOrigin]
        //.showFeaturePoints: this is how your app recieves tha data from the world shown through the camera (yellow dots)
        //.showWorldOrigin: this shows the origin where we start the app (red, blue and green axis)
    }
    override var prefersStatusBarHidden: Bool {
        return true                                                         //remove status bar from view controller
    }

    func setupViews(){
//        arView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true            //position our view
//        arView.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true        //constraint it to our anchors
//        arView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
//        arView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        
        view.addSubview(arView)                                     //select view
//        arView.anchor(view.topAnchor, left: view.leftAnchor, bottom: view.bottomAnchor, right: view.rightAnchor, topConstant: 0, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: 0, heightConstant: 0)
//                //values addet to our constraints to put it lower, upper..
        
        arView.fillSuperview()
        
        view.addSubview(plusButton)
        plusButton.anchor(nil, left: view.safeAreaLayoutGuide.leftAnchor, bottom: view.safeAreaLayoutGuide.bottomAnchor, right: nil, topConstant: 0, leftConstant: 24, bottomConstant: 12, rightConstant: 0, widthConstant: plusButtonWidth, heightConstant: plusButtonWidth)
        
        //button to the bottom left corner. This app might be rotated, so we want to anchor it not to the views left anchor but we want to anchor it to the safe area guideline left anchor
        
    }
    
    
    
    
}






























