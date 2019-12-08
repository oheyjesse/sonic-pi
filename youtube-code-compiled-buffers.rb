# Drum'N'Bass

set :bpm, 180

define :fplay do |freq, args|
  play hz_to_midi(freq), args
end

live_loop :main do
  use_bpm get[:bpm]
  sleep 1
end


live_loop :hat, sync: :main do
  use_bpm get[:bpm]
  
  4.times do
    sample :drum_cymbal_closed,
      rate: 1,
      pan: -0.3,
      amp: 0.7
    
    sleep 0.50
  end
  
  sleep 0
end

live_loop :alt_hat, sync: :hat do
  use_bpm get[:bpm]
  
  sleep 1.75
  sample :drum_cymbal_closed, rate: 1, pan: 0.3, amp: 0.7
  sleep 0.50
  sample :drum_cymbal_closed, rate: 1, pan: 0.3, amp: 0.7
  
  sleep 1.75
end

live_loop :kick, sync_bpm: :main do
  sample :bd_tek, amp: 2, release: 0.05, hpf: 40
  
  sleep 2.5
  sample :bd_tek, amp: 2, release: 0.05, hpf: 40
  
  sleep 1.5
end

live_loop :snare, sync_bpm: :main do
  sleep 1
  
  with_fx :reverb, room: 0.5, mix: 0.4, damp: 0.8 do
    sample :sn_dolf, amp: 1.5
  end
  
  sleep 1
end

live_loop :drone_bass, sync_bpm: :main do
  ##| stop
  
  use_bpm get[:bpm]
  notes = ring(:Ds2, :C2).tick
  length = 16
  amp_offset = 0
  
  with_fx :rlpf, cutoff: 100, res: 0.5 do
    use_synth :subpulse
    play notes,
      amp: 5 + amp_offset,
      pitch: 0,
      attack: 0,
      release: 0.1,
      sustain: length,
      env_curve: 3,
      pulse_width: 0.4,
      cutoff: 35
    
    use_synth :saw
    play notes,
      pitch: 0,
      amp: 0.2 + amp_offset,
      attack: 0,
      release: 0.1,
      sustain: length,
      env_curve: 6,
      cutoff: 75
    
    with_fx :flanger,
      wave: 3,
      phase: length * 2,
      depth: 8,
      decay: length * 1.5,
      mix: 0.8,
      invert_wave: 1,
    stereo_invert_wave: 1 do
      
      use_synth :tech_saws
      play notes,
        amp: 0.3 + amp_offset,
        pan: 0.7,
        attack: 0,
        release: 0.1,
        env_curve: 4,
        pulse_width: 0.1,
        sustain: length,
        cutoff: 125
      
      use_synth :supersaw
      play notes,
        amp: 0.25 + amp_offset,
        pan: -0.7,
        pitch: 0,
        attack: 0,
        release: 0,
        env_curve: 6,
        pulse_width: 0.5,
        sustain: length,
        cutoff: 120
    end
  end
  
  sleep length
end
