//
//  IsDifferentColorGameVC.swift
//  BrainGame
//
//  Created by Nguyễn Đức Huy on 8/17/18.
//  Copyright © 2018 Nguyễn Đức Huy. All rights reserved.
//

import UIKit

class IsDifferentColorGameVC: GamePlaygroundVC {
    override func viewDidLoad() {
        super.viewDidLoad()
        // lock x tick button
        xButton.isEnabled = false
        tickButton.isEnabled = false
        
        checkPlayerLife()
        checkLevelLabel()
        // difficult level
        if levelValue > 3 {
            self.totalQuestion += Int(ceil((Double(Double(levelValue)/3) - 1.0))) + 1
            print("total",self.totalQuestion)
        }
        
        // set time to unlock button
        self.timerOfPaperViewAppearance = Timer.scheduledTimer(timeInterval: 0.05, target: self, selector: #selector(self.unlockXTickButton), userInfo: nil, repeats: true)
        // set up views
        setupQuestionView()
        createQuestion()
        setupTrueFalseButton()
        pressXTickButton()
        
    }
    
    @objc func unlockXTickButton(_ sender: Any) {
        self.countTimeValueForPaperViewAppearance += 0.05
        if self.countTimeValueForPaperViewAppearance >= 0.85 {
            self.timerOfPaperViewAppearance.invalidate()
            xButton.isEnabled = true
            tickButton.isEnabled = true
        }
    }
    /* set time to unlock x, tick button */
    var countTimeValueForPaperViewAppearance : Double = 0.0
    var timerOfPaperViewAppearance         : Timer = Timer()
    /* isDifferentColor game */
    var totalQuestion       : Int       = 5
    var questionSolvedCount : Int       = 0
    var paperView           : [UIView]  = []
    var scaleRatio          : [CGFloat] = []
    private static func createPaperView(zPosition: CGFloat) -> UIView {
        let view = UIView()
        view.backgroundColor = UIColor.rgb(254, 254, 254)
        view.layer.cornerRadius = 4
        view.layer.masksToBounds = true
        view.frame.size.height = 100
        view.layer.borderWidth = 2
        view.layer.borderColor = UIColor.rgb(228, 228, 230).cgColor
        view.layer.zPosition = zPosition
        return view
    }
    var colorNameLabelList: [UILabel] = []
    static func createLabel() -> UILabel {
        let label = UILabel()
        label.text = ""
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 52)
        return label
    }
    
    let colorDictionary: [UIColor: String] = [
            UIColor.rgb(38, 38, 38): "Black", UIColor.rgb(68, 149, 233): "Blue",
            UIColor.rgb(223, 82, 64): "Red", UIColor.rgb(245, 194, 68): "Yellow",
            UIColor.rgb(115, 87, 74): "Brown", UIColor.rgb(102, 172, 89): "Green",
            UIColor.rgb(169, 119, 211): "Violet"
    ]
    let colorList: [UIColor] = [
            UIColor.rgb(38, 38, 38), UIColor.rgb(68, 149, 233),
            UIColor.rgb(223, 82, 64), UIColor.rgb(245, 194, 68),
            UIColor.rgb(115, 87, 74), UIColor.rgb(102, 172, 89),
            UIColor.rgb(169, 119, 211)
    ]
    var text              : [String]   = []
    var textColor         : [UIColor]  = []
    var isTrueProblem     : [Bool]     = []
    enum Shape {
        case circle
        case square
        case none
    }
    var lineDividerLine: [UIView] = []
    static func createLineDividerLine() -> UIView {
        let view = UIView()
        view.backgroundColor = UIColor.rgb(211, 211, 211)
        return view
    }
    var shapeList         : [UIView]  = []
    var resultList        : [Bool]    = []
    static func createShape(name: Shape) -> UIView {
        let view = UIView()
        view.layer.masksToBounds = true
        view.frame.size.height = 75
        view.contentMode = .scaleAspectFill
        switch name {
        case .circle:
            view.layer.cornerRadius = 75/2
        case .square:
            view.layer.cornerRadius = 8
        case .none:
            view.backgroundColor = UIColor.clear
        }
        return view
    }
    
    let xButton: UIButton = setXTickButton(imageName: "x", tintColor: UIColor.rgb(226, 79, 122))
    let tickButton: UIButton = setXTickButton(imageName: "tick", tintColor: UIColor.rgb(70, 167, 237))
    static func setXTickButton(imageName: String, tintColor: UIColor) -> UIButton {
        let button = UIButton(type: UIButtonType.custom)
        button.setImage(UIImage(named: imageName)?.withRenderingMode(UIImageRenderingMode.alwaysTemplate), for: UIControlState.normal)
        button.tintColor = tintColor
        button.backgroundColor = UIColor.rgb(254, 254, 254)
        button.layer.borderWidth = 1
        button.layer.borderColor = UIColor.rgb(211, 211, 211).cgColor
        return button
    }
    
