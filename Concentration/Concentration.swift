//
//  Concentration.swift
//  Concentration
//
//  Created by Damir on 9/17/18.
//  Copyright © 2018 Damir. All rights reserved.
//

import Foundation

struct Concentration{
    
    private(set) var cards = [Card]()
    private(set) var flipCounter = 0
    
    private var indexOfOneAndOnlyOneFaceUpCard: Int?{ // computed property, never stores in memery. it gets on fly
        get{
            return cards.indices.filter({ cards[$0].isFaceUp }).oneAndOnlyOne
        }set {
            for index in cards.indices{
                cards[index].isFaceUp = (index == newValue) // put all cards face down, exept curent card
            }
        }
    }
    
    var isGameFinished: Bool{
        print(cards.indices.filter({ cards[$0].isMatched}).count)
        return cards.indices.filter({ cards[$0].isMatched}).count == cards.count  //check if all cards mathed
    }
    
    mutating func chooseCard(at index: Int){
        assert(cards.indices.contains(index), "Concentration.chooseCard(at: \(index)): chosen index not in the cards")
        if !cards[index].isMatched{
            //increase flip counter
            flipCounter += 1
            
            //if 2 card are faceUp
            if let matchIndex = indexOfOneAndOnlyOneFaceUpCard, matchIndex != index{
                //check if cards match
                if cards[matchIndex] == cards[index]{
                    cards[matchIndex].isMatched = true
                    cards[index].isMatched = true
                }
                cards[index].isFaceUp = true
            }else{
                // either no cards or 2 cards are face up
                indexOfOneAndOnlyOneFaceUpCard = index
            }
        }
    }
    
    init(numberOfPairsOfCards: Int){
        assert(numberOfPairsOfCards > 0, "Concentration.init(\(index)): you must have at least one pair of cards")
        for _ in 0..<numberOfPairsOfCards{
            let card = Card()
//            cards.append(card)
//            cards.append(card)
            cards += [card, card]
        }
        
        var shuffledCards = [Card]()
        
        for _ in cards.indices{
            let randomIndex = Int(arc4random_uniform(UInt32(cards.count)))
            shuffledCards.append(cards.remove(at: randomIndex))
        }
        cards = shuffledCards
    }
}

extension Collection{
    var oneAndOnlyOne: Element?{
        return count == 1 ? first : nil
    }
}
