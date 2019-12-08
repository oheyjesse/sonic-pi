set :bpm, 90

live_loop :main do
  use_bpm get[:bpm]
  sleep 1
end

live_loop :kick, sync_bpm: :main do
  use_bpm get[:bpm]
  
  sample :bd_haus, amp: 3
  
  sleep 1
end

live_loop :drone_bass, sync_bpm: :main do
  ##| stop
  
  use_bpm get[:bpm]
  notes = ring(:Eb3, :C3).tick
  length = 8
  amp_offset = -0.2
  
  with_fx :rlpf, cutoff: 100, res: 0.5 do
    
    use_synth :subpulse
    play notes,
      amp: 4 + amp_offset,
      pitch: -12,
      attack: 0,
      release: 0.1,
      sustain: length,
      env_curve: 3,
      pulse_width: 0.4,
      cutoff: 50
    
    use_synth :saw
    play notes,
      pitch: 0,
      amp: 0.5 + amp_offset,
      attack: 0,
      release: 0.1,
      sustain: length,
      env_curve: 6,
      cutoff: 100
    
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
        amp: 0.5 + amp_offset,
        attack: 0,
        release: 0.1,
        env_curve: 4,
        pulse_width: 0.1,
        sustain: length,
        cutoff: 105
      
      use_synth :supersaw
      play notes,
        amp: 0.2 + amp_offset,
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

live_loop :squelch, sync_bpm: :main do
  ##| stop
  
  use_bpm get[:bpm]
  notes = (ring :c1, :c2, :c3).tick
  amp_offset = 0
  
  with_fx :reverb, room: 1 do
    with_fx :echo, decay: 0.3, mix: 0.3 do
      use_synth :tb303
      play notes,
        amp: 0.15 + amp_offset,
        pan: rrand(-1, 1),
        release: 0.125,
        cutoff: 90,
        res: 0.8,
        wave: 0
      sleep 0.25
    end
  end
end

live_loop :random_melody, sync_bpm: :main do
  ##| stop
  
  use_bpm get[:bpm]
  notes = (scale :C4, :minor_pentatonic).shuffle.tick
  
  with_fx :echo, mix: 0.3, decay: 4, phase: 0.25 do
    with_fx :bitcrusher, mix: 0, sample_rate: 7500 do
      use_synth :pluck
      play notes,
        amp: 2,
        noise_amp: 0.8,
        coef: 0.2,
        sustain: 2,
        sustain_level: 1
    end
  end
  
  sleep ring(0.5, 0.5, 0.5, 1).tick
end

