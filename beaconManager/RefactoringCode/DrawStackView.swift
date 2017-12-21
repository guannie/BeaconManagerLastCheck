//
//  gestureStackView.swift
//  beaconManager
//
//  Created by Lee Kuan Xin on 19.10.17.
//  Copyright © 2017 HDMI. All rights reserved.
//

import UIKit

@IBDesignable class DrawStackView: UIView {
    
    let tapButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(#imageLiteral(resourceName: "tap").withRenderingMode(.alwaysOriginal), for: .normal)
        button.setTitle("Tap", for: .normal)
        return button
    }()

    let rectButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(#imageLiteral(resourceName: "rect").withRenderingMode(.alwaysOriginal), for: .normal)
        button.setTitle("Rectangle", for: .normal)
        return button
    }()
    
    let lineButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(#imageLiteral(resourceName: "line").withRenderingMode(.alwaysOriginal), for: .normal)
        button.setTitle("Line", for: .normal)
        return button
    }()
    
    let polyButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(#imageLiteral(resourceName: "poly").withRenderingMode(.alwaysOriginal), for: .normal)
        button.setTitle("Polygon", for: .normal)
        return button
    }()
    
    let doneButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(#imageLiteral(resourceName: "okay").withRenderingMode(.alwaysOriginal), for: .normal)
        button.setTitle("Done", for: .normal)
        return button
    }()
    
    let cancelButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(#imageLiteral(resourceName: "cancel").withRenderingMode(.alwaysOriginal), for: .normal)
        button.setTitle("Cancel", for: .normal)
        return button
    }()
    
    
    //MARK: Initialization
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = UIColor.black.withAlphaComponent(0.5)
        setupDrawStack()

    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        self.backgroundColor = UIColor.black.withAlphaComponent(0.5)
        setupDrawStack()
    }
    
    fileprivate func setupDrawStack() {
        
        let tapButtonContainerView = UIView()
        let rectButtonContainerView = UIView()
        let lineButtonContainerView = UIView()
        let polyButtonContainerView = UIView()
        
        // For testing spaning of conatainer
        tapButtonContainerView.backgroundColor = .red
        rectButtonContainerView.backgroundColor = .green
        lineButtonContainerView.backgroundColor = .blue
        polyButtonContainerView.backgroundColor = .purple

        
        let gestureStackView = UIStackView(arrangedSubviews: [tapButtonContainerView, rectButtonContainerView, lineButtonContainerView, polyButtonContainerView])
        
        addSubview(gestureStackView)
        addSubview(tapButton)
        addSubview(rectButton)
        addSubview(lineButton)
        addSubview(polyButton)
        
        gestureStackView.axis = .vertical
        gestureStackView.distribution = .fillEqually
        gestureStackView.spacing = 10
        
        gestureStackView.anchor(self.topAnchor, left: self.leftAnchor, bottom: nil, right: nil, topConstant: 0, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: 70, heightConstant: 320)
        tapButton.anchor(nil, left: nil, bottom: tapButtonContainerView.bottomAnchor, right: tapButtonContainerView.rightAnchor, topConstant: 0, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: 70, heightConstant: 70)
        rectButton.anchor(rectButtonContainerView.topAnchor, left: nil, bottom: rectButtonContainerView.bottomAnchor, right: rectButtonContainerView.rightAnchor, topConstant: 0, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: 70, heightConstant: 70)
        lineButton.anchor(lineButtonContainerView.topAnchor, left: nil, bottom: lineButtonContainerView.bottomAnchor, right: rectButtonContainerView.rightAnchor, topConstant: 0, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: 70, heightConstant: 70)
        polyButton.anchor(polyButtonContainerView.topAnchor, left: nil, bottom: polyButtonContainerView.bottomAnchor, right: rectButtonContainerView.rightAnchor, topConstant: 0, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: 70, heightConstant: 70)
        
        
        tapButton.addTarget(self, action: #selector(DrawStackView.gestureButtonTapped(button:)), for: .touchUpInside)
        rectButton.addTarget(self, action: #selector(DrawStackView.gestureButtonTapped(button:)), for: .touchUpInside)
        lineButton.addTarget(self, action: #selector(DrawStackView.gestureButtonTapped(button:)), for: .touchUpInside)
        polyButton.addTarget(self, action: #selector(DrawStackView.gestureButtonTapped(button:)), for: .touchUpInside)
        
    }
    
    fileprivate func updateDrawStack() {
        
        let doneButtonContainerView = UIView()
        let cancelButtonContainerView = UIView()
        // For testing spaning of container
        doneButtonContainerView.backgroundColor = .brown
        cancelButtonContainerView.backgroundColor = .cyan
        let drawStackView = UIStackView(arrangedSubviews: [doneButtonContainerView, cancelButtonContainerView])
        drawStackView.anchor(self.topAnchor, left: self.leftAnchor, bottom: nil, right: nil, topConstant: 0, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: 70, heightConstant: 150)
        doneButton.anchor(doneButtonContainerView.topAnchor, left: nil, bottom: doneButtonContainerView.bottomAnchor, right: doneButtonContainerView.rightAnchor, topConstant: 0, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: 70, heightConstant: 70)
        cancelButton.anchor(cancelButtonContainerView.topAnchor, left: nil, bottom: cancelButtonContainerView.bottomAnchor, right: cancelButtonContainerView.rightAnchor, topConstant: 0, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: 70, heightConstant: 70)
        
    }
    
    // Define tap action
    @objc func gestureButtonTapped(button: UIButton) {
        //updateDrawStack()
        button.setImage(#imageLiteral(resourceName: "okay"), for: .normal)
        button.removeTarget(self, action: #selector(DrawStackView.gestureButtonTapped(button:)), for: .touchUpInside)
        button.addTarget(self, action: #selector(DrawStackView.doneButtonTapped(button:)), for: .touchUpInside)
    }
    
    @objc func doneButtonTapped(button: UIButton) {
        switch button {
        case tapButton:
            button.setImage(#imageLiteral(resourceName: "tap"), for: .normal)
        case rectButton:
            button.setImage(#imageLiteral(resourceName: "rect"), for: .normal)
        case lineButton:
            button.setImage(#imageLiteral(resourceName: "line"), for: .normal)
        case polyButton:
            button.setImage(#imageLiteral(resourceName: "poly"), for: .normal)
        default:
            break
        }
        button.removeTarget(self, action: #selector(DrawStackView.doneButtonTapped(button:)), for: .touchUpInside)
        button.addTarget(self, action: #selector(DrawStackView.gestureButtonTapped(button:)), for: .touchUpInside)
    }
    
    @objc func cancelButtonTapped(button: UIButton) {
        
    }
    
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

}
