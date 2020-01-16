//
//  Extension.swift
//  HitTheRed
//
//  Created by Wooyoung Song on 11/27/19.
//  Copyright © 2019 Wooyoung Song. All rights reserved.
//

import Foundation
import SceneKit
import ARKit

extension SCNNode{
    // Doubles the size of node and back to original
    func touchedAnim(){
        //1. Create An SCNAction Which Will Double The Size Of Our Node
        let growAction = SCNAction.scale(by: 1.15, duration: 0.35)

        //2. Create Another SCNAction Wjich Will Revert Our Node Back To It's Original Size
        let shrinkAction = SCNAction.scale(by: 0.87, duration: 0.35)

        //3. Create An Animation Sequence Which Will Store Our Actions
        let animationSequence = SCNAction.sequence([growAction, shrinkAction])

        //4. Run The Sequence
        self.runAction(animationSequence)

    }
    
    func isTarget()->Bool{
        let planeColor = self.geometry?.firstMaterial?.diffuse.contents as! UIColor
        if planeColor.equals(UIColor.red) {
            return true
        }
        
        return false
    }
}

extension UIColor {
    func equals(_ rhs: UIColor) -> Bool {
        var lhsR: CGFloat = 0
        var lhsG: CGFloat = 0
        var lhsB: CGFloat = 0
        var lhsA: CGFloat = 0
        self.getRed(&lhsR, green: &lhsG, blue: &lhsB, alpha: &lhsA)

        var rhsR: CGFloat = 0
        var rhsG: CGFloat = 0
        var rhsB: CGFloat = 0
        var rhsA: CGFloat = 0
        rhs.getRed(&rhsR, green: &rhsG, blue: &rhsB, alpha: &rhsA)

        return  lhsR == rhsR &&
                lhsG == rhsG &&
                lhsB == rhsB &&
                lhsA == rhsA
    }
}
