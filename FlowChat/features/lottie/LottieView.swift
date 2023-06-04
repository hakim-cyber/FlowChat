//
//  lottieview.swift
//  FlowChat
//
//  Created by aplle on 6/3/23.
//

import SwiftUI
import UIKit
import Lottie

struct LottieView:UIViewRepresentable{
    func makeUIView(context: Context) -> Lottie.LottieAnimationView{
        
       
        let animationView = LottieAnimationView(name: "145481-planet-earth-and-rocket")
        animationView.loopMode = .loop
        animationView.animationSpeed = 2.0
        animationView.play()
        
       
       
        return animationView
    }
    func updateUIView(_ uiView: UIViewType, context: Context) {
        
    }
}

