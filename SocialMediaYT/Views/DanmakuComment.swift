//
//  DanmakuComment.swift
//  SocialMediaYT
//
//  Created by user270092 on 3/14/25.
//


//
//  DanmakuComment.swift
//  VideoSharingCommunity
//
//  Created by Yijia Jiang on 2025-02-18.
//

import Foundation
import SwiftUI
import UIKit

struct DanmakuComment: Identifiable, Equatable {
    let id = UUID()
    var text: String
    var offsetX: CGFloat = UIScreen.main.bounds.width     
    static func == (lhs: DanmakuComment, rhs: DanmakuComment) -> Bool {
        return lhs.id == rhs.id && lhs.text == rhs.text && lhs.offsetX == rhs.offsetX
    }
}


