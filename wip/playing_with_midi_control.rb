# Coolout
# github.com/@oheydrew

use_bpm 92

live_loop :main do
  puts "Beat #{beat}"
  sleep 1
end

live_loop :sync_lpf do
  use_real_time
  
  # Grab the velocity, to use as the cutoff
  _, vel = sync("/midi/midi_touchbar_user/1/10/control_change")
  
  control get(:kick_fx), cutoff: vel
end


live_loop :kick, sync_bpm: :main do
  _, tog_v = get "/midi/midi_touchbar_user/1/10/note_on"
  toggle = tog_v / 127 # Get a 1 or 0 value from the Velocity (on is 127, off is 0)
  
  _, lpf_v = get "/midi/midi_touchbar_user/1/10/control_change"
  
  puts "Kick"
  puts "MIDI Toggle: #{toggle}"
  puts "MIDI LPF: #{lpf_v}"
  
  with_fx :rlpf, cutoff: lpf_v, res: 0.9 do |lpf|
    set(:kick_fx, lpf)
    sample :bd_haus,
      # toggle is 1 or 0, so 0 will turn the output to 0
      amp: 2 * toggle,
      hpf: 40
  end
  
  use_synth :sine
  fplay 45,
    amp: 4,
    attack: 0.01,
    sustain: 0.10,
    release: 0.15
  
  sleep 1
end

bass_key = [:A1, :C2, :D1].ring
live_loop :rolling_bass, sync_bpm: :kick do
  stop
  
  puts "Rolling Bass"
  note = bass_key.tick
  
  48.times do
    if beat % 1 == 0
      sleep 0.25
    end
    
    # Grab the velocity from the midi-touchbar device
    _, bass_alt_toggle = get "/midi/midi_touchbar_user/1/11/note_on"
    
    puts "Basstog: #{bass_alt_toggle}"
    
    with_fx :lpf, cutoff: 60 do
      use_synth :saw
      play note,
        amp: 4,
        decay: 0.025,
        release: 0.15
    end
    
    if bass_alt_toggle > 0
      with_fx :echo, mix: 0.3, phase: 0.75, decay: 1.5 do
        use_synth :pluck
        play note + 36,
          amp: 0.6,
          decay: 0.05,
          release: 0.15
        
        play note + 19,
          amp: 0.4,
          decay: 0.05,
          release: 0.15
      end
    end
    
    sleep 0.25
  end
  
  sleep 0
end

##| live_loop :synth do
##|   # Unfinished...
##|   s = synth :sine, note: :C3, sustain: 4, release: 0, attack: 0

##|   live_loop :control do
##|     pitch_midi = sync("/midi/midi_touchbar_user/1/11/pitch_bend").first

##|     decimal = pitch_midi / 16384.0
##|     pitch_mod = 24 * decimal - 12

##|     control s, pitch: pitch_mod
##|   end

##|   sleep 4
##| end



##| define :fplay do |freq, args|
##|   play hz_to_midi(freq), args
##| end

##| define :maybe do |number, chance|
##|   if one_in(chance)
##|     number
##|   else
##|     0
##|   end
##| end



##| Unused - I was messing with log to try make fades smoother,
##| but then discovered it'd already been done by Sam :D
##| define :midi_logfader1 do |path|
##|   _, velocity = get path
##|   vel_decimal = velocity / 127.0

##|   log_mod = 1 + Math.log10(vel_decimal)
##|   puts "vel_decimal: #{vel_decimal}, log_mod: #{log_mod}"

##|   return 0 if log_mod < 0
##|   log_mod
##| end

##| define :midi_logfader do |path|
##|   _, velocity = get path

##|   log_mod = 1 + Math.log10(velocity / 127.0)
##|   log_mod = 0 if log_mod < 0
##|   recalc_vel = velocity * log_mod

##|   puts "velocity #{velocity},
##|         log_mod: #{log_mod},
##|         recalc_vel: #{recalc_vel}"

##|   return 0 if recalc_vel < 0
##|   recalc_vel
##| end
