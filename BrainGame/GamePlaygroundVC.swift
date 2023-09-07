//
//  GameStatusBarVC.swift
//  BrainGame
//
//  Created by Nguyễn Đức Huy on 8/13/18.
//  Copyright © 2018 Nguyễn Đức Huy. All rights reserved.
//

import UIKit

//public var playerLife = 3
public var levelValue = 0

class GamePlaygroundVC: UIViewController {
    var playerLife = 3
    
    let gamePlayingView: UIView = {
        let view = UIView()
        if UIDevice.current.userInterfaceIdiom == .phone {
            view.backgroundColor = UIColor(patternImage: UIImage(named: "GamePlayground")!)
        } else {
            view.backgroundColor = UIColor.white
        }
        
        view.isUserInteractionEnabled = true
        return view
    }()
    let gamePausedView: UIView = {
        let view = UIView()
        view.isHidden = true
        view.isUserInteractionEnabled = false
        view.layer.zPosition = 3
        return view
    }()
    let reactPlayerAnswerView: UIView = {
        let view = UIView()
        //view.backgroundColor = UIColor(white: 1, alpha: 0.4)
        view.layer.zPosition = 2
        view.isUserInteractionEnabled = false
        return view
    }()
    let gameLosedView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(white: 0.1, alpha: 0.6)
        view.isUserInteractionEnabled = false
        view.layer.zPosition = 4
        return view
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor.white
        gamePlayingView.frame = view.frame
        gamePlayingView.bounds = view.bounds
        gamePlayingView.center = view.center
        gamePausedView.frame = view.frame
        gamePausedView.bounds = view.bounds
        gamePausedView.center = view.center
        view.addSubview(gamePausedView)
        view.addSubview(gamePlayingView)
        
        setupViews()
        setupTimeLineViewAnimation()
        setupMenuAfterPressPauseButtonView()
        pressPauseButton()
        pressMenuGamePausedButton()
        setupCorrectAndWrongImageView()
        //setupGameLosedView()
    }

    
    let gameStatusBarView: UIView = {
        let view = UIView()
        view.frame.size.height = 110
        view.backgroundColor = UIColor.rgb(250, 250, 250)
        view.layer.zPosition = 1
        return view
    }()
    let pauseButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "pause"), for: UIControlState.normal)
        return button
    }()

    let blurEffectView: UIVisualEffectView = {
        let blurEffect = UIBlurEffect(style: UIBlurEffectStyle.light)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.layer.opacity = 0.9
        blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        return blurEffectView
    }()
    let menuViewAfterPressPauseButton: UIView = {
        let view = UIView()
        //view.backgroundColor = UIColor.rgb(137, 147, 156)
        view.backgroundColor = .white
        view.layer.cornerRadius = 4
        view.layer.masksToBounds = true
        view.layer.borderWidth = 2
        view.layer.borderColor = UIColor.rgb(230, 230, 230).cgColor
        view.layer.zPosition = 1
        
        view.layer.shadowRadius = 40
        view.layer.shadowColor = UIColor.darkGray.cgColor
        view.layer.shadowOpacity = 0.75
        view.layer.shadowOffset = CGSize(width: 200, height: 200)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    let titleGamePausedLabel: UILabel = {
        let label = UILabel()
        label.text  = "Game Paused"
        label.textColor = UIColor.rgb(165, 165, 165)
        label.font = UIFont(name: "Helvetica-Light", size: 42)
        label.textAlignment = .center
        return label
    }()
    let borderLineGamePausedView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.rgb(226, 226, 226)
        return view
    }()
    let resumeButton  : UIButton = setButtonForGamePausedMenu(title: "Resume")
