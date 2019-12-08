# Beep Boop Klub
# github.com/@oheydrew 

live_loop :beep_boop do
  ##| play 70, amp: rand(1), pan: [-1, 1].choose
  use_synth :chiplead
  play scale(:C4, :minor_pentatonic).choose, amp: 0.25
  
  sleep 0.5
end

live_loop :kick do
  sample :bd_haus
  
  sleep 0.5
end

live_loop :hats do
  with_fx :echo, phase: 0.125, mix: 0.5 do
    sample :elec_blip2, lpf: 80
  end
  
  sleep 0.25
end
