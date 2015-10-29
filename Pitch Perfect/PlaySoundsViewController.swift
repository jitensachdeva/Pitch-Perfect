//
//  PlaySoundsViewController.swift
//  Pitch Perfect
//
//  Created by Jitendra Sachdeva on 26/09/15.
//  Copyright (c) 2015 Dijini. All rights reserved.
//

import UIKit
import AVFoundation

class PlaySoundsViewController: UIViewController {

    var audioPlayer:AVAudioPlayer!
    var recordedAudio:RecordedAudio!
    
    var audioEngine:AVAudioEngine!
    var audioFile:AVAudioFile!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        audioPlayer = try? AVAudioPlayer(contentsOfURL: recordedAudio.filePathUrl)
        audioPlayer.enableRate = true
        
        audioEngine = AVAudioEngine()
        audioFile = try? AVAudioFile(forReading: recordedAudio.filePathUrl)
       
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func stopAudio(sender: UIButton) {
        print("stop audio button clicked")
        audioPlayer.stop()
        audioEngine.stop()

    }
    @IBAction func playFastAudio(sender: UIButton) {
        print("fast audio button clicked")
        playAudio(1.5)
    }

    @IBAction func playSlowAudio(sender: UIButton) {
        print("Slow Audio button clicked")
        playAudio(0.5)

    }
    
    @IBAction func playChipmunkAudio(sender: UIButton) {
       playAudioWithVariablePitch(1000)
    }
    
    @IBAction func playDarthvaderAudio(sender: UIButton) {
        playAudioWithVariablePitch(-1000)
    }
    
    func playAudioWithVariablePitch(pitch: Float) {
        resetPlayback()
        
        let audioPlayerNode = AVAudioPlayerNode()
        audioEngine.attachNode(audioPlayerNode)
        
        let changePitchEffect = AVAudioUnitTimePitch()
        changePitchEffect.pitch = pitch
        audioEngine.attachNode(changePitchEffect)
        
        audioEngine.connect(audioPlayerNode, to: changePitchEffect, format: nil)
        audioEngine.connect(changePitchEffect, to: audioEngine.outputNode, format: nil)
        
        audioPlayerNode.scheduleFile(audioFile, atTime: nil, completionHandler: nil)
        do {
            try audioEngine.start()
        } catch _ {
        }
        
        audioPlayerNode.play()
    }
    
    func resetPlayback(){
        audioPlayer.stop()
        audioEngine.stop()
        audioEngine.reset()
    }
    
    func playAudio(speed:Float){
        resetPlayback()
        audioPlayer.currentTime = 0.0
        audioPlayer.rate = speed
        audioPlayer.play()
    }

}