//    let restartButton : UIButton = setButtonForGamePausedMenu(title: "Restart")
    let quitButton    : UIButton = setButtonForGamePausedMenu(title: "Quit")
    static func setButtonForGamePausedMenu(title: String) -> UIButton {
        let button = UIButton()
        button.setTitle(title, for: UIControlState.normal)
        button.titleLabel?.font = UIFont(name: "Helvetica", size: 26)
        button.setTitleColor(UIColor.white, for: UIControlState.normal)
        button.backgroundColor = UIColor.rgb(96, 189, 244)
        button.layer.cornerRadius = 6
        button.layer.masksToBounds = true
        button.clipsToBounds = true
        return button
    }
    
    var levelLabel: UILabel = {
        let label = UILabel()
        label.text = "1"
        label.textColor = UIColor.rgb(60, 170, 250) // 90, 181, 241
        label.font = UIFont.boldSystemFont(ofSize: 32)
        label.textAlignment = .center
        label.frame.size.width = 100
        return label
    }()
    
    let heartImageView1: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "heart")
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    let heartImageView2: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "heart")
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    let heartImageView3: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "heart")
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    let borderLineView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.rgb(226, 226, 226)
        return view
    }()
    let timeLineView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.rgb(176, 133, 215)
        return view
    }()
    
    func pauseLayer(layer: CALayer) {
        let pausedTime: CFTimeInterval = layer.convertTime(CACurrentMediaTime(), from: nil)
        layer.speed = 0.0
        layer.timeOffset = pausedTime
    }

    func resumeLayer(layer: CALayer) {
        let pausedTime: CFTimeInterval = layer.timeOffset
        layer.speed = 1.0
        layer.timeOffset = 0.0
        layer.beginTime = 0.0
        let timeSincePause: CFTimeInterval = layer.convertTime(CACurrentMediaTime(), from: nil) - pausedTime
        layer.beginTime = timeSincePause
    }
    
    // reactPlayerAnswerView
    let correctAnswerImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "correct")
        imageView.layer.zPosition = 1
        //imageView.isHidden = false
        imageView.alpha = 0
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    let wrongAnswerImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "wrong")
        imageView.layer.zPosition = 1
        imageView.alpha = 0
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    func setupViews() {
        gamePlayingView.addSubview(gameStatusBarView)
        gamePlayingView.addConstraints(withFormat: "V:|[v0(\(gameStatusBarView.frame.height))]", views: gameStatusBarView)
        gamePlayingView.addConstraints(withFormat: "H:|[v0]|", views: gameStatusBarView)
        
        gameStatusBarView.addSubview(pauseButton)
        gameStatusBarView.addSubview(levelLabel)
        gameStatusBarView.addSubview(heartImageView1)
        gameStatusBarView.addSubview(heartImageView2)
        gameStatusBarView.addSubview(heartImageView3)
        gameStatusBarView.addSubview(borderLineView)
        gameStatusBarView.addSubview(timeLineView)
        
        let ahaftView = view.frame.width / 2
        var leftConstraintStageLabel = ahaftView - 20 - 30
        leftConstraintStageLabel -= 100/2
        gameStatusBarView.addConstraints(withFormat: "V:|-40-[v0(30)]", views: pauseButton)
        gameStatusBarView.addConstraints(withFormat: "V:|-40-[v0(30)]", views: levelLabel)
        gameStatusBarView.addConstraints(withFormat: "V:|-40-[v0(30)]", views: heartImageView1)
        gameStatusBarView.addConstraints(withFormat: "V:|-40-[v0(30)]", views: heartImageView2)
        gameStatusBarView.addConstraints(withFormat: "V:|-40-[v0(30)]", views: heartImageView3)
        gameStatusBarView.addConstraints(withFormat: "V:[v0]-30-[v1(2)][v2(8)]", views: pauseButton, borderLineView, timeLineView)
        gameStatusBarView.addConstraints(withFormat: "H:|-20-[v0(30)]-\(leftConstraintStageLabel)-[v1(\(levelLabel.frame.width))]", views: pauseButton, levelLabel)
        gameStatusBarView.addConstraints(withFormat: "H:[v0(30)][v1(30)][v2(30)]-20-|", views: heartImageView1, heartImageView2, heartImageView3)
        gameStatusBarView.addConstraints(withFormat: "H:|[v0]|", views: borderLineView)
        gameStatusBarView.addConstraints(withFormat: "H:|[v0]|", views: timeLineView)
    }
    func setupTimeLineViewAnimation() {
        // count time
        UIView.animate(withDuration: 15, delay: 1, options: UIViewAnimationOptions.curveEaseOut, animations: {
            self.timeLineView.transform = self.timeLineView.transform.translatedBy(x: -self.view.frame.width, y: 0)
        }) { (_) in
            print("Time is over")
            print("Losed")
            self.gamePlayingView.isUserInteractionEnabled = false
            self.setupGameLosedView()
            self.pauseLayer(layer: self.timeLineView.layer) // stop timeLineView
        }
    }
    func setupMenuAfterPressPauseButtonView() {
        view.addSubview(gamePausedView)
        view.addConstraints(withFormat: "H:|[v0]|", views: gamePausedView)
        view.addConstraints(withFormat: "V:|[v0]|", views: gamePausedView)
        gamePausedView.bounds = view.bounds
        
        gamePausedView.addSubview(blurEffectView)
        blurEffectView.frame = gamePausedView.bounds
        
        gamePausedView.addSubview(menuViewAfterPressPauseButton)
        menuViewAfterPressPauseButton.centerXAnchor.constraint(equalTo: gamePausedView.centerXAnchor).isActive = true
        menuViewAfterPressPauseButton.centerYAnchor.constraint(equalTo: gamePausedView.centerYAnchor).isActive = true
        menuViewAfterPressPauseButton.widthAnchor.constraint(equalTo: gamePausedView.widthAnchor, constant: -20).isActive = true
        menuViewAfterPressPauseButton.heightAnchor.constraint(equalTo: gamePausedView.heightAnchor, constant: -70).isActive = true
        
        menuViewAfterPressPauseButton.addSubview(titleGamePausedLabel)
        menuViewAfterPressPauseButton.addSubview(borderLineGamePausedView)
        menuViewAfterPressPauseButton.addSubview(resumeButton)
//        menuViewAfterPressPauseButton.addSubview(restartButton)
        menuViewAfterPressPauseButton.addSubview(quitButton)
        
        menuViewAfterPressPauseButton.addConstraints(withFormat: "V:|[v0(140)][v1(1)]-55-[v2(80)]-55-[v3(80)]", views: titleGamePausedLabel, borderLineGamePausedView, resumeButton, quitButton)
        
        menuViewAfterPressPauseButton.addConstraints(withFormat: "H:|[v0]|", views: titleGamePausedLabel)
        menuViewAfterPressPauseButton.addConstraints(withFormat: "H:|-14-[v0]-14-|", views: borderLineGamePausedView)
        menuViewAfterPressPauseButton.addConstraints(withFormat: "H:|-50-[v0]-50-|", views: resumeButton)
//        menuViewAfterPressPauseButton.addConstraints(withFormat: "H:|-50-[v0]-50-|", views: restartButton)
        menuViewAfterPressPauseButton.addConstraints(withFormat: "H:|-50-[v0]-50-|", views: quitButton)
        
    }
    func pressPauseButton() {
        pauseButton.addTarget(self, action: #selector(stopTimeLineView), for: UIControlEvents.touchDown)
        pauseButton.addTarget(self, action: #selector(createMenuViewAfterPressPauseButton), for: UIControlEvents.touchDown)
    }
    @objc func stopTimeLineView() {
        pauseLayer(layer: timeLineView.layer)
        //        pause = !pause
        //        if pause {
        //            pauseLayer(layer: timeLineView.layer)
        //        } else {
        //            resumeLayer(layer: timeLineView.layer)
        //        }
    }
    @objc func createMenuViewAfterPressPauseButton() {
        gamePausedView.isHidden = false
        gamePausedView.isUserInteractionEnabled = true
        gamePlayingView.isUserInteractionEnabled = false
    }
    func pressMenuGamePausedButton() {
        resumeButton.addTarget(self, action: #selector(touchDownResumeButton(_:)), for: UIControlEvents.touchDown)
        quitButton.addTarget(self, action: #selector(touchDownQuitButton(_:)), for: UIControlEvents.touchDown)
    }
    @objc func touchDownResumeButton(_ sender: UIButton) {
        gamePausedView.isHidden = true
        gamePausedView.isUserInteractionEnabled = false
        gamePlayingView.isUserInteractionEnabled = true
        resumeLayer(layer: timeLineView.layer)
    }
    @objc func touchDownQuitButton(_ sender: UIButton) {
        playerLife = 3
        levelValue = 0
        // fade animation pop view controller
        let transition = CATransition()
        transition.duration = 0.5
        transition.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
        transition.type = kCATransitionFade
        self.navigationController?.view.layer.add(transition, forKey: nil)
        navigationController?.popToRootViewController(animated: false)
    }
    
    func answerWrong() {
        if playerLife == 3 {
            self.heartImageView1.fallDownAndFadeAway()
            playerLife -= 1
        } else if playerLife == 2 {
            self.heartImageView2.fallDownAndFadeAway()
            playerLife -= 1
        } else {
            self.heartImageView3.fallDownAndFadeAway()
            playerLife -= 1
            print("Losed")
            self.gamePlayingView.isUserInteractionEnabled = false
            self.setupGameLosedView()
            pauseLayer(layer: timeLineView.layer) // stop timeLineView
        }
        
    }
    
    func setupCorrectAndWrongImageView() {
        view.addSubview(reactPlayerAnswerView)
        reactPlayerAnswerView.frame = view.bounds
        reactPlayerAnswerView.center = view.center
        
        reactPlayerAnswerView.addSubview(correctAnswerImageView)
        reactPlayerAnswerView.addSubview(wrongAnswerImageView)
       
        correctAnswerImageView.centerXAnchor.constraint(equalTo: reactPlayerAnswerView.centerXAnchor).isActive = true
        correctAnswerImageView.centerYAnchor.constraint(equalTo: reactPlayerAnswerView.centerYAnchor).isActive = true
        correctAnswerImageView.widthAnchor.constraint(equalToConstant: 75).isActive = true
        correctAnswerImageView.heightAnchor.constraint(equalToConstant: 75).isActive = true
        
        wrongAnswerImageView.centerXAnchor.constraint(equalTo: reactPlayerAnswerView.centerXAnchor).isActive = true
        wrongAnswerImageView.centerYAnchor.constraint(equalTo: reactPlayerAnswerView.centerYAnchor).isActive = true
        wrongAnswerImageView.widthAnchor.constraint(equalToConstant: 75).isActive = true
        wrongAnswerImageView.heightAnchor.constraint(equalToConstant: 75).isActive = true
    }
    
    func setupGameLosedView() {
        self.gamePlayingView.isUserInteractionEnabled = false
        self.gameLosedView.isUserInteractionEnabled = true
        let tapGuesture = UITapGestureRecognizer(target: self, action: #selector(tapGameLosedView(_:)))
        self.gameLosedView.addGestureRecognizer(tapGuesture)
        
        view.addSubview(gameLosedView)
        gameLosedView.frame = view.bounds
        gameLosedView.center = view.center
        view.addConstraints(withFormat: "H:|[v0]|", views: gameLosedView)
        view.addConstraints(withFormat: "V:|[v0]|", views: gameLosedView)
        
        let gameLosedInfoView: UIView = {
            let view = UIView()
            view.backgroundColor = UIColor.white
            view.layer.cornerRadius = 6
            view.layer.masksToBounds = true
            view.translatesAutoresizingMaskIntoConstraints = false
            return view
        }()
        
        let gameLosedLabel: UILabel = {
            let label = UILabel()
            label.textAlignment = .center
            label.numberOfLines = 3
            
            typealias key = NSAttributedStringKey
            let attributedText = NSMutableAttributedString(string: "YOU LOSED", attributes: [key.font: UIFont.boldSystemFont(ofSize: 42), key.foregroundColor:  UIColor.rgb(169, 119, 211)])
            
            attributedText.append(NSMutableAttributedString(string: "\nMax Level: \(self.levelLabel.text!)", attributes: [key.font: UIFont.systemFont(ofSize: 28), key.foregroundColor: UIColor.black]))
            
            attributedText.append(NSMutableAttributedString(string: "\nTap to continue", attributes: [key.font: UIFont.systemFont(ofSize: 16), key.foregroundColor: UIColor(white: 0.5, alpha: 1)]))
            
            let paragraphStyle = NSMutableParagraphStyle()
            paragraphStyle.lineSpacing = 60
            paragraphStyle.alignment = NSTextAlignment.center
            attributedText.addAttribute(key.paragraphStyle, value: paragraphStyle, range: NSMakeRange(0, attributedText.string.count))
            
            label.attributedText = attributedText
            return label
        }()
        
        gameLosedView.addSubview(gameLosedInfoView)
        gameLosedInfoView.addSubview(gameLosedLabel)
        
        gameLosedInfoView.centerXAnchor.constraint(equalTo: gameLosedView.centerXAnchor).isActive = true
        gameLosedInfoView.centerYAnchor.constraint(equalTo: gameLosedView.centerYAnchor).isActive = true
        gameLosedInfoView.widthAnchor.constraint(equalTo: gameLosedView.widthAnchor, constant: -80).isActive = true
        gameLosedInfoView.heightAnchor.constraint(equalTo: gameLosedView.heightAnchor, constant: -360).isActive = true
        
        gameLosedInfoView.addSubview(gameLosedLabel)
        gameLosedInfoView.addConstraints(withFormat: "H:|[v0]|", views: gameLosedLabel)
        gameLosedInfoView.addConstraints(withFormat: "V:|[v0]|", views: gameLosedLabel)
    }
    @objc func tapGameLosedView(_ sender: UITapGestureRecognizer) {
        let transition =  CATransition()
        transition.duration = 0.5
        transition.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
        transition.type = kCATransitionFade
        self.navigationController?.view.layer.add(transition, forKey: nil)
        navigationController?.popToRootViewController(animated: false)
        playerLife = 3 // reset value
        levelValue = 0
    }
    
    func checkPlayerLife() {
        print("playerLife", playerLife)
        if playerLife == 2 {
            self.heartImageView1.isHidden = true
        } else if playerLife == 1 {
            self.heartImageView1.isHidden = true
            self.heartImageView2.isHidden = true
        }
    }
    func checkLevelLabel() {
        levelValue += 1
        self.levelLabel.text = String(levelValue)
    }
}



















