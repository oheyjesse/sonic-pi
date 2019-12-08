# Welcome to Sonic Pi v3.1
set :bpm, 80

live_loop :arp, sync: :beat do
  use_bpm get[:bpm]
  use_synth :pluck
  
  with_fx :reverb, room: 1 do
    with_fx :echo, mix: 0.2, phase: 0.5 do
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
  
  play :E2
  
  sleep 4
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
  use_synth :sine
  play scale(:C2, :minor_pentatonic).choose, sustain: 4
  
  sleep 4
end
