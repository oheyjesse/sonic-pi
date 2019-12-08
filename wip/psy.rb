use_bpm 100

define :fplay do |freq, args|
  play hz_to_midi(freq), args
end

live_loop :main do
  puts "Beat #{beat}"
  sleep 1
end

live_loop :kick, sync_bpm: :main do
  ##| stop
  
  puts "Kick"
  
  sample :bd_haus, amp: 3, hpf: 40
  
  use_synth :sine
  fplay 45,
    amp: 4,
    attack: 0.02,
    sustain: 0.10,
    release: 0.15
  
  sleep 1
end

live_loop :rolling_bass, sync_bpm: :kick do
  ##| stop
  
  puts "Rolling Bass"
  
  notes = [:A1, :A1, :A1, :A1].ring
  note = notes.tick
  
  8.times do
    if beat % 1 == 0
      amp = 0
    else
      amp = 3
    end
    
    with_fx :lpf, cutoff: 60 do
      use_synth :saw
      play note,
        amp: amp,
        decay: 0.05,
        release: 0.15
    end
    
    sleep 0.25
  end
  
  sleep 0
end

live_loop :fun_line, sync_bpm: :kick do
  ##| stop
  
  puts "FunLine"
  amp = 0.25
  
  8.times do
    with_fx :reverb, mix: 0.7 do
      with_fx :echo, mix: 0.4, phase: 0.50, decay: 0.75 do
        notes = (ring 69, 67, 64, 57)
        
        use_synth :chipbass
        play notes.concat((notes.shuffle)).tick,
          pan: [-0.6, -0.4, 0.4, 0.6].sample,
          amp: amp,
          attack: 0,
          sustain: 0.15,
          release: 0.15
      end
    end
    
    sleep 0.25
  end
  
  sleep 0
end

live_loop :warble, sync_bpm: :kick do
  ##| stop
  
  puts "Warble"
  
  pan = 1
  
  if tick.even?
    pan = 1
  else
    pan = -1
  end
  
  warb = with_fx :ring_mod, freq: 100 do
    with_fx :gverb,
      room: 10,
      release: 6,
      spread: 1,
      pre_damp: 1,
      damp: 1,
    mix: 0.8 do
      sample :bass_voxy_c,
        amp: 1,
        pitch_stretch: 17,
        pitch: -3,
        attack: 1,
        release: 1,
        pan: pan,
        pan_slide: 8,
        cutoff: 100
    end
  end
  
  control warb, pan: pan * -1
  
  sleep 16
end
