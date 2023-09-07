//
//  MathSolvingGameVC.swift
//  BrainGame
//
//  Created by Nguyễn Đức Huy on 8/17/18.
//  Copyright © 2018 Nguyễn Đức Huy. All rights reserved.
//

import UIKit

class MathSolvingGameVC: GamePlaygroundVC {
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
        setupMathQuestionView()
        setupTrueFalseButton()
        createMathQuestion()
        pressXTickButton()
        
        
    }
    
    @objc func unlockXTickButton(_ sender: Any) {
        self.setTimeValueForPaperViewAppearance += 0.05
        if self.setTimeValueForPaperViewAppearance >= 0.85 {
            self.timerOfPaperViewAppearance.invalidate()
            xButton.isEnabled = true
            tickButton.isEnabled = true
        }
    }
    /* set time to unlock x, tick button */
    var setTimeValueForPaperViewAppearance: Double = 0.0
    var timerOfPaperViewAppearance: Timer = Timer()
    var timer2: Timer = Timer()
    /* MathSolving */
    var totalQuestion       : Int       = 4
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
    var firstNumber: [Double] = []
    enum Operator: String {
        case plus  = "+"
        case minus = "-"
    }
    var _operator         : [Operator] = []
    var secondNumber      : [Double]   = []
    var resultNumber      : [Double]   = []
    var resultOnScreen    : [Double]   = []
    var isTrueProblem     : [Bool]     = []
    var mathLabel         : [UILabel]  = []
    static func createMathLabel() -> UILabel {
        let label = UILabel()
        label.text = ""
        label.font = UIFont.systemFont(ofSize: 28)
        label.textAlignment = .center
        label.frame.size.height = 42
        return label
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
    
    
    func setupMathQuestionView() {
        
        for i in 0..<totalQuestion {
            paperView.append(MathSolvingGameVC.createPaperView(zPosition: CGFloat(totalQuestion-i)))
            mathLabel.append(MathSolvingGameVC.createMathLabel())
            
            paperView[i].isUserInteractionEnabled = false
            
            gamePlayingView.addSubview(paperView[i])
            paperView[i].addSubview(mathLabel[i])
            paperView[i].translatesAutoresizingMaskIntoConstraints = false
            mathLabel[i].translatesAutoresizingMaskIntoConstraints = false
            
            paperView[i].centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: 0).isActive = true
            if i < 3 {
                paperView[i].centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: CGFloat(8*i)).isActive = true
                paperView[i].widthAnchor.constraint(equalTo: view.widthAnchor, constant: CGFloat(-120 - (8*i))).isActive = true
            } else {
                paperView[i].centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: CGFloat(8)).isActive = true
                paperView[i].widthAnchor.constraint(equalTo: view.widthAnchor, constant: CGFloat(-120 - (8*2))).isActive = true
            }
            paperView[i].heightAnchor.constraint(equalToConstant: 50*2).isActive = true
            
            mathLabel[i].centerXAnchor.constraint(equalTo: paperView[i].centerXAnchor).isActive = true
            mathLabel[i].centerYAnchor.constraint(equalTo: paperView[i].centerYAnchor).isActive = true
            mathLabel[i].widthAnchor.constraint(equalTo: paperView[i].widthAnchor, constant: 0).isActive = true
            mathLabel[i].heightAnchor.constraint(equalTo: paperView[i].heightAnchor, constant: 0).isActive = true
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
    
    private func setupTrueFalseButton() {
        gamePlayingView.addSubview(xButton); gamePlayingView.addSubview(tickButton)
        gamePlayingView.addConstraints(withFormat: "H:|[v0(v1)][v1]|", views: xButton, tickButton)
        gamePlayingView.addConstraints(withFormat: "V:[v0(80)]|", views: xButton)
        gamePlayingView.addConstraints(withFormat: "V:[v0(80)]|", views: tickButton)
    }
    
    private func createMathQuestion() {
        
        for i in 0..<totalQuestion {
            secondNumber.append(Double(UInt32.random(from: 5, to: 15)))
            if UInt32.random(from: 0, to: 1) == 0 {
                print("plus")
                _operator.append(.plus)
                firstNumber.append(Double(UInt32.random(from: 5, to: 15)))
            } else {
                print("minus")
                _operator.append(.minus)
                firstNumber.append(Double(UInt32.random(from: 0, to: 10) + UInt32(secondNumber[i]) + 2))
            }
            
            if Bool.random() {
                // true problem
                isTrueProblem.append(true)
                switch _operator[i] {
                    case .plus:
                        resultOnScreen.append(firstNumber[i] + secondNumber[i])
                    case .minus:
                        resultOnScreen.append(firstNumber[i] - secondNumber[i])
                }
                
            } else {
                // false problem
                isTrueProblem.append(false)
                switch _operator[i] {
                case .plus:
                    resultOnScreen.append(firstNumber[i] + secondNumber[i] - 2.0)
                case .minus:
                    resultOnScreen.append(firstNumber[i] - secondNumber[i] - 2.0)
                }
                
                let flag = resultOnScreen[i]
                while(true) {
                    resultOnScreen[i] = Double(UInt32.random(from: 0, to: 5) + UInt32(flag) )
                    if _operator[i] == .plus { if resultOnScreen[i] != firstNumber[i] + secondNumber[i] { break } }
                    else if _operator[i] == .minus { if resultOnScreen[i] != firstNumber[i] - secondNumber[i] { break } }
                }
            }
            
            var firstIntNumber: Int?
            var secondIntNumber: Int?
            var resultOnScreenInt: Int?
            
            if firstNumber[i].truncatingRemainder(dividingBy: 1) == 0 {
                firstIntNumber = Int(firstNumber[i])
            }
            if secondNumber[i].truncatingRemainder(dividingBy: 1) == 0 {
                secondIntNumber = Int(secondNumber[i])
            }
            if resultOnScreen[i].truncatingRemainder(dividingBy: 1) == 0 {
                resultOnScreenInt = Int(resultOnScreen[i])
            }
            
            if firstIntNumber != nil {
                mathLabel[i].text = String(firstIntNumber!)
            } else { mathLabel[i].text = String(firstNumber[i]) }
            mathLabel[i].text?.append(" \(_operator[i].rawValue) ")
            if secondIntNumber != nil {
                mathLabel[i].text?.append(String(secondIntNumber!))
            } else { mathLabel[i].text?.append(String(secondNumber[i])) }
            mathLabel[i].text?.append(" = ")
            if resultOnScreenInt != nil {
                mathLabel[i].text?.append(String(resultOnScreenInt!))
            } else { mathLabel[i].text?.append(String(resultOnScreen[i]))}
        }
        
        // calculate true result
        for i in 0..<totalQuestion {
            switch _operator[i] {
            case .plus:
                resultNumber.append(firstNumber[i] + secondNumber[i])
            case .minus:
                resultNumber.append(firstNumber[i] - secondNumber[i])
            }
        }
    }
    
    
    func pressXTickButton() {
        xButton.tag = 1
        tickButton.tag = 0
        xButton.addTarget(self, action: #selector(touchDownXTickMathSolvingButton(_:)), for: UIControlEvents.touchDown)
        tickButton.addTarget(self, action: #selector(touchDownXTickMathSolvingButton(_:)), for: UIControlEvents.touchDown)
    }
    @objc func touchDownXTickMathSolvingButton(_ sender: UIButton) {
        
        print(paperView[0].frame.width, paperView[1].frame.width, paperView[2].frame.width)
        print("Math Label:", mathLabel[questionSolvedCount].text!)
        print("is True problem:", isTrueProblem[questionSolvedCount])
        print("sender tag", sender.tag)
        // check answer
        if sender.tag == 0 && isTrueProblem[questionSolvedCount] == true {
            print("Math solving: true")
            self.correctAnswerImageView.appearAndFadeAway()
            
            // throw up right
            UIView.animate(withDuration: 0.5, delay: 0, options: UIViewAnimationOptions.curveEaseOut, animations: {
                self.paperView[self.questionSolvedCount].transform = CGAffineTransform(translationX: self.view.frame.width, y: -160)
            })
        } else if sender.tag == 1 && isTrueProblem[questionSolvedCount] == false {
            print("Math solving: true")
            self.correctAnswerImageView.appearAndFadeAway()
            // throw up left
            UIView.animate(withDuration: 0.5, delay: 0, options: UIViewAnimationOptions.curveEaseOut, animations: {
                self.paperView[self.questionSolvedCount].transform = CGAffineTransform(translationX: -self.view.frame.width, y: -160)
            })
        } else {
            print("Math solving: false")
            self.wrongAnswerImageView.appearAndFadeAway()
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
        
        print("")
        print(paperView[0].frame.width, paperView[1].frame.width, paperView[2].frame.width)
        questionSolvedCount += 1
        
        // check validate
        if questionSolvedCount >= totalQuestion {
            //self.navigationController?.popViewController(animated: true)
            if playerLife > 0 {
                pauseLayer(layer: timeLineView.layer)
                self.gamePlayingView.isUserInteractionEnabled = false
                Timer.scheduledTimer(withTimeInterval: 0.8, repeats: false, block: { (_) in
                    var viewController = self.navigationController?.viewControllers
                    let removedViewControllerIndex: Int = (viewController?.count)! - 1
                    viewController?.remove(at: removedViewControllerIndex)
                    viewController?.append(IsDifferentColorGameVC(playerLife: self.playerLife))
                    
                    self.navigationController?.setViewControllers(viewController!, animated: true)
                    
                    //self.navigationController?.pushViewController(IsDifferentColorGameVC(), animated: true)
                })
            }
            return
        }
    }
    /* MathSolving */
    
}
