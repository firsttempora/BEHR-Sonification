(
(
SynthDef(\spectrum, {|freq, amp, chan=0|
    Out.ar(chan, amp * SinOsc.ar(freq))
}).add;
);

(
SynthDef(\spectrum_pan2, {|freq, amp, pan=0, chan=0|
    Out.ar(chan, Pan2.ar(amp * SinOsc.ar(freq), pos:pan))
}).add;
);

"all synth defs loaded".postln;
);