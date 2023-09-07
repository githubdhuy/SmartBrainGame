//
//  MainMenuViewController.swift
//  BrainGame
//
//  Created by Nguyễn Đức Huy on 8/12/18.
//  Copyright © 2018 Nguyễn Đức Huy. All rights reserved.
//

import UIKit

class MainMenuViewController: UIViewController {
    private let gamesDictionary: [Int: String] = [0: "MathSolving", 1: "Imaginary", 2: "IsDifferentColor"]
    private var gameIdDiceRoll: Int?
    
    let gameLogoImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "gameLogo3")
        return imageView
    }()
    let startButtonView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.rgb(78, 153, 247)
        view.layer.cornerRadius = 14
        view.layer.masksToBounds = true
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    let startButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "playButton"), for: UIControlState.normal)
        button.layer.cornerRadius = 4
        button.layer.masksToBounds = true
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.white
        
        view.addSubview(gameLogoImageView)
        view.addSubview(startButtonView)
        
        view.addConstraints(withFormat: "V:|-\(view.frame.height/2 - 180)-[v0(\(view.frame.height / 5))]-80-[v1(\(view.frame.width/3))]", views: gameLogoImageView, startButtonView)
        view.addConstraints(withFormat: "H:|-10-[v0]-10-|", views: gameLogoImageView)
        view.addConstraints(withFormat: "H:|-\(view.frame.width/2 - (view.frame.width/3)/2)-[v0(\(view.frame.width/3))]", views: startButtonView)
        
        startButtonView.addSubview(startButton)
        startButtonView.addConstraints(withFormat: "V:|[v0]|", views: startButton)
        startButtonView.addConstraints(withFormat: "H:|[v0]|", views: startButton)
        
        startButtonView.transform = startButton.transform.rotated(by: CGFloat(Double.pi/4))
        startButton.transform = startButton.transform.rotated(by: CGFloat(-Double.pi/4))
        
        pressButton()
    }
    private func pressButton() {
        startButton.addTarget(self, action: #selector(startGame(_:)), for: UIControlEvents.touchDown)
    }
    @objc private func startGame(_ sender: UIButton) {
        navigationController?.pushViewController(MathSolvingGameVC(playerLife: 3), animated: true)
        //navigationController?.pushViewController(IsDifferentColorGameVC(), animated: true)
        //navigationController?.pushViewController(ImaginationGameVC(), animated: true)
    }
}






