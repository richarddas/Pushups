//
//  MotionManager.swift
//  Push Ups
//
//  Created by Richard Das on 23/04/2024.
//

import CoreMotion


protocol MotionManagerDelegate: AnyObject {
    func didUpdateAccelerationY(_ accelerationY: Double)
    func didUpdatePitch(_ pitch: Double)
}


class MotionManager: NSObject {
   
    private var motionManager: CMHeadphoneMotionManager
    weak var delegate: MotionManagerDelegate?
    
    var isActive: Bool {
        motionManager.isDeviceMotionActive
    }
    
    var pitch: Double = 0.0 {
        didSet {
            delegate?.didUpdatePitch(pitch)
        }
    }
    
    var accelerationY: Double = 0.0 {
        didSet {
            delegate?.didUpdateAccelerationY(accelerationY)
        }
    }
    
    // Inject CMHeadphoneMotionManager to make this testable
    init(motionManager: CMHeadphoneMotionManager = CMHeadphoneMotionManager()) {
        self.motionManager = motionManager
    }
    
    deinit {
        stopUpdates()
    }
    
    func startUpdates() {
        guard motionManager.isDeviceMotionAvailable else {
            print("Device motion is not available")
            return
        }

        if motionManager.isDeviceMotionActive {
            print("Device motion is already active")
            return
        }
        
        print("[Motion Manager] Starting updates.")
        if motionManager.delegate == nil {
            motionManager.delegate = self
        }
        
        motionManager.startDeviceMotionUpdates(to: OperationQueue()) { [weak self] motion, error in
            guard let self = self, let motion = motion else { return }
            
            guard error == nil else {
                print("An error occurred: \(error!.localizedDescription)")
                return
            }

            self.pitch = motion.attitude.pitch
            self.accelerationY = motion.userAcceleration.y
        }
    }
    
    
    func stopUpdates() {
        guard motionManager.isDeviceMotionActive else {
            print("Device motion is already stopped.")
            return
        }
        
        motionManager.stopDeviceMotionUpdates()
        motionManager.delegate = nil
        
        print("[Motion Manager] Stopped updating.")
    }
}


extension MotionManager: CMHeadphoneMotionManagerDelegate {
    
    func headphoneMotionManagerDidConnect(_ manager: CMHeadphoneMotionManager) {
        print("Headphones Connected")
    }
    
    func headphoneMotionManagerDidDisconnect(_ manager: CMHeadphoneMotionManager) {
        print("Headphones Disconnected")
    }
}
