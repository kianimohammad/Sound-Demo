//
//  ViewController.swift
//  Sound Demo
//
//  Created by Mohammad Kiani on 2020-01-07.
//  Copyright © 2020 mohammadkiani. All rights reserved.
//

import UIKit
import AVFoundation

class ViewController: UIViewController {
    
    // we need an instance of AVAudioPlayer
    var player =  AVAudioPlayer()
    // provide the path for the audio file
    let path = Bundle.main.path(forResource: "bach", ofType: "mp3")
    var timer = Timer()

    @IBOutlet weak var volumeSlider: UISlider!
    @IBOutlet weak var scrubber: UISlider!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
//        do {
//            try player = AVAudioPlayer(contentsOf: URL(fileURLWithPath: path!))
//            scrubber.maximumValue = Float(player.duration)
//        } catch {
//            print(error)
//        }
        
    }
    
    override func motionEnded(_ motion: UIEvent.EventSubtype, with event: UIEvent?) {
        if event?.subtype == UIEvent.EventSubtype.motionShake {
            let soundArray = ["boing", "explosion", "hit", "knife", "shoot", "swish", "wah","warble"]
            let randomNumber = Int(arc4random_uniform(UInt32(soundArray.count)))
            
            let fileLocation = Bundle.main.path(forResource: soundArray[randomNumber], ofType: "mp3")
            do {
                try player = AVAudioPlayer(contentsOf: URL(fileURLWithPath: fileLocation!))
//                scrubber.maximumValue = Float(player.duration)
                player.play()
            } catch {
                print(error)
            }
            
        }
    }

    @IBAction func playSound(_ sender: UIBarButtonItem) {
        player.play()
        timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(updateScrubber), userInfo: nil, repeats: true)
//        timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(updateScrubber), userInfo: nil, repeats: true)
    }
    @IBAction func pauseSound(_ sender: UIBarButtonItem) {
        player.pause()
        timer.invalidate()
    }
    @IBAction func stopSound(_ sender: UIButton) {
        player.stop()
        timer.invalidate()
        player.currentTime = 0
    }
    
    @objc func updateScrubber() {
        scrubber.value = Float(player.currentTime)
    }
    
    @IBAction func volumeChanged(_ sender: UISlider) {
        player.volume = volumeSlider.value
    }
    @IBAction func scrubberMoved(_ sender: UISlider) {
        player.currentTime = TimeInterval(scrubber.value)
        player.play()
    }
    
    
    
}

