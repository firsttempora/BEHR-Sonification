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
	Out.ar(chan, Pan2.ar(envamp * SinOsc.ar(Lag.kr(freq)), pos:pan))
}).add;
);

(
SynthDef(\saw_pan2, {|freq, amp, pan=0, chan=0, trig=0, seasonCutoff=20000|
	var env, envamp;
	env = Env.asr(0.5, amp, 0.5);
	envamp = EnvGen.kr(env, trig);
	Out.ar(chan, Pan2.ar(envamp * RLPF.ar(Saw.ar(Lag.kr(freq)), seasonCutoff, 0.3), pos:pan))
}).add;
);

(
SynthDef(\square_pan2, {|freq, amp, pan=0, chan=0, trig=0, seasonCutoff=20000|
	var env, envamp;
	env = Env.asr(0.5, amp, 0.5);
	envamp = EnvGen.kr(env, trig);
	Out.ar(chan, Pan2.ar(envamp * RLPF.ar(Pulse.ar(Lag.kr(freq)), seasonCutoff, 0.3), pos:pan))
}).add;
);

(
SynthDef(\sine_pan2, {|freq, amp, pan=0, chan=0, trig=0, seasonCutoff=20000|
	var env, envamp;
	env = Env.asr(0.5, amp, 0.5);
	envamp = EnvGen.kr(env, trig);
	Out.ar(chan, Pan2.ar(envamp * RLPF.ar(SinOsc.ar(Lag.kr(freq)), seasonCutoff, 0.3), pos:pan))
}).add;
);

(
SynthDef(\noise_pan2, {|freq, amp, pan=0, chan=0, trig=0, seasonCutoff=20000|
	var env, envamp;
	env = Env.asr(0.5, amp*8, 0.5);
	envamp = EnvGen.kr(env, trig);
	Out.ar(chan, Pan2.ar(envamp * RLPF.ar(BPF.ar(WhiteNoise.ar(), Lag.kr(freq), 0.2), seasonCutoff, 0.3), pos:pan))
}).add;
);

(
SynthDef(\spectrum_pan4, {|freq, amp, panx=0, pany=0, chan=0, trig=0|
	var env, envamp;
	env = Env.asr(0.5, amp, 0.5);
	envamp = EnvGen.kr(env, trig);
	Out.ar(chan, Pan4.ar(envamp * SinOsc.ar(Lag.kr(freq)), xpos:panx, ypos:pany))
}).add;
);

(
SynthDef(\saw_pan4, {|freq, amp, panx=0, pany=0, chan=0, trig=0, seasonCutoff=20000|
	var env, envamp;
	env = Env.asr(0.5, amp, 0.5);
	envamp = EnvGen.kr(env, trig);
	Out.ar(chan, Pan4.ar(envamp * RLPF.ar(Saw.ar(Lag.kr(freq)), seasonCutoff, 0.3), xpos:panx, ypos:pany))
}).add;
);

(
SynthDef(\square_pan4, {|freq, amp, panx=0, pany=0, chan=0, trig=0, seasonCutoff=20000|
	var env, envamp;
	env = Env.asr(0.5, amp, 0.5);
	envamp = EnvGen.kr(env, trig);
	Out.ar(chan, Pan4.ar(envamp * RLPF.ar(Pulse.ar(Lag.kr(freq)), seasonCutoff, 0.3), xpos:panx, ypos:pany))
}).add;
);

(
SynthDef(\sine_pan4, {|freq, amp, panx=0, pany=0, chan=0, trig=0, seasonCutoff=20000|
	var env, envamp;
	env = Env.asr(0.5, amp, 0.5);
	envamp = EnvGen.kr(env, trig);
	Out.ar(chan, Pan4.ar(envamp * RLPF.ar(SinOsc.ar(Lag.kr(freq)), seasonCutoff, 0.3), xpos:panx, ypos:pany))
}).add;
);

(
SynthDef(\noise_pan4, {|freq, amp, panx=0, pany=0, chan=0, trig=0, seasonCutoff=20000|
	var env, envamp;
	env = Env.asr(0.5, amp*8, 0.5);
	envamp = EnvGen.kr(env, trig);
	Out.ar(chan, Pan4.ar(envamp * RLPF.ar(BPF.ar(WhiteNoise.ar(), Lag.kr(freq), 0.2), seasonCutoff, 0.3), xpos:panx, ypos:pany))
}).add;
);

"all synth defs loaded".postln;
);