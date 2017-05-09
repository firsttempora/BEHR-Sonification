[sweep, fs] = audioread('/user/k/kermit/Desktop/ir_bancroftway/RAW SWEEPS calibrated conversion to B-format/BAM 6 - Gallery 3-4 ramp_2.wav');
sweep = sweep(1:1276800);

figure;
ftgram(chrp, fs, 'music');
print -dpng '/user/k/kermit/web/presentations/ir_noise/img/chirp';
wavwrite(chrp, fs, '/user/k/kermit/web/presentations/ir_noise/audio/chirp');


figure;
ftgram(sweep, fs, 'music');
print -dpng '/user/k/kermit/web/presentations/ir_noise/img/chirp_resp';
wavwrite(sweep, fs, '/user/k/kermit/web/presentations/ir_noise/audio/chirp_resp');

figure;
subplot(3,1,1);
specgram(sweep, 2048, fs, hann(2048), 1024);
subplot(3,1,2);
noise = [zeros(fs,1); randn(length(sweep)-3*fs,1); zeros(fs*2,1)];
specgram(noise, 2048, fs, hann(2048), 1024);
subplot(3,1,3);
specgram(c2ir(chrp,noise,fs), 2048, fs, hann(2048), 1024);
print -dpng '/user/k/kermit/web/presentations/ir_noise/img/noise_figure';
wavwrite(noise, fs, '/user/k/kermit/web/presentations/ir_noise/audio/noise');
wavwrite(c2ir(chrp,noise,fs), fs, '/user/k/kermit/web/presentations/ir_noise/audio/noise_deconv');


figure;
rawresp = c2ir(chrp, sweep, fs);
rawresp = rawresp / max(abs(rawresp));
ftgram(rawresp, fs, 'music');
print -dpng '/user/k/kermit/web/presentations/ir_noise/img/ir_noisy';
wavwrite(rawresp, fs, '/user/k/kermit/web/presentations/ir_noise/audio/ir_noisy');



figure;
extended = extend_noise(sweep, fs);
extresp = c2ir(chrp, extended, fs);
extresp = extresp / max(abs(extresp));
ftgram(extresp, fs, 'music');
print -dpng '/user/k/kermit/web/presentations/ir_noise/img/ir_clean';
wavwrite(extresp, fs, '/user/k/kermit/web/presentations/ir_noise/audio/ir_clean');


