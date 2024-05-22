//
//  PushupsDetector.swift
//  Push Ups
//
//  Created by Richard Das on 25/04/2024.
//

import SwiftUI


@Observable class PushupsDetector {
    
    private let motionManager: MotionManager
    
    private var isPushupPhase = false
    
    private let downThreshold = -0.5
    private let upThreshold = 0.25
    private let proneThreshold = -0.8
    

    /// Whether or not there is an active session.
    var isActive: Bool = false
    
    /// The number of pushups counted in the active session.
    var count = 0
    
    /// The athelete is in the correct position for a pushup
    var isValidPosition: Bool = false

    
    init() {
        self.motionManager = MotionManager()
        motionManager.delegate = self
    }
    
    deinit {
        endSession()
    }
    
    
    func startSession() {
        print("Starting session…")
        motionManager.startUpdates()
        isActive = true
    }
    
    func endSession() {
        motionManager.stopUpdates()
        isActive = false
        print("Session ended.")
    }
    
    func incrementCount() {
        count += 1
    }
    
    func resetCount() {
        count = 0
    }
}


extension PushupsDetector: MotionManagerDelegate {
    
    func didUpdateAccelerationY(_ accelerationY: Double) {
        if accelerationY < downThreshold && !isPushupPhase {
            /// The user is moving downward in a push-up
            isPushupPhase = true

        } else if accelerationY > upThreshold && isPushupPhase {
            /// The user has moved back up
            incrementCount()
            isPushupPhase = false  // Reset the phase to detect the next push-up
        }
    }

    func didUpdatePitch(_ pitch: Double) {
        isValidPosition = pitch < proneThreshold
    }
}
