//
//  shakeShakeMessages.swift
//  SnapChat-V3
//
//  Created by lavintyben on 16/10/13.
//  Copyright © 2016年 Brendan Lee. All rights reserved.
//

import Foundation

class shakeShakeMessages{
    
    static var messages:[shakeShakeMessage] = []
    
    // Initialize some data for testing
    static func initializeSomeData (){
        messages.append(shakeShakeMessage(username: "Xiaolei Liu", content: "I am addicted to your beauty" ))
        messages.append(shakeShakeMessage(username: "Hua Hua", content: "Do not want face"))
        messages.append(shakeShakeMessage(username: "Steve Guo", content: "Good Job!!!!"))
        messages.append(shakeShakeMessage(username: "Jie He", content: "The source of energy"))
        messages.append(shakeShakeMessage(username: "Team Whatever", content: "Nice team! I love it"))
    }
    
    // Get the three messages by random
    static func getThreeMessagesRandomly() -> [shakeShakeMessage]{
        
        // If less or equal to 3, then just return those messages
        if (self.messages.count <= 3){
            
            let remainingMessages = self.messages
            
            // Remove all the messages
            messages.removeAll()
            
            return remainingMessages
        }
        
        // If not, randomly pick 3 messages to return
        let threeRandomMessages = messages.randomlyChoose(3)
        
        // Remove those messages in the array
        self.messages = messages.filter({
            message in
                for randomMessage in threeRandomMessages{
                    if (message == randomMessage){
                        return false
                    }
                }
            return true
        })
        
        print (messages)
        return threeRandomMessages
    }
}

// -----------------------------Extension used to support random picking------------------------------
extension Array {
    var shuffle:[Element] {
        var elements = self
        for index in indices {
            let anotherIndex = Int(arc4random_uniform(UInt32(elements.count - index))) + index
            anotherIndex != index ? swap(&elements[index], &elements[anotherIndex]) : ()
        }
        return elements
    }
    mutating func shuffled() {
        self = shuffle
    }
    var chooseOne: Element {
        return self[Int(arc4random_uniform(UInt32(count)))]
    }
    
    func randomlyChoose(x:Int) -> [Element] {
        if x > count { return shuffle }
        let indexes = count.indexRandom[0..<x]
        var result: [Element] = []
        for index in indexes {
            result.append(self[index])
        }
        return result
    }
}

extension Int {
    var random: Int {
        return Int(arc4random_uniform(UInt32(abs(self))))
    }
    var indexRandom: [Int] {
        return  Array(0..<self).shuffle
    }
}