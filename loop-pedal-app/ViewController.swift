//
//  ViewController.swift
//  SimpleRecordingApp
//
//  Created by Maggie Luo on 11/13/16.
//  Copyright © 2016 Maggie Luo. All rights reserved.
//

import UIKit
import AVFoundation

class ViewController: UIViewController, AVAudioPlayerDelegate, AVAudioRecorderDelegate {
    
    var audioPlayer: AVAudioPlayer?
    var audioRecorder: AVAudioRecorder?
    
    @IBOutlet weak var stopButton: UIButton!
    @IBOutlet weak var recordButton: UIButton!
    @IBOutlet weak var playButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // MARK: AVFOUNDATION
        playButton.isEnabled = false
        stopButton.isEnabled = false
        
        let fileMgr = FileManager.default
        
        let dirPaths = fileMgr.urls(for: .documentDirectory,
                                    in: .userDomainMask)
        
        let soundFileURL = dirPaths[0].appendingPathComponent("sound.caf")
        
        let recordSettings =
            [AVEncoderAudioQualityKey: AVAudioQuality.min.rawValue,
             AVEncoderBitRateKey: 16,
             AVNumberOfChannelsKey: 2,
             AVSampleRateKey: 44100.0] as [String : Any]
        
        let audioSession = AVAudioSession.sharedInstance()
        
        do {
            try audioSession.setCategory(
                AVAudioSessionCategoryPlayAndRecord)
        } catch let error as NSError {
            print("audioSession error: \(error.localizedDescription)")
        }
        
        do {
            try audioRecorder = AVAudioRecorder(url: soundFileURL,
                                                settings: recordSettings as [String : AnyObject])
            audioRecorder?.prepareToRecord()
        } catch let error as NSError {
            print("audioSession error: \(error.localizedDescription)")
        }
    }
    
    // MARK: ACTIONS
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    @IBAction func recordAudio(_ sender: UIButton?) {
        if audioRecorder?.isRecording == false {
            playButton.isEnabled = false
            stopButton.isEnabled = true
            audioRecorder?.record()
        }
    }
    
    
    @IBAction func stopAudio(_ sender: UIButton?) {
        stopButton.isEnabled = true
        
        if audioRecorder?.isRecording == true {
            playButton.isEnabled = false
            recordButton.isEnabled = false
            audioRecorder?.stop()
            playAudio(nil)
        } else {
            playButton.isEnabled = true
            recordButton.isEnabled = true
            audioPlayer?.stop()
        }
    }
    
    
    @IBAction func playAudio(_ sender: UIButton?) {
        if audioRecorder?.isRecording == false {
            stopButton.isEnabled = true
            recordButton.isEnabled = false
            
            do {
                try audioPlayer = AVAudioPlayer(contentsOf:
                    (audioRecorder?.url)!)
                audioPlayer!.delegate = self
                audioPlayer!.numberOfLoops = -1
                audioPlayer!.prepareToPlay()
                audioPlayer!.play()
            } catch let error as NSError {
                print("audioPlayer error: \(error.localizedDescription)")
            }
        }
    }
    
}