    convenience init(playerLife: Int) {
        self.init()
        self.playerLife = playerLife
    }

    
    func setupQuestionView() {
        for i in 0..<totalQuestion {
            paperView.append(IsDifferentColorGameVC.createPaperView(zPosition: CGFloat(totalQuestion-i)))
            lineDividerLine.append(IsDifferentColorGameVC.createLineDividerLine())
            
            switch UInt32.random(from: 0, to: 1) {
            case 0:
                shapeList.append(IsDifferentColorGameVC.createShape(name: .circle))
            case 1:
                shapeList.append(IsDifferentColorGameVC.createShape(name: .square))
            default:
                print("none")
            }
            colorNameLabelList.append(IsDifferentColorGameVC.createLabel())
            
            paperView[i].isUserInteractionEnabled = false
            
            gamePlayingView.addSubview(paperView[i])
            paperView[i].addSubview(shapeList[i])
            paperView[i].addSubview(colorNameLabelList[i])
            paperView[i].addSubview(lineDividerLine[i])
            paperView[i].translatesAutoresizingMaskIntoConstraints = false
            shapeList[i].translatesAutoresizingMaskIntoConstraints = false
            colorNameLabelList[i].translatesAutoresizingMaskIntoConstraints = false
            lineDividerLine[i].translatesAutoresizingMaskIntoConstraints = false
            
            paperView[i].centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: 0).isActive = true
            if i < 3 {
                paperView[i].centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: CGFloat(12*i)).isActive = true
                paperView[i].widthAnchor.constraint(equalTo: view.widthAnchor, constant: CGFloat(-120 - (12*i))).isActive = true
            } else {
                paperView[i].centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: CGFloat(12)).isActive = true
                paperView[i].widthAnchor.constraint(equalTo: view.widthAnchor, constant: CGFloat(-120 - (12*2))).isActive = true
            }
            paperView[i].heightAnchor.constraint(equalTo: paperView[i].widthAnchor).isActive = true
            
            if i < 3 {
                paperView[i].frame.size.width = view.frame.width - 120 - CGFloat(12*i)
            } else {
                paperView[i].frame.size.width = view.frame.width - 120 - (12*2)
            }
            
            paperView[i].addConstraints(withFormat: "V:|-10-[v0]-10-[v1(1)]-25-[v2(75)]-25-|", views: colorNameLabelList[i], lineDividerLine[i], shapeList[i])
            paperView[i].addConstraints(withFormat: "H:|[v0]|", views: colorNameLabelList[i])
            paperView[i].addConstraints(withFormat: "H:|-14-[v0]-14-|", views: lineDividerLine[i])
            paperView[i].addConstraints(withFormat: "H:|-\(paperView[i].frame.width/2 - (75/2))-[v0(75)]", views: shapeList[i])
        }

        // paper view apperance
        for i in 0..<totalQuestion {
            self.paperView[i].transform = self.paperView[i].transform.translatedBy(x: self.view.frame.width, y: -160)
        }
        for i in 0..<totalQuestion {
            UIView.animate(withDuration: 0.85, delay: (0.1*Double(i)), animations: {
                self.paperView[i].transform = self.paperView[i].transform.translatedBy(x: -self.view.frame.width, y: 160)
            })
        }
    }
    private func createQuestion() {
        for i in 0..<totalQuestion {
            if Bool.random() {
                resultList.append(true)
                // true problem
                shapeList[i].backgroundColor = colorList.randomElement() // random
                colorNameLabelList[i].text = colorDictionary[shapeList[i].backgroundColor!]! // like shapeList
                colorNameLabelList[i].textColor = colorList.randomElement() // random
            } else {
                // false proplem
                resultList.append(false)
                shapeList[i].backgroundColor = colorList.randomElement() // random
                
                repeat {
                    colorNameLabelList[i].text = colorDictionary[colorList.randomElement() ]!
                } while(colorNameLabelList[i].text! == colorDictionary[shapeList[i].backgroundColor!]!) // text different from shape color
                
                colorNameLabelList[i].textColor = colorList.randomElement() // random
            }
        }
    }
    
    private func setupTrueFalseButton() {
        gamePlayingView.addSubview(xButton); gamePlayingView.addSubview(tickButton)
        gamePlayingView.addConstraints(withFormat: "H:|[v0(v1)][v1]|", views: xButton, tickButton)
        gamePlayingView.addConstraints(withFormat: "V:[v0(80)]|", views: xButton)
        gamePlayingView.addConstraints(withFormat: "V:[v0(80)]|", views: tickButton)
    }
    
    func pressXTickButton() {
        xButton.tag = 1
        tickButton.tag = 0
        xButton.addTarget(self, action: #selector(touchDownXTickMathSolvingButton(_:)), for: UIControlEvents.touchDown)
        tickButton.addTarget(self, action: #selector(touchDownXTickMathSolvingButton(_:)), for: UIControlEvents.touchDown)
    }
    @objc func touchDownXTickMathSolvingButton(_ sender: UIButton) {
        // check answer
        if sender.tag == 0 && resultList[questionSolvedCount] == true {
            // correct answer
            correctAnswerImageView.appearAndFadeAway()
            // thow right up
            UIView.animate(withDuration: 0.5, delay: 0, options: UIViewAnimationOptions.curveEaseOut, animations: {
                self.paperView[self.questionSolvedCount].transform = CGAffineTransform(translationX: self.view.frame.width, y: -160)
            })
        } else if sender.tag == 1 && resultList[questionSolvedCount] == false {
            // correct answer
            correctAnswerImageView.appearAndFadeAway()
            // throw left
            UIView.animate(withDuration: 0.5, delay: 0, options: UIViewAnimationOptions.curveEaseOut, animations: {
                self.paperView[self.questionSolvedCount].transform = CGAffineTransform(translationX: -self.view.frame.width, y: -160)
            })
        } else {
            // wrong answer
            wrongAnswerImageView.appearAndFadeAway()
            self.answerWrong()
            
            if sender.tag == 0 {
                // throw down right
                UIView.animate(withDuration: 0.5, delay: 0, options: UIViewAnimationOptions.curveEaseOut, animations: {
                    self.paperView[self.questionSolvedCount].transform = CGAffineTransform(translationX: self.view.frame.width, y: 160)
                })
            } else if sender.tag == 1 {
                // throw down left
                UIView.animate(withDuration: 0.5, delay: 0, options: UIViewAnimationOptions.curveEaseOut, animations: {
                    self.paperView[self.questionSolvedCount].transform = CGAffineTransform(translationX:  -self.view.frame.width, y: 160)
                })
            }
        }
        // set scale ratio
        if questionSolvedCount == 0 {
            for i in 0..<2 {
                scaleRatio.append(self.paperView[i].frame.width / self.paperView[i+1].frame.width)
                print(scaleRatio[i])
            }
        }
        // animate when player answer
        if questionSolvedCount < totalQuestion - 1 {
            UIView.animate(withDuration: 0.75, delay: 0, options: UIViewAnimationOptions.allowAnimatedContent, animations: {
                // first object scale
                self.paperView[self.questionSolvedCount + 1].transform = self.paperView[self.questionSolvedCount + 1].transform.scaledBy(x: self.scaleRatio[0], y: 1)
                // second object scale
                if self.questionSolvedCount < self.totalQuestion - 2 {
                    self.paperView[self.questionSolvedCount + 2].transform = self.paperView[self.questionSolvedCount + 2].transform.scaledBy(x: self.scaleRatio[1], y: 1)
                }
                // first label & shape scale
                self.colorNameLabelList[self.questionSolvedCount + 1].transform = self.colorNameLabelList[self.questionSolvedCount + 1].transform.scaledBy(x: 2-self.scaleRatio[0], y: 1)
                self.shapeList[self.questionSolvedCount + 1].transform = self.shapeList[self.questionSolvedCount + 1].transform.scaledBy(x: 2-self.scaleRatio[0], y: 1)
                // second label & shape scale
                if self.questionSolvedCount < self.totalQuestion - 2 {
                    self.colorNameLabelList[self.questionSolvedCount + 2].transform = self.colorNameLabelList[self.questionSolvedCount + 2].transform.scaledBy(x: 2-self.scaleRatio[1], y: 1)
                    self.shapeList[self.questionSolvedCount + 2].transform = self.shapeList[self.questionSolvedCount + 2].transform.scaledBy(x: 2-self.scaleRatio[1], y: 1)
                }
                
                // object move up
                self.paperView[self.questionSolvedCount + 1].transform = self.paperView[self.questionSolvedCount + 1].transform.translatedBy(x: 0, y: -8)
                if self.questionSolvedCount < self.totalQuestion - 2 {
                    self.paperView[self.questionSolvedCount + 2].transform = self.paperView[self.questionSolvedCount + 2].transform.translatedBy(x: 0, y: -8)
                }
                
                // object move down (appearance)
                if self.questionSolvedCount < self.totalQuestion - 3 {
                    self.paperView[self.questionSolvedCount + 3].transform = self.paperView[self.questionSolvedCount + 3].transform.translatedBy(x: 0, y: 8)
                }
            })
        }
        questionSolvedCount += 1
        // check validate
        if questionSolvedCount >= totalQuestion {
            if playerLife > 0 {
                pauseLayer(layer: timeLineView.layer)
                self.gamePlayingView.isUserInteractionEnabled = false
                Timer.scheduledTimer(withTimeInterval: 0.8, repeats: false) { (_) in
                    var viewController = self.navigationController?.viewControllers
                    let removedViewControllerIndex: Int = (viewController?.count)! - 1
                    viewController?.remove(at: removedViewControllerIndex)
                    viewController?.append(ImaginationGameVC(playerLife: self.playerLife))
                    
                    self.navigationController?.setViewControllers(viewController!, animated: true)
                    //self.navigationController?.pushViewController(ImaginationGameVC(), animated: true)
                }
            }
            return
        }
    }
    /* isDifferentColor game */
}






