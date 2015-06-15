//
//  RecordSoundsViewController.swift
//  Pitch Perfect
//
//  Created by Logan Yang on 5/29/15.
//  Copyright (c) 2015 Udacity. All rights reserved.
//

import UIKit
import AVFoundation

class RecordSoundsViewController: UIViewController, AVAudioRecorderDelegate {
    // (!) optional: forced unwrapping
    @IBOutlet weak var recordText: UILabel!
    @IBOutlet weak var recordInstruction: UILabel!
    @IBOutlet weak var recordAudio: UIButton!
    // we can use the same name for an outlet var as
    // another function, "stopRecording"
    @IBOutlet weak var stopRecording: UIButton!

    // Declared Globally
    var audioRecorder:AVAudioRecorder!
    var recordedAudio:RecordedAudio!    // this is the Model(our data) in MVC, it should be passed to the 2nd view: use UIViewController.prepareForSegue()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        recordText.hidden = true
        recordInstruction.hidden = false
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(animated: Bool) {
        // hide stop button
        stopRecording.hidden = true
        recordAudio.enabled = true
        recordInstruction.hidden = false
    }

    @IBAction func recordAudio(sender: UIButton) {
        recordText.hidden = false
        recordInstruction.hidden = true
        stopRecording.hidden = false
        
        // recordAudio button disabled
        recordAudio.enabled = false
        
        // Record
        let dirPath = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)[0] as! String
        let recordingName = "my_audio.wav"
        let pathArray = [dirPath, recordingName]
        let filePath = NSURL.fileURLWithPathComponents(pathArray)
        println(filePath)
        
        var session = AVAudioSession.sharedInstance()
        session.setCategory(AVAudioSessionCategoryPlayAndRecord, error: nil)
        
        audioRecorder = AVAudioRecorder(URL: filePath, settings: nil, error: nil)
        audioRecorder.delegate = self
        audioRecorder.meteringEnabled = true
        audioRecorder.prepareToRecord()
        audioRecorder.record()
    }
    
    func audioRecorderDidFinishRecording(recorder: AVAudioRecorder!, successfully flag: Bool){
        if(flag){
            // save the recorded audio. Use initializer to init the instance.
            recordedAudio = RecordedAudio(filePathUrl: recorder.url, title: recorder.url.lastPathComponent!)
            // move to the 2nd scene: perform segue
            self.performSegueWithIdentifier("stopRecording", sender: recordedAudio)
        } else {
            println("Recording was not successful")
            recordAudio.enabled = true
            stopRecording.hidden = true
        }
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if(segue.identifier == "stopRecording"){
            let playSoundVC:PlaySoundsViewController = segue.destinationViewController as! PlaySoundsViewController
            let data = sender as! RecordedAudio
            playSoundVC.receivedAudio = data
        }
    }
    
    @IBAction func stopRecording(sender: UIButton) {
        recordText.hidden = true
        audioRecorder.stop()
        var audioSession = AVAudioSession.sharedInstance()
        audioSession.setActive(false, error: nil)
    }

}

