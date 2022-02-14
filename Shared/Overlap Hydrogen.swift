//
//  Overlap Hydrogen.swift
//  Overlap_Hydrogen_1s2px
//
//  Created by Alaina Thompson on 2/10/22.
//

import Darwin
import SwiftUI

class OverlapInt: NSObject,ObservableObject {
  
    let e = Darwin.M_E
    var atomicSpacing = 0.0
    //a = bohr radius
    var a = 0.529177
    var n = 0.0
    @Published var S = 0.0
    @Published var SText = ""
    @Published var RString = "0.0"
    @Published var enableButton = true
    
    



  
    
    
    
    
    func initWithOverlap(R: Double) async -> Bool {
            // a and R are in angstroms
            atomicSpacing = R
                
                let _ = await withTaskGroup(of:  Void.self) { taskGroup in
                    
            
                
                    taskGroup.addTask { let _ = await self.calculateS(R: self.atomicSpacing)}
                    
            }
                
                await setButtonEnable(state: true)
                                                     
           
            

            return true
            
        }
    
    
    
    
    func calculateS(R: Double) async -> Double {
        // integral for 1s and 2px adds an additional R/a to the integral
    
        //          - R /  a                   2
        //                            R       R     R
        // S(R)  =   e       (1 +   ---- +  -----)(---)
        //                           a         2    a
        //                                  3 a
        //
        n = R/a
        let exp = pow(e, -n)
        let frac1 = n
        let frac2 = pow(n, 2)/3
                
        let calculatedS = n*(1 + frac1 + frac2)*exp
        let newSText = String(format: "%7.5f", calculatedS)
        
        await updateS(STextString: newSText)
        await newSValue(SValue: calculatedS)
               
        return calculatedS
               
    }
    
    
    
    
    
    
    
    
    @MainActor func setButtonEnable(state: Bool){
               
               
               if state {
                   
                   Task.init {
                       await MainActor.run {
                           
                           
                           self.enableButton = true
                       }
                   }
                   
                   
                       
               }
               else{
                   
                   Task.init {
                       await MainActor.run {
                           
                           
                           self.enableButton = false
                       }
                   }
                       
               }
               
           }
           
          
           @MainActor func updateS(STextString: String){
               
               SText = STextString
               
           }
           
           @MainActor func newSValue(SValue: Double){
               
               self.S = SValue
               
           }
           

    
    
    
    
    
    
}
