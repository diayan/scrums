//
//  AVPlayer+Ding.swift
//  Scrumdinger
//
//  Created by diayan siat on 17/07/2021.
//

import Foundation
import AVFoundation

//AVPlayer+Ding.swift file defines the sharedDingPlayer object, which plays the ding.wav resource.
extension AVPlayer {
    static let sharedDingPlayer: AVPlayer = {
        guard let url = Bundle.main.url(forResource: "ding", withExtension: "wav")else {
            fatalError("Failed to find sound file")
        }
        
        return AVPlayer(url: url)
    }()
}
