// Copyright AudioKit. All Rights Reserved. Revision History at http://github.com/AudioKit/AudioKit/
// This file was auto-autogenerated by scripts and templates at http://github.com/AudioKit/AudioKitDevTools/

import AVFoundation
import CAudioKit

/// These filters are Butterworth second-order IIR filters. They offer an almost flat
/// passband and very good precision and stopband attenuation.
/// 
public class HighPassButterworthFilter: Node, AudioUnitContainer, Toggleable {

    /// Unique four-letter identifier "bthp"
    public static let ComponentDescription = AudioComponentDescription(effect: "bthp")

    /// Internal type of audio unit for this node
    public typealias AudioUnitType = AudioUnitBase

    /// Internal audio unit 
    public private(set) var internalAU: AudioUnitType?

    // MARK: - Parameters

    /// Specification details for cutoffFrequency
    public static let cutoffFrequencyDef = NodeParameterDef(
        identifier: "cutoffFrequency",
        name: "Cutoff Frequency (Hz)",
        address: akGetParameterAddress("HighPassButterworthFilterParameterCutoffFrequency"),
        initialValue: 500.0,
        range: 12.0 ... 20_000.0,
        unit: .hertz,
        flags: .default)

    /// Cutoff frequency. (in Hertz)
    @Parameter(cutoffFrequencyDef) public var cutoffFrequency: AUValue

    // MARK: - Initialization

    /// Initialize this filter node
    ///
    /// - Parameters:
    ///   - input: Input node to process
    ///   - cutoffFrequency: Cutoff frequency. (in Hertz)
    ///
    public init(
        _ input: Node,
        cutoffFrequency: AUValue = cutoffFrequencyDef.initialValue
        ) {
        super.init(avAudioNode: AVAudioNode())

        instantiateAudioUnit { avAudioUnit in
            self.avAudioNode = avAudioUnit

            guard let audioUnit = avAudioUnit.auAudioUnit as? AudioUnitType else {
                fatalError("Couldn't create audio unit")
            }
            self.internalAU = audioUnit

            self.cutoffFrequency = cutoffFrequency
        }
        connections.append(input)
    }
}
