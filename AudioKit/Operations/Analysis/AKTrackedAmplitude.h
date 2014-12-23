//
//  AKTrackedAmplitude.h
//  AudioKit
//
//  Auto-generated on 12/23/14.
//  Copyright (c) 2014 Aurelius Prochazka. All rights reserved.
//

#import "AKControl.h"
#import "AKParameter+Operation.h"

/** One line title / summary for the operation.Determines the root-mean-square amplitude of an audio signal.

 Determines the root-mean-square amplitude of an audio signal. It low-pass filters the actual value, to average in the manner of a VU meter. This unit is not a signal modifier, but functions rather as a signal power-gauge. It uses an internal low-pass filter to make the response smoother. The halfPowerPoint can be used to control this smoothing. The higher the value, the "snappier" the measurement.
 */

@interface AKTrackedAmplitude : AKControl
/// Instantiates the tracked amplitude with all values
/// @param audioSource Input audio signal to track. [Default Value: ]
/// @param halfPowerPoint Half-power point (in Hz) of a special internal low-pass filter. [Default Value: 10]
- (instancetype)initWithAudioSource:(AKParameter *)audioSource
                     halfPowerPoint:(AKConstant *)halfPowerPoint;

/// Instantiates the tracked amplitude with default values
/// @param audioSource Input audio signal to track.
- (instancetype)initWithAudioSource:(AKParameter *)audioSource;

/// Instantiates the tracked amplitude with default values
/// @param audioSource Input audio signal to track.
+ (instancetype)controlWithAudioSource:(AKParameter *)audioSource;

/// Half-power point (in Hz) of a special internal low-pass filter. [Default Value: 10]
@property AKConstant *halfPowerPoint;

/// Set an optional half power point
/// @param halfPowerPoint Half-power point (in Hz) of a special internal low-pass filter. [Default Value: 10]
- (void)setOptionalHalfPowerPoint:(AKConstant *)halfPowerPoint;



@end
