//
//  ViewController.swift
//  Concentration
//
//  Created by Damir on 9/12/18.
//  Copyright © 2018 Damir. All rights reserved.
//

import UIKit

class ConcentrationViewController: UIViewController {

    
    private lazy var game = Concentration(numberOfPairsOfCards: numberOfPairsOfCards)
    
    var numberOfPairsOfCards: Int{ //computed property
//        get{
//            return cardButtons.count / 2
//        }
        return (visibleCardButtons.count+1) / 2    //same as above // read only
    }
    
    private(set) var flipCount = 0{
        didSet{
            updateFlipCountLabel()
        }
    }
    
    private func updateFlipCountLabel() {
        let attributes: [NSAttributedString.Key:Any] = [
            .strokeWidth: 5.0,
            .strokeColor: #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        ]
        let attributedString = NSAttributedString(
            string: traitCollection.verticalSizeClass == .compact ? "Flips\n\(flipCount)" :
            "Flips: \(flipCount)",
            attributes: attributes
        )
        flipCountLabel.attributedText = attributedString
    }
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        updateFlipCountLabel()
    }

    @IBOutlet private weak var flipCountLabel: UILabel!{
        didSet{
            updateFlipCountLabel()
        }
    }
    @IBOutlet private var cardButtons: [UIButton]!
    private var visibleCardButtons: [UIButton]!{
        return cardButtons?.filter{ !$0.superview!.isHidden }
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        updateViewFromModel()
    }
    
    @IBAction private func touchCard(_ sender: UIButton) {
        flipCount += 1;
        if let cardNumber = visibleCardButtons.index(of: sender){
//            print("cardNumber = \(cardNumber)")
//            fliipCard(withEmoji: emojiChoces[cardNumber], on: sender)
            game.chooseCard(at: cardNumber)
            updateViewFromModel()
        }else{
            print("card not found")
        }
        
    }
    
    private func updateViewFromModel(){
        if visibleCardButtons != nil{
            for index in visibleCardButtons.indices{
                let button = visibleCardButtons[index]
                let card = game.cards[index]
                if card.isFaceUp{
                    button.setTitle(emoji(for: card), for: UIControl.State.normal)
                    button.backgroundColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
                }else{
                    button.setTitle("", for: UIControl.State.normal)
                    button.backgroundColor = card.isMatched ? #colorLiteral(red: 1, green: 0.5763723254, blue: 0, alpha: 0) : #colorLiteral(red: 0.0431372549, green: 0.4156862745, blue: 1, alpha: 1)
                }
            }
        }
    }
    
    var theme: String?{
        didSet{
            emojiChoces = theme ?? ""
            emoji = [:]
            updateViewFromModel()
        }
    }
//    private var emojiChoces = ["🎃","👻","👽","💀","🤡","😈","🤖","👾","☠️"]
    private var emojiChoces = "" //= "🎃👻👽💀🤡😈🤖👾☠️"
    
    private var emoji = [Card: String]()
    
    private func emoji(for card: Card) -> String{
//        print("identifier = \(card.identifier)")
        if emoji[card] == nil, emojiChoces.count > 0{
            let randomStingIndex = emojiChoces.index(emojiChoces.startIndex, offsetBy: emojiChoces.count.arc4random)
            print("randomStingIndex = \(randomStingIndex)")
            emoji[card] = String(emojiChoces.remove(at: randomStingIndex))
        }
//        print("emoji : \(emoji)")
        return emoji[card] ?? "?"
    }
    
}

extension Int{
    var arc4random: Int{
        if self > 0{
            return Int(arc4random_uniform(UInt32(self)))
        }else if self < 0{
            return -Int(arc4random_uniform(UInt32(abs(self))))
        }else{
            return 0
        }
    }
}

