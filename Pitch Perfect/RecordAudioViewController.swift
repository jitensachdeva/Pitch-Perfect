//
//  RecordAudioViewController.swift
//  Pitch Perfect
//
//  Created by Jitendra Sachdeva on 22/09/15.
//  Copyright (c) 2015 Dijini. All rights reserved.
//

import UIKit
import AVFoundation

class RecordAudioViewController: UIViewController, AVAudioRecorderDelegate {


    @IBOutlet weak var recordingMessage: UILabel!
    
    @IBOutlet weak var stopButton: UIButton!
    
    @IBOutlet weak var recordButton: UIButton!
    
    @IBOutlet weak var pauseButton: UIButton!
    
    @IBOutlet weak var resumeButton: UIButton!
    
    
    var audioRecorder:AVAudioRecorder!
    var recordedAudio:RecordedAudio!
    
    override func viewWillAppear(animated: Bool) {
        //reset to initial state
        super.viewWillAppear(animated)
        recordingInitiated(false)
    }

    @IBAction func recordAudio(sender: UIButton) {
        print("Recording Audio")
        prepareAudioRecorder()
        audioRecorder.record()
        recordingInitiated(true)
        recordingInProgress(true)
        
    }


    @IBAction func stopRecording(sender: UIButton) {
        print("Stop recording")
        audioRecorder.stop()
        let session = AVAudioSession.sharedInstance()
        do {
            try session.setActive(false)
        } catch _ {
            print("error in stop recording function")
        }
    }
    

    @IBAction func pauseRecording(sender: UIButton) {
        print("pause recording")
        audioRecorder.pause()
        recordingInProgress(false)
    }
    
    @IBAction func resumeRecording(sender: UIButton) {
        print("resume recording")
        audioRecorder.record()
        recordingInProgress(true)
    }
    
    func prepareAudioRecorder(){
        let dirPath = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)[0] 
        let recordingName = "my_audio.wav"
        let pathArray = [dirPath, recordingName]
        let filePath = NSURL.fileURLWithPathComponents(pathArray)
        print(filePath)
        
        let session = AVAudioSession.sharedInstance()
        do {
            try session.setCategory(AVAudioSessionCategoryPlayAndRecord)
        } catch _ {
            print("unable to set category for AVAudioSession")
        }
        audioRecorder = try? AVAudioRecorder(URL: filePath!, settings: [:])
        audioRecorder.delegate = self
        audioRecorder.meteringEnabled = true
        audioRecorder.prepareToRecord()
    }
    
    // change button state if recording is initiated
    func recordingInitiated(yes:Bool){
        recordButton.enabled = !yes
        resumeButton.hidden = !yes
        pauseButton.hidden = !yes
        stopButton.hidden = !yes
        if !yes {
          recordingMessage.text = "Tap to Record"
        }
        
    }
    
    //handle buttons and labels when recording is in progress/paused
    func recordingInProgress(yes :Bool){
        if yes {
            recordingMessage.text = "recording in progress.."
        }else {
           recordingMessage.text = "recording paused.."
        }
        
        resumeButton.enabled = !yes
        pauseButton.enabled = yes
        stopButton.enabled = yes
    }
    
    func audioRecorderDidFinishRecording(recorder: AVAudioRecorder, successfully flag: Bool) {
        if(flag){
            recordedAudio = RecordedAudio(filePathUrl: recorder.url, title: recorder.url.lastPathComponent )
            performSegueWithIdentifier("stopRecording", sender: recordedAudio)
        }else {
            print("Recording failed")
            recordingInitiated(false)
        }
        
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if (segue.identifier == "stopRecording"){
            let playSoundsVC:PlaySoundsViewController = segue.destinationViewController as! PlaySoundsViewController
            let data = sender as! RecordedAudio
            playSoundsVC.recordedAudio = data
        }
    }
    
   }

