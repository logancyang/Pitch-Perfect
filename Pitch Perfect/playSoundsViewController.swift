//
//  PlaySoundsViewController.swift
//  Pitch Perfect
//
//  Created by Logan Yang on 6/1/15.
//  Copyright (c) 2015 Udacity. All rights reserved.
//

import UIKit
import AVFoundation

class PlaySoundsViewController: UIViewController {
    // declare audioPlayer of class AVAudioPlayer as global var
    var audioPlayer:AVAudioPlayer!
    var receivedAudio:RecordedAudio!
    var audioEngine:AVAudioEngine!
    var audioFile:AVAudioFile!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        audioPlayer = AVAudioPlayer(contentsOfURL: receivedAudio.filePathUrl, error: nil)
        audioPlayer.enableRate = true
        audioEngine = AVAudioEngine()
        audioFile = AVAudioFile(forReading: receivedAudio.filePathUrl, error: nil)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func playBack(){
        // it's good practice to stop before playing
        audioPlayer.stop()
        audioPlayer.currentTime = 0
        audioPlayer.play()
    }
    
    @IBAction func playSlowly(sender: UIButton) {
        audioEngine.reset()
        audioPlayer.rate = 0.5
        playBack()
    }

    @IBAction func playFast(sender: UIButton) {
        audioEngine.reset()
        audioPlayer.rate = 1.5
        playBack()
    }
    
    // type: Float (capital F)
    func playAudioWithVariablePitch(pitch:Float){
        // make sure to stop playing
        audioPlayer.stop()
        audioEngine.stop()
        audioEngine.reset()
        
        // audioPlayerNode represents our audio file, and attach to engine
        var audioPlayerNode = AVAudioPlayerNode()
        audioEngine.attachNode(audioPlayerNode)
        
        // create the class instance that can change pitch, and attach to engine
        var changePitchEffect = AVAudioUnitTimePitch()
        changePitchEffect.pitch = pitch
        audioEngine.attachNode(changePitchEffect)
        
        // connect audioPlayerNode to changePitchEffect
        audioEngine.connect(audioPlayerNode, to: changePitchEffect, format: nil)
        // connect changePitchEffect to output (like the speakers)
        audioEngine.connect(changePitchEffect, to: audioEngine.outputNode, format: nil)
        
        // audioFile:AVAudioFile <- receivedAudio
        audioPlayerNode.scheduleFile(audioFile, atTime: nil, completionHandler: nil)
        audioEngine.startAndReturnError(nil)
        
        audioPlayerNode.play()
    }
    
    @IBAction func playChipmunk(sender: UIButton) {
        playAudioWithVariablePitch(1000)
    }
    
    @IBAction func playDarthvader(sender: UIButton) {
        playAudioWithVariablePitch(-1000)
    }
    
    @IBAction func stopAudio(sender: UIButton) {
        audioPlayer.stop()
        audioEngine.stop()
        audioEngine.reset()
        // how to reset to the start?
        // set currentTime = 0 in the play funcs
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
