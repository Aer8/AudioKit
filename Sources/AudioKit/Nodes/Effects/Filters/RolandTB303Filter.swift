// Copyright AudioKit. All Rights Reserved. Revision History at http://github.com/AudioKit/AudioKit/
// This file was auto-autogenerated by scripts and templates at http://github.com/AudioKit/AudioKitDevTools/

import AVFoundation
import CAudioKit

/// Emulation of the Roland TB-303 filter
public class RolandTB303Filter: Node, AudioUnitContainer, Toggleable {

    /// Unique four-letter identifier "tb3f"
    public static let ComponentDescription = AudioComponentDescription(effect: "tb3f")

    /// Internal type of audio unit for this node
    public typealias AudioUnitType = AudioUnitBase

    /// Internal audio unit 
    public private(set) var internalAU: AudioUnitType?

    // MARK: - Parameters

    /// Specification details for cutoffFrequency
    public static let cutoffFrequencyDef = NodeParameterDef(
        identifier: "cutoffFrequency",
        name: "Cutoff Frequency (Hz)",
        address: akGetParameterAddress("RolandTB303FilterParameterCutoffFrequency"),
        initialValue: 500,
        range: 12.0 ... 20_000.0,
        unit: .hertz,
        flags: .default)

    /// Cutoff frequency. (in Hertz)
    @Parameter(cutoffFrequencyDef) public var cutoffFrequency: AUValue

    /// Specification details for resonance
    public static let resonanceDef = NodeParameterDef(
        identifier: "resonance",
        name: "Resonance",
        address: akGetParameterAddress("RolandTB303FilterParameterResonance"),
        initialValue: 0.5,
        range: 0.0 ... 2.0,
        unit: .generic,
        flags: .default)

    /// Resonance, generally < 1, but not limited to it. Higher than 1 resonance values might cause aliasing, analogue synths generally allow resonances to be above 1.
    @Parameter(resonanceDef) public var resonance: AUValue

    /// Specification details for distortion
    public static let distortionDef = NodeParameterDef(
        identifier: "distortion",
        name: "Distortion",
        address: akGetParameterAddress("RolandTB303FilterParameterDistortion"),
        initialValue: 2.0,
        range: 0.0 ... 4.0,
        unit: .generic,
        flags: .default)

    /// Distortion. Value is typically 2.0; deviation from this can cause stability issues. 
    @Parameter(distortionDef) public var distortion: AUValue

    /// Specification details for resonanceAsymmetry
    public static let resonanceAsymmetryDef = NodeParameterDef(
        identifier: "resonanceAsymmetry",
        name: "Resonance Asymmetry",
        address: akGetParameterAddress("RolandTB303FilterParameterResonanceAsymmetry"),
        initialValue: 0.5,
        range: 0.0 ... 1.0,
        unit: .percent,
        flags: .default)

    /// Asymmetry of resonance. Value is between 0-1
    @Parameter(resonanceAsymmetryDef) public var resonanceAsymmetry: AUValue

    // MARK: - Initialization

    /// Initialize this filter node
    ///
    /// - Parameters:
    ///   - input: Input node to process
    ///   - cutoffFrequency: Cutoff frequency. (in Hertz)
    ///   - resonance: Resonance, generally < 1, but not limited to it. Higher than 1 resonance values might cause aliasing, analogue synths generally allow resonances to be above 1.
    ///   - distortion: Distortion. Value is typically 2.0; deviation from this can cause stability issues. 
    ///   - resonanceAsymmetry: Asymmetry of resonance. Value is between 0-1
    ///
    public init(
        _ input: Node,
        cutoffFrequency: AUValue = cutoffFrequencyDef.initialValue,
        resonance: AUValue = resonanceDef.initialValue,
        distortion: AUValue = distortionDef.initialValue,
        resonanceAsymmetry: AUValue = resonanceAsymmetryDef.initialValue
        ) {
        super.init(avAudioNode: AVAudioNode())

        instantiateAudioUnit { avAudioUnit in
            self.avAudioNode = avAudioUnit

            guard let audioUnit = avAudioUnit.auAudioUnit as? AudioUnitType else {
                fatalError("Couldn't create audio unit")
            }
            self.internalAU = audioUnit

            self.cutoffFrequency = cutoffFrequency
            self.resonance = resonance
            self.distortion = distortion
            self.resonanceAsymmetry = resonanceAsymmetry
        }
        connections.append(input)
    }
}
