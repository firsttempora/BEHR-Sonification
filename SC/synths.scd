(
(
SynthDef(\spectrum, {|freq, amp, chan=0|
    Out.ar(chan, amp * SinOsc.ar(freq))
}).add;
);

(
SynthDef(\spectrum_pan2, {|freq, amp, pan=0, chan=0, trig=0|
	var env, envamp;
	env = Env.asr(0.5, amp, 0.5);
	envamp = EnvGen.kr(env, trig);
	Out.ar(chan, Pan2.ar(envamp * SinOsc.ar(Lag.kr(freq), 0.1), pos:pan))
}).add;
);

"all synth defs loaded".postln;
);