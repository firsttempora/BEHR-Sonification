(
(
SynthDef(\spectrum, {|freq, amp|
    Out.ar(0, amp * SinOsc.ar(freq))
}).add;
);

"all synth defs loaded".postln;
);