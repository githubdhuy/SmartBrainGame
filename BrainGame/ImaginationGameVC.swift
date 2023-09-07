//
//  ImaginationGameVC.swift
//  BrainGame
//
//  Created by Nguyễn Đức Huy on 8/18/18.
//  Copyright © 2018 Nguyễn Đức Huy. All rights reserved.
//

import UIKit

class ImaginationGameVC: GamePlaygroundVC {
    override func viewDidLoad() {
        super.viewDidLoad()
        checkPlayerLife()
        checkLevelLabel()
        // difficult level
        if levelValue > 3 {
            self.totalQuestion += Int(ceil((Double(Double(levelValue)/3) - 1.0))) + 1
            print("total",self.totalQuestion)
        }
        
        // set up views
        setupQuestionView()
        setupAnswerButton()
        getRandomAnswer()
        pressAnswerButton()
    }
    
    private var totalQuestion       : Int      = 5
    private var questionSolvedCount : Int      = 0
    private let questionView        : [UIView] = [UIView(), UIView(), UIView()]
    private let label: UILabel = {
        let label = UILabel()
        label.text = "Choose right Answer"
        label.font = UIFont(name: "Helvetica-Light", size: 22)
        label.textAlignment = .center
        return label
    }()
    private var correctAnswerIndex  : UInt32?
    private var answerButton        : [UIButton] = [UIButton(), UIButton(), UIButton()]
    private let colorDictionary     : [UIColor: String] = [
        UIColor.rgb(218, 93, 86) : "Red"  , UIColor.rgb(92, 108, 182) : "Blue"  , UIColor.rgb(114, 86, 73)  : "Brown",
        UIColor.rgb(65, 148, 136): "Green", UIColor.rgb(248, 213, 103): "Yellow", UIColor.rgb(169, 119, 211): "Violet",
        UIColor.rgb(10, 10, 10): "Black", UIColor.rgb(148, 156, 166): "Gray", UIColor.rgb(198, 252, 136): "LightGreen",
        UIColor.rgb(29, 32, 147): "DarkBlue"
    ]
    private let colorList: [UIColor] = [
        UIColor.rgb(218, 93, 86) , UIColor.rgb(92, 108, 182) , UIColor.rgb(114, 86, 73),
        UIColor.rgb(65, 148, 136), UIColor.rgb(248, 213, 103), UIColor.rgb(169, 119, 211),
        UIColor.rgb(10, 10, 10), UIColor.rgb(148, 156, 166), UIColor.rgb(198, 252, 136),
        UIColor.rgb(29, 32, 147)
    ]
    
    convenience init(playerLife: Int) {
        self.init()
        self.playerLife = playerLife
    }
    
    
    private func getBackgroundColorValidate(array : Array<UIView>, index: Int) -> UIColor {
        getBackgroundColor: repeat {
            array[index].backgroundColor = colorList.randomElement()
            for j in 0..<index {
                if array[index].backgroundColor == array[j].backgroundColor { continue getBackgroundColor }
            }
            break getBackgroundColor
        } while (true)
        return array[index].backgroundColor!
    }

