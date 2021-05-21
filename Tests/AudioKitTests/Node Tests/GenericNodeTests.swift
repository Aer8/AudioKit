// Copyright AudioKit. All Rights Reserved. Revision History at http://github.com/AudioKit/AudioKit/

import Foundation
@testable import AudioKit
import GameplayKit
import AVFoundation
import XCTest

func setParams(node: Node, rng: GKRandomSource) {

    for param in node.parameters {
        let def = param.def
        let size = def.range.upperBound - def.range.lowerBound
        let value = rng.nextUniform() * size + def.range.lowerBound
        print("setting parameter \(def.name) to \(value)")
        param.value = value
    }

}

class GenericNodeTests: XCTestCase {

    func nodeRandomizedTest(md5: String, factory: ()->Node, audition: Bool = false) {

        // We want determinism.
        let rng = GKMersenneTwisterRandomSource(seed: 0)

        let duration = 10
        let engine = AudioEngine()
        var bigBuffer: AVAudioPCMBuffer? = nil

        for _ in 0 ..< duration {

            let node = factory()
            engine.output = node

            node.start()

            let audio = engine.startTest(totalDuration: 1.0)
            setParams(node: node, rng: rng)
            audio.append(engine.render(duration: 1.0))

            if bigBuffer == nil {
                bigBuffer = AVAudioPCMBuffer(pcmFormat: audio.format, frameCapacity: audio.frameLength*UInt32(duration))
            }

            bigBuffer?.append(audio)
        }

        XCTAssertFalse(bigBuffer!.isSilent)

        if audition { bigBuffer!.audition() }

        XCTAssertEqual(bigBuffer!.md5, md5)
    }

    func nodeParameterTest(md5: String, factory: (Node)->Node, m1MD5: String = "", audition: Bool = false) {

        let bundle = Bundle.module
        let url = bundle.url(forResource: "12345", withExtension: "wav", subdirectory: "TestResources")!
        let player = AudioPlayer(url: url)!
        let node = factory(player)

        let duration = node.parameters.count + 1

        let engine = AudioEngine()
        var bigBuffer: AVAudioPCMBuffer? = nil

        engine.output = node

        /// Do the default parameters first
        if bigBuffer == nil {
            let audio = engine.startTest(totalDuration: 1.0)
            player.play()
            player.isLooping = true
            audio.append(engine.render(duration: 1.0))
            bigBuffer = AVAudioPCMBuffer(pcmFormat: audio.format, frameCapacity: audio.frameLength * UInt32(duration))

            bigBuffer?.append(audio)
        }

        for i in 0 ..< node.parameters.count {

            let node = factory(player)
            engine.output = node

            let param = node.parameters[i]

            node.start()

            param.value = param.def.range.lowerBound
            param.ramp(to: param.def.range.upperBound, duration: 1)

            let audio = engine.startTest(totalDuration: 1.0)
            audio.append(engine.render(duration: 1.0))

            bigBuffer?.append(audio)

        }

        XCTAssertFalse(bigBuffer!.isSilent)

        if audition {
            bigBuffer!.audition()
        }
        XCTAssertTrue([md5, m1MD5].contains(bigBuffer!.md5), "\(node)\nFAILEDMD5 \(bigBuffer!.md5)")
    }


    let waveforms = [Table(.square), Table(.triangle), Table(.sawtooth), Table(.square)]

    @available(macOS 10.15, iOS 13.0, tvOS 13.0, *)
    func testGenerators() {
        nodeParameterTest (md5: "0118dbf3e33bc3052f2e375f06793c5f", factory: { _ in PlaygroundOscillator(waveform: Table(.square)) })
        nodeParameterTest (md5: "789c1e77803a4f9d10063eb60ca03cea", factory: { _ in PlaygroundOscillator(waveform: Table(.triangle)) })
        nodeParameterTest (md5: "8d1ece9eb2417d9da48f5ae796a33ac2", factory: { _ in PlaygroundOscillator(waveform: Table(.triangle), amplitude: 0.1) })
    }

    func testEffects() {
        //nodeParameterTest(md5: "d15c926f3da74630f986f7325adf044c", factory: { input in Compressor(input) })
        nodeParameterTest(md5: "d658edfaaebabcaaeb8a6670d1d60541", factory: { input in Decimator(input) })
        nodeParameterTest(md5: "5955693c964588d2eb571fadb2d744dd", factory: { input in Delay(input) })
        //nodeParameterTest(md5: "", factory: { input in DiodeClipper(input) }, m1MD5: "9601674f792663a987e62b07b6ce405f")
        nodeParameterTest(md5: "6df759dd0dae23adb7b5f1c03ca15615", factory: { input in Distortion(input) })
        nodeParameterTest(md5: "4038dc9888744626dc769da6f5da4d06", factory: { input in DynaRageCompressor(input) })
        nodeParameterTest(md5: "1f023474b6150286e854485f00a0d1b4", factory: { input in Flanger(input) })
        //nodeParameterTest(md5: "0ae9a6b248486f343c55bf0818c3007d", factory: { input in PeakLimiter(input) })
        nodeParameterTest(md5: "a4d00e9a117e58eec42c01023b40a15a", factory: { input in RhinoGuitarProcessor(input) })
        nodeParameterTest(md5: "b31ce15bb38716fd95070d1299679d3a", factory: { input in RingModulator(input) })
        nodeParameterTest(md5: "2d667d22162edd87d6ae8ec8bfccc77e", factory: { input in StereoDelay(input) })
        nodeParameterTest(md5: "8c5c55d9f59f471ca1abb53672e3ffbf", factory: { input in StereoFieldLimiter(input) })

        #if os(iOS)
        nodeParameterTest(md5: "28d2cb7a5c1e369ca66efa8931d31d4d", factory: { player in Reverb(player) })
        #endif
        
        #if os(macOS)
        nodeParameterTest(md5: "bff0b5fa57e589f5192b17194d9a43cb", factory: { player in Reverb(player) })
        #endif
        
    }
    
    func testFilters() {
        nodeParameterTest(md5: "03e7b02e4fceb5fe6a2174740eda7e36", factory: { input in HighPassFilter(input) })
        nodeParameterTest(md5: "af137ecbe57e669340686e9721a2d1f2", factory: { input in HighShelfFilter(input) })
        nodeParameterTest(md5: "a43c821e13efa260d88d522b4d29aa45", factory: { input in LowPassFilter(input) })
        nodeParameterTest(md5: "2007d443458f8536b854d111aae4b51b", factory: { input in LowShelfFilter(input) })
    }
}