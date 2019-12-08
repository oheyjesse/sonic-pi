# Dub Tabla
# github.com/@oheydrew 

set :bpm, 80

define :fplay do |freq, args|
  play hz_to_midi(freq), args
end

##| with_fx :reverb, room: 1 do
##|   with_fx :echo, phase: 0.5 do
##|     live_audio :whee, amp: 4
##|   end
##| end

live_loop :arp, sync: :beat do
  use_bpm get[:bpm]
  use_synth :pluck
  
  with_fx :reverb, room: 1 do
    with_fx :echo, mix: 0.4, phase: 0.5 do
      play scale(:C4, :minor_pentatonic).shuffle.choose
      sleep 2
      play scale(:C4, :minor_pentatonic).shuffle.choose
      sleep 2
      play scale(:C4, :minor_pentatonic).shuffle.choose
      sleep 2
      play_pattern_timed scale([:C3, :C4, :C5].choose, :minor_pentatonic), 0.075,
        sustain: 1,
        release: 1.5
    end
  end
  
  sleep 1.55
end

live_loop :beat do
  use_bpm get[:bpm]
  
  sleep 2
end

live_loop :tabla, sync: :beat do
  use_bpm get[:bpm]
  
  samples = [:tabla_ke1, :tabla_ghe1, :tabla_tun1, :tabla_na]
  sleep 1
  
  with_fx :reverb, mix: 0.4, room: 1 do
    sample samples.choose
    sleep 0.25
    sample samples.choose
    sleep 0.25
    sample samples.choose
    sleep 0.5
  end
end

live_loop :bass, sync: :beat do
  use_bpm get[:bpm]
  stop
  
  use_synth :sine
  play scale(:C2, :minor_pentatonic).choose, attack: 1, sustain: 3
  
  sleep 4
end

live_loop :kick, sync_bpm: :beat do
  ##| stop
  sample :bd_haus, amp: 3, hpf: 40
  
  use_synth :sine
  fplay 45,
    amp: 4,
    attack: 0.02,
    sustain: 0.10,
    release: 0.15
  
  sleep 1
end

note = scale(:c1, :minor_pentatonic).shuffle
live_loop :rolling_bass, sync_bpm: :beat do
  ##| stop
  cutoff = (40..86).to_a.ring
  
  4.times do
    if beat % 1 == 0
      sleep 0.25
    end
    
    with_fx :lpf, cutoff: cutoff[tick/3] do
      use_synth :saw
      play note[tick/24],
        amp: 4,
        decay: 0.025,
        release: 0.50
    end
    
    sleep 0.25
  end
  
  sleep 0
end
