live_loop :sample_1 do
  # setup for midi device goes here
  midi_device_address = "/midi/midi_touchbar_user/1/10/note_on"
  midi_start_note = 48
  
  # sampler code
  use_real_time
  note, velocity = sync(midi_device_address)
  puts "vel: #{velocity}"
  
  if velocity > 0
    samp = sample :loop_amen, beat_stretch: 2
  end
  
  if velocity == 0
    sleep 0
  end
  
  sleep 2
end


live_loop :midi_drum do
  # setup for midi device goes here
  midi_device_address = "/midi/midi_touchbar_user/1/9/note_on"
  midi_start_note = 48
  
  # drum machine code
  use_real_time
  original_note, velocity = sync(midi_device_address)
  
  slice_index = original_note - (midi_start_note - 1)
  slice_size = 0.125
  
  start_time = slice_index * slice_size
  finish_time = start_time + slice_size
  sample :loop_amen,
    start: start_time,
    finish: finish_time
  
  sleep 0.0625
end

live_loop :midi_piano do
  use_real_time
  
  note, velocity = sync("/midi/midi_touchbar_user/1/1/note_on")
  
  if velocity != 0
    synth :piano,
      note: note,
      amp: velocity / 127.0
  end
end
