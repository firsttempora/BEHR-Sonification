(
(
SynthDef(\spectrum, {|freq, amp, out|
    Out.ar(out, amp * SinOsc.ar(freq))
}).add;
);

"all synth defs loaded".postln;
);