# Welcome to Sonic Pi
use_bpm 135

letra = "/Users/ivise/Desktop/sonidos/letra2.mp3"


with_fx :reverb, room: 0.9  do
  sample letra, amp: 0.8
end
