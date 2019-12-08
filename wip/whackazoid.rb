live_loop :kick do
  sample :bd_klub, amp: 2
  sleep 2
  sample :bd_klub, amp: 2
  sleep 2
end

##| live_loop :arp, sync: :kick do
##|   use_synth :pulse

##|   play chord(:E3, :minor), attack: 0.25, release: 2
##|   sleep 0.5
##|   play chord(:C3, :major), amp: 0.5, pan: 1, release: 2
##|   sleep 0.5
##|   play chord(:F3, :major7), amp: 2
##|   sleep 0.5
##|   play chord(:C3, :major), pan: -1
##|   sleep 0.5
##|   sleep 2
##| end

live_loop :whackazoid, sync: :kick do
  with_fx :reverb, mix: 0.7, mix_slide: 4 do |fx|
    sample :loop_garzul, amp: 1, pitch: -12
    control fx, mix: 0.8
  end
  
  sleep 8
end

##| live_loop :flibble do
##|   sample :bass_trance_c, rate: 1
##|   sample :bd_haus, rate: 1
##|   sleep 0.5
##|   sample :bd_haus, rate: 1
##|   sample :sn_dolf, rate: 1
##|   sleep 0.5
##| end

##| live_loop :guit do
##|   with_fx :echo, mix: 0.3, phase: 0.25 do
##|     sample :guit_em9, rate: 1
##|   end
##|   #  sample :guit_em9, rate: -0.5
##|   sleep 8
##| end

