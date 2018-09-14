//: Playground - noun: a place where people can play

import UIKit

public class Node {
    var value: Int
    var leftChild: Node?
    var rightChild: Node?
    
    init(value: Int, leftChild: Node?, rightChild: Node?) {
        self.value = value
        self.leftChild = leftChild
        self.rightChild = rightChild
    }
}

//      5
//    2   6
//   1 3   7

let oneNode = Node(value: 1, leftChild: nil, rightChild: nil)
let threeNode = Node(value: 3, leftChild: nil, rightChild: nil)
let twoNode = Node(value: 2, leftChild: oneNode, rightChild: threeNode)

let sevenNode = Node(value: 7, leftChild: nil, rightChild: nil)
let sixNode = Node(value: 6, leftChild: nil, rightChild: sevenNode)

let fiveNode = Node(value: 9, leftChild: twoNode, rightChild: sixNode)


func isBST(node: Node) -> Bool {
    
    return isBSTUtil(node: node, min: Int(INT8_MIN), max: Int(INT8_MAX))
}

func isBSTUtil(node: Node?, min: Int, max: Int) -> Bool {
    //check for empty BST
    if node == nil {
        return true;
    }
    
    print(min, max)
    if(node!.value < min || node!.value > max) {
        return false;
    }
    
    return isBSTUtil(node: node!.leftChild, min: min, max: node!.value - 1) && isBSTUtil(node: node!.rightChild, min: node!.value + 1, max: max)

    
    
}

isBST(node: fiveNode)










