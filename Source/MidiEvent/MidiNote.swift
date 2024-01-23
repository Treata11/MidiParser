//
//  MidiNote.swift
//  MidiParser
//
//  Created by Yuma Matsune on 2017/11/10.
//  Copyright © 2017年 matsune. All rights reserved.
//

import AudioToolbox
import Foundation
    
public struct MidiNote {
    
    public let regularTempoTimeStamp: MusicTimeStamp
    public let regularDuration: Float32
    
    public let timeStamp: MidiTime
    public let duration: MidiTime
    public let note: UInt8
    public let velocity: UInt8
    public let channel: UInt8
    public let releaseVelocity: UInt8

    public init(regularTimeStamp: MusicTimeStamp, regularDuration: Float32, note: UInt8, velocity: UInt8, channel: UInt8, releaseVelocity: UInt8 = 0, beatsPerMinute: BeatsPerMinute = BeatsPerMinute.regular, ticksPerBeat: TicksPerBeat = TicksPerBeat.regular) {
        let timeStampInTicks = Milliseconds(regularTimeStamp).toTicks(andTicksPerBeat: ticksPerBeat)
        let durationInTicks = Milliseconds(Double(regularDuration)).toTicks(andTicksPerBeat: ticksPerBeat)
        
        self.regularTempoTimeStamp = regularTimeStamp
        self.regularDuration = regularDuration
        
        self.timeStamp = MidiTime(inSeconds: timeStampInTicks.toMs(forBeatsPerMinute: beatsPerMinute, andTicksPerBeat: ticksPerBeat).seconds, inTicks: timeStampInTicks)
        self.duration = MidiTime(inSeconds: durationInTicks.toMs(forBeatsPerMinute: beatsPerMinute, andTicksPerBeat: ticksPerBeat).seconds, inTicks: durationInTicks)
        self.note = note
        self.velocity = velocity
        self.channel = channel
        self.releaseVelocity = releaseVelocity
    }
    
}

extension MidiNote {

    func convert() -> MIDINoteMessage {
        return MIDINoteMessage(channel: channel, note: note, velocity: velocity, releaseVelocity: releaseVelocity, duration: Float32(duration.inSeconds))
    }

}

extension MidiNote: Identifiable {
    public var id: String {
        // Assuming a unique identifier based on the note's properties
//        return "\(regularTempoTimeStamp)-\(note)-\(channel)"
        return "\(regularTempoTimeStamp)-\(note)"
    }
}

extension MidiNote: Equatable {}
/*
extension MidiNote: Equatable {
    public static func == (lhs: MidiNote, rhs: MidiNote) -> Bool {
        return lhs.regularTempoTimeStamp == rhs.regularTempoTimeStamp &&
               lhs.regularDuration == rhs.regularDuration &&
//               lhs.timeStamp == rhs.timeStamp &&
//               lhs.duration == rhs.duration &&
               lhs.note == rhs.note &&
               lhs.velocity == rhs.velocity &&
               lhs.channel == rhs.channel &&
               lhs.releaseVelocity == rhs.releaseVelocity
    }
}
*/
 
extension MidiNote: Hashable {
    public func hash(into hasher: inout Hasher) {
        hasher.combine(regularTempoTimeStamp)
        hasher.combine(regularDuration)
//        hasher.combine(timeStamp)
//        hasher.combine(duration)
        hasher.combine(note)
        hasher.combine(velocity)
        hasher.combine(channel)
        hasher.combine(releaseVelocity)
    }
}
