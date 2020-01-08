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
    
    var isPlaying = false
    // we need an instance of AVAudioPlayer
    var player =  AVAudioPlayer()
    // provide the path for the audio file
    let path = Bundle.main.path(forResource: "bach", ofType: "mp3")
    var timer = Timer()

    @IBOutlet weak var volumeSlider: UISlider!
    @IBOutlet weak var scrubber: UISlider!
    @IBOutlet weak var btnPlay: UIBarButtonItem!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        // adding gestures for the volume and scrubber slider
        let gr = UITapGestureRecognizer(target: self, action: #selector(self.sliderTapped(_:)))
        volumeSlider.addGestureRecognizer(gr)
        
        do {
            try player = AVAudioPlayer(contentsOf: URL(fileURLWithPath: path!))
            scrubber.maximumValue = Float(player.duration)
        } catch {
            print(error)
        }
        
    }
    /*
    override func motionEnded(_ motion: UIEvent.EventSubtype, with event: UIEvent?) {
        if event?.subtype == UIEvent.EventSubtype.motionShake {
            let soundArray = ["boing", "explosion", "hit", "knife", "shoot", "swish", "wah","warble"]
            let randomNumber = Int(arc4random_uniform(UInt32(soundArray.count)))
            
            let fileLocation = Bundle.main.path(forResource: soundArray[randomNumber], ofType: "mp3")
            do {
                try player = AVAudioPlayer(contentsOf: URL(fileURLWithPath: fileLocation!))
                player.play()
            } catch {
                print(error)
            }
            
        }
    }
    */

    @IBAction func playSound(_ sender: UIBarButtonItem) {
        if isPlaying {
            player.pause()
            timer.invalidate()
            btnPlay.image = UIImage(systemName: "play.fill")
            isPlaying = false
        } else {
            player.play()
            timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(updateScrubber), userInfo: nil, repeats: true)
            btnPlay.image = UIImage(systemName: "pause.fill")
            isPlaying = true
        }
    }
    /*
    @IBAction func pauseSound(_ sender: UIBarButtonItem) {
        player.pause()
        timer.invalidate()
    }
    */
    
    @IBAction func stopSound(_ sender: UIBarButtonItem) {
        player.stop()
        timer.invalidate()
        player.currentTime = 0
        btnPlay.image = UIImage(systemName: "play.fill")
        isPlaying = false
    }
    
    
    @objc func updateScrubber() {
        scrubber.value = Float(player.currentTime)
        if scrubber.value == scrubber.minimumValue {
            isPlaying = false
            btnPlay.image = UIImage(systemName: "play.fill")
        }
    }
    
    @IBAction func volumeChanged(_ sender: UISlider) {
        player.volume = volumeSlider.value
    }
    
    @IBAction func scrubberMoved(_ sender: UISlider) {
        player.currentTime = TimeInterval(scrubber.value)
        if isPlaying {
            player.play()
        }
        
    }
    
    @objc func sliderTapped(_ g: UIGestureRecognizer) {

        let s: UISlider? = (g.view as? UISlider)
        if (s?.isHighlighted)! {
            return
        }

        // tap on thumb, let slider deal with it
        let pt: CGPoint = g.location(in: s)
        let percentage = pt.x / (s?.bounds.size.width)!
        let delta = Float(percentage) * Float((s?.maximumValue)! - (s?.minimumValue)!)
        let value = (s?.minimumValue)! + delta
        s?.setValue(Float(value), animated: true)
        player.volume = s!.value
    }
    
}

