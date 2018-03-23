//
//  GameViewController.swift
//  was
//
//  Created by Raül Duaigües on 15/02/2018.
//  Copyright © 2018 Raül Duaigües. All rights reserved.
//

import ARKit
import LBTAComponents

class GameViewController: UIViewController, ARSCNViewDelegate {
    
    let arView: ARSCNView = {                                       //create manually our AR Scene view
        let view = ARSCNView()
        //view.translatesAutoresizingMaskIntoConstraints = false    //not used bcause is alredy included in Anchor func (LBTA)
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
        addBox()                                                    //add a box when tap
    }
    
    let plusButtonWidth = ScreenSize.width * 0.1                    //size of button depending on screensize
    
    let configuration = ARWorldTrackingConfiguration()
    
    override func viewDidLoad() {
        super.viewDidLoad()                                         //view controller set up

        
        setupViews()
        
        configuration.planeDetection = .horizontal
        configuration.planeDetection = .vertical
        
        arView.session.run(configuration, options: [])              //arview to our configuration
                                                                    //we can reset anchors from options
        arView.debugOptions = [ARSCNDebugOptions.showFeaturePoints, ARSCNDebugOptions.showWorldOrigin]
        //.showFeaturePoints: this is how your app recieves tha data from the world shown through the camera (yellow dots)
        //.showWorldOrigin: this shows the origin where we start the app (red, blue and green axis)
        
        arView.autoenablesDefaultLighting = true                    //lighting shadows ON
        arView.delegate = self
    }
    override var prefersStatusBarHidden: Bool {
        return true                                                 //remove status bar from view controller
    }

    func setupViews(){
        
//      arView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true            //position our view
//      arView.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true        //constraint it to our anchors
//      arView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
//      arView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        
        view.addSubview(arView)                                     //select view
        
//      arView.anchor(view.topAnchor, left: view.leftAnchor, bottom: view.bottomAnchor, right: view.rightAnchor, topConstant: 0,
//                                    leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: 0, heightConstant: 0)
//                                                                  //values added to our constraints to put it lower, upper..
        
        arView.fillSuperview()
        
        view.addSubview(plusButton)
        
        plusButton.anchor(nil, left: view.safeAreaLayoutGuide.leftAnchor, bottom: view.safeAreaLayoutGuide.bottomAnchor, right: nil, topConstant: 0, leftConstant: 24, bottomConstant: 12, rightConstant: 0, widthConstant: plusButtonWidth, heightConstant: plusButtonWidth)
        
                                                                    //button to the bottom left corner. This app might be rotated, so we want to anchor it not to the views left anchor but we want to anchor it to the safe area guideline left anchor
        
    }
    
    func addBox() {                                                 //create a box
        let node = SCNNode() //SCNNode(geometry: SCNBox(width: 0.005, height: 0.8, length: 0.8, chamferRadius: 0.3))
        node.geometry = SCNBox(width: 0.005, height: 0.8, length: 0.8, chamferRadius: 0.3) //chamferRadius rounded corner
        node.geometry?.firstMaterial?.diffuse.contents = #imageLiteral(resourceName: "quadre")         //UIColor(red: 200, green: 150, blue: 100)
        //boxNode.geometry?.firstMaterial?.specular.contents = UIColor.white
        //node.position = SCNVector3(0,0,1)
        node.position = SCNVector3(Float.random(-0.5,max:0.5),Float.random(-0.5,max:0.5),Float.random(-0.5,max:0.5))
        node.name = "cuadre"
        arView.scene.rootNode.addChildNode(node)
    }
    
    func removeAllBoxes(){                                          //remove all the objects called "box" and print it
        arView.scene.rootNode.enumerateChildNodes { (node, _) in
            if node.name == "box" {
                print("Removing box")
                node.removeFromParentNode()
                
            }
        }
    }
    
    func resetScene() {                                             //reset the scene
        arView.session.pause()
        arView.scene.rootNode.enumerateChildNodes{ (node, _) in
            if node.name == "node" {
                node.removeFromParentNode()
            }
    }
    
    func createFloor(anchor: ARPlaneAnchor) -> SCNNode {            //floor object will be related to the ARPlaneAnchor
        let floor = SCNNode()                                       //return SCNNode. Create our Node
        floor.name = "floor"                                        //name
        floor.eulerAngles = SCNVector3(90.DegreesToRadians,0,0)     //rotate (because by default a plane is in vertical position
        floor.geometry = SCNPlane(width: CGFloat(anchor.extent.x), height: CGFloat(anchor.extent.z)) //give geometry (created by
                                                                    //the plane
        floor.geometry?.firstMaterial?.diffuse.contents = #imageLiteral(resourceName: "quadre")        //material in the plane
        floor.geometry?.firstMaterial?.isDoubleSided = true         //double sided
        floor.position = SCNVector3(anchor.center.x,anchor.center.y,anchor.center.z) //apply rotation in position
        return floor                                                //return floor
    }
    
    func removeNode(named: String){                                 //remove node called in some way i.e. named: "floor"
        arView.scene.rootNode.enumerateChildNodes { (node, _) in
            if node.name == named {
                //print("Removing box")
                node.removeFromParentNode()
                
            }
        }
    }
    
    func renderer(_ renderer: SCNSceneRenderer, didAdd node: SCNNode, for anchor: ARAnchor) {       //detect plane anchor
        guard let anchorPlane = anchor as? ARPlaneAnchor else { return}
        print("new Plane Anchor found at extent:", anchorPlane.extent)
        
        let floor = createFloor(anchor:anchorPlane)                 //put the texture in the plane
        node.addChildNode(floor)
    }
    
    func renderer(_ renderer: SCNSceneRenderer, didUpdate node: SCNNode, for anchor: ARAnchor) {    //update existent plane anchor
        guard let anchorPlane = anchor as? ARPlaneAnchor else { return}
        print("Plane Anchor updated with extent:", anchorPlane.extent)
        
        removeNode(named: "floor")                                  //remove previous texture
        let floor = createFloor(anchor: anchorPlane)                //put the texture again with the new values of the floor
        node.addChildNode(floor)
    }
    
    func renderer(_ renderer: SCNSceneRenderer, didRemove node: SCNNode, for anchor: ARAnchor) {    //info when sys remove a plane
        guard let anchorPlane = anchor as? ARPlaneAnchor else { return}
        print("Plane Anchor removed with extent:", anchorPlane.extent)
        
        removeNode(named: "floor")                                  //remove plane texture
        
    }
}






