    private func setupQuestionView() {
        for i in 0..<questionView.count {
            gamePlayingView.addSubview(questionView[i])
            questionView[i].backgroundColor = getBackgroundColorValidate(array: questionView, index: i)
            questionView[i].layer.cornerRadius = 4
            questionView[i].translatesAutoresizingMaskIntoConstraints = false
            
            questionView[i].frame.size.height = 16 + questionView[i].layer.cornerRadius
            questionView[i].heightAnchor.constraint(equalToConstant: CGFloat(questionView[i].frame.height)).isActive = true
            
            questionView[i].centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
            
            if i == 0 {
                questionView[i].widthAnchor.constraint(equalToConstant: CGFloat(90)).isActive = true
                questionView[i].centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: CGFloat(-150 + questionView[i].frame.height * CGFloat(i)) ).isActive = true
            } else {
                questionView[i].widthAnchor.constraint(equalToConstant: CGFloat(140 + 80*i)).isActive = true
                questionView[i].centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: CGFloat(-150 + questionView[i].frame.height * CGFloat(i)) - questionView[i].layer.cornerRadius * CGFloat(i)).isActive = true
            }
        }
    }
    private func setupAnswerButton() {
        gamePlayingView.addSubview(label)
        gamePlayingView.addConstraints(withFormat: "V:[v0]-40-[v1(50)]", views: questionView[questionView.count - 1], label)
        gamePlayingView.addConstraints(withFormat: "H:|-10-[v0]-10-|", views: label)
        
        
        for i in 0..<answerButton.count {
            gamePlayingView.addSubview(answerButton[i])
            let answerButtonHeight = gamePlayingView.frame.width/2 - 40
            
            switch i {
            case 0:
                // left
                gamePlayingView.addConstraints(withFormat: "V:[v0]-10-[v1(\(answerButtonHeight))]", views: label, answerButton[i])
                gamePlayingView.addConstraints(withFormat: "H:|-20-[v0(\(answerButtonHeight))]", views: answerButton[i])
            case 1:
                // right
                gamePlayingView.addConstraints(withFormat: "V:[v0]-10-[v1(\(answerButtonHeight))]", views: label, answerButton[i])
                gamePlayingView.addConstraints(withFormat: "H:[v0(\(answerButtonHeight))]-20-|", views: answerButton[i])
            case 2:
                // bottom
                gamePlayingView.addConstraints(withFormat: "V:[v0]-10-[v1(\(answerButtonHeight))]", views: answerButton[0], answerButton[i])
                gamePlayingView.addConstraints(withFormat: "H:|-\(gamePlayingView.frame.width/2 - answerButtonHeight/2)-[v0(\(answerButtonHeight))]", views: answerButton[i])
            default:
                print("none")
            }
            
            // set color of view in button
            let view1: UIView = UIView()
            let view2: UIView = UIView()
            let view3: UIView = UIView()
            
            view1.isUserInteractionEnabled = false
            view2.isUserInteractionEnabled = false
            view3.isUserInteractionEnabled = false
            
            answerButton[i].addSubview(view1)
            view1.layer.zPosition = 1
            view1.backgroundColor = colorList.randomElement()
            
            answerButton[i].addSubview(view2)
            view2.layer.zPosition = 2
            view2.backgroundColor = getBackgroundColorValidate(array: answerButton[i].subviews, index: answerButton[i].subviews.count - 1)
            
            answerButton[i].addSubview(view3)
            view3.layer.zPosition = 3
            view3.backgroundColor = getBackgroundColorValidate(array: answerButton[i].subviews, index: answerButton[i].subviews.count - 1)
            
            view1.layer.cornerRadius = answerButtonHeight / 2
            view2.layer.cornerRadius = answerButtonHeight / 2 - 15
            view3.layer.cornerRadius = answerButtonHeight / 2 - 50
            
            // layout view in button
            answerButton[i].addConstraints(withFormat: "H:|[v0]|", views: view1)
            answerButton[i].addConstraints(withFormat: "V:|[v0]|", views: view1)
            answerButton[i].addConstraints(withFormat: "H:|-15-[v0]-15-|", views: view2)
            answerButton[i].addConstraints(withFormat: "V:|-15-[v0]-15-|", views: view2)
            answerButton[i].addConstraints(withFormat: "H:|-50-[v0]-50-|", views: view3)
            answerButton[i].addConstraints(withFormat: "V:|-50-[v0]-50-|", views: view3)
        }
    }
    
    // set time to react player answer
    private var countTimeValueToReactPlayerAnswer: Double = 0.0
    private var timerToReactPlayerAnswer: Timer = Timer()
    
    private func getRandomAnswer() {
        // random correct answer
        let diceRoll: [[Int]] = [
            [0, 1, 2, 0, 1, 2], [1, 0, 2, 0, 2, 1], [0, 0, 1, 1, 2, 2],
            [0, 1, 0, 1, 0, 1], [0, 2, 0, 2, 0, 2], [1, 2, 1, 2, 1, 2]
        ]
        //correctAnswerIndex = UInt32.random(from: 0, to: 2)
        correctAnswerIndex = UInt32(diceRoll[Int(UInt32.random(from: 0, to: 5))] [Int(UInt32.random(from: 0, to: 5))])
        for i in 0..<questionView.count {
            answerButton[Int(correctAnswerIndex!)].subviews[i].backgroundColor = questionView[questionView.count - i - 1].backgroundColor
        }
        
        // validate color wrong answer
        var wrongAnswer: [Int] = [0, 1, 2]
        wrongAnswer.remove(at: Int(correctAnswerIndex!))

        ColorValidation: while(true) {
            for j in 0..<questionView.count {
                if answerButton[wrongAnswer[0]].subviews[j].backgroundColor! != answerButton[Int(correctAnswerIndex!)].subviews[j].backgroundColor!
                    && answerButton[wrongAnswer[1]].subviews[j].backgroundColor! != answerButton[Int(correctAnswerIndex!)].subviews[j].backgroundColor! {
                    break ColorValidation
                }
            }
            answerButton[wrongAnswer[0]].subviews[Int(UInt32.random(from: 0, to: 2))].backgroundColor = getBackgroundColorValidate(array: answerButton[wrongAnswer[0]].subviews, index: 2)
        }
        
        
    }
    private func pressAnswerButton() {
        for i in 0..<answerButton.count {
            answerButton[i].tag = i
            answerButton[i].addTarget(self, action: #selector(touchDownAnswerButton(_:)), for: UIControlEvents.touchDown)
        }
    }
    @objc private func touchDownAnswerButton(_ sender: UIButton) {
        gamePlayingView.isUserInteractionEnabled = false
        
        if sender.tag == Int(correctAnswerIndex!) {
            print("yes")
            self.reactPlayerAnswerView.backgroundColor = UIColor(white: 1, alpha: 0.4)
            self.correctAnswerImageView.alpha = 1
        } else {
            print("no")
            self.reactPlayerAnswerView.backgroundColor = UIColor(white: 1, alpha: 0.4)
            self.wrongAnswerImageView.alpha = 1
            self.answerWrong()
        }
        
        // end time when react player answer
        pauseLayer(layer: timeLineView.layer)
        self.timerToReactPlayerAnswer = Timer.scheduledTimer(timeInterval: 0.05, target: self, selector: #selector(setTimeToReactPlayerAnswer), userInfo: nil, repeats: true)
        
        self.questionSolvedCount += 1
        print(self.questionSolvedCount)
        
        // check end game or not
        if self.questionSolvedCount >= self.totalQuestion {
            if playerLife > 0 {
                pauseLayer(layer: timeLineView.layer)
                self.gamePlayingView.isUserInteractionEnabled = false
                //pauseLayer(layer: timeLineView.layer)
                Timer.scheduledTimer(withTimeInterval: 0.78, repeats: false) { (_) in
                    var viewController = self.navigationController?.viewControllers
                    let removedViewControllerIndex: Int = (viewController?.count)! - 1
                    viewController?.remove(at: removedViewControllerIndex)
                    viewController?.append(MathSolvingGameVC(playerLife: self.playerLife))
                    
                    self.navigationController?.setViewControllers(viewController!, animated: true)
                    //self.navigationController?.pushViewController(MathSolvingGameVC(), animated: true)
                }
            }
            //print("finished")
        }
    }
    @objc private func setTimeToReactPlayerAnswer() {
        
        self.countTimeValueToReactPlayerAnswer += 0.05
        if self.countTimeValueToReactPlayerAnswer >= 0.75 {
            self.countTimeValueToReactPlayerAnswer = 0
            self.timerToReactPlayerAnswer.invalidate()
            
            gamePlayingView.isUserInteractionEnabled = true
            self.reactPlayerAnswerView.backgroundColor = UIColor.clear
            self.correctAnswerImageView.alpha = 0
            self.wrongAnswerImageView.alpha = 0
            if playerLife > 0 { self.changeQuestion(); resumeLayer(layer: timeLineView.layer) }
            
            // time is continue
            
        }
        
    }
    
    private func changeQuestion() {
        for i in 0..<questionView.count {
            questionView[i].backgroundColor = getBackgroundColorValidate(array: questionView, index: i)
            for j in 0..<questionView.count {
                answerButton[i].subviews[j].backgroundColor = getBackgroundColorValidate(array: answerButton[i].subviews, index: j)
            }
        }
        self.getRandomAnswer()
    }

}







