set :bpm, 120

live_loop :main do
  use_bpm get[:bpm]
  puts "Beat #{beat}"
  sleep 1
end

live_loop :kick, sync_bpm: :main do
  puts "Kick"
  use_bpm get[:bpm]
  
  sample :bd_haus, amp: 3
  
  sleep 1
end

live_loop :bass_wobble, sync_bpm: :main do
  puts "Bass Wobble"
  use_bpm get[:bpm]
  
  amp = 0.5
  
  if beat % 1 == 0
    amp = 0.1
  end
  
  
  
  notes = scale(:C, :egyptian).shuffle.tick
  use_synth :chiplead
  play notes, amp: amp
  
  sleep 0.25
  
end