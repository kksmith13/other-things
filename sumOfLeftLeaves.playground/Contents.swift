//: Playground - noun: a place where people can play

import UIKit

//             1
//          2     4
//        3      5  6
//                 7

class Node {
    var value: Int
    var leftChild: Node?
    var rightChild: Node?
    
    init(value: Int, leftChild: Node?, rightChild: Node?) {
        self.value = value;
        self.leftChild = leftChild;
        self.rightChild = rightChild
    }
}


let sevenNode = Node(value: 7, leftChild: nil, rightChild: nil)

let fiveNode = Node(value: 5, leftChild: nil, rightChild: nil)
let sixNode = Node(value: 6, leftChild: sevenNode, rightChild: nil)

let threeNode = Node(value: 3, leftChild: nil, rightChild: nil)

let twoNode = Node(value: 2, leftChild: threeNode, rightChild: nil)
let fourNode = Node(value: 4, leftChild: fiveNode, rightChild: sixNode)

let oneNode = Node(value: 1, leftChild: twoNode, rightChild: fourNode)


func sumOfLeftLeaves(node: Node?) -> Int {
    var result = 0
    //case of root being empty
    if(node != nil) {
        if(isNodeLeaf(node: node!.leftChild)) {
            result += node!.leftChild!.value
        } else {
            result += sumOfLeftLeaves(node: node!.leftChild)
        }
        
        result += sumOfLeftLeaves(node: node!.rightChild)
    }
    
    return result
}


func isNodeLeaf(node: Node?) -> Bool {
    
    if(node == nil) {
        return false
    }
    
    if(node!.leftChild == nil && node!.rightChild == nil) {
        return true
    }
    
    return false
}


sumOfLeftLeaves(node: oneNode)
