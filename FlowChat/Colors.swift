//
//  Colors.swift
//  FlowChat
//
//  Created by aplle on 6/1/23.
//

import Foundation
import SwiftUI

extension Color{
    static let customPurple = Color(uiColor: UIColor(red: 0.161, green: 0.02, blue: 0.471, alpha: 1))
    static let background = LinearGradient(colors: [Color.black,customPurple,.white], startPoint: .topLeading, endPoint: .bottomTrailing)
}
