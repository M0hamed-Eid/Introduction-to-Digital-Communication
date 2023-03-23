clear, clc ,close all;

% reconstruction from oversampling
t1=0:0.001:1;% time signal
y=2*cos(2*pi*5*t1);
[B,A] = butter(3,1000/100000,'low' ); % butter fly filter
zero_added_signal=zeros(1,length(y)*10);
for i=1:length(y)
          zero_added_signal(i*10)=y(i);
end
zero_added_signal(1:9)=[];
% Adding zeros enhances the signal display and don't change the
% spectrum,it changes sampling freq. only
t2=linspace(0,1,length(zero_added_signal));
filtered_signal = filter(B,A,zero_added_signal);
figure(1),subplot(3,1,1);
plot(t1, y, 'b', t2, filtered_signal, 'r--');
title('Reconstruction from over sampling');
legend('Original signal', 'Reconstructed signal');

s=fft(filtered_signal);
s=fftshift(s);
fs=10000; 
freq=linspace(-fs/2,fs/2,length(s));
figure(2),subplot(311)
plot(freq,abs(s))
xlabel('freq')
ylabel('magnitude')
title('over sampled signals')

% construction from minimum sampling
t1=0:1/(2*5):1; % replace ?? with the suitable number
y=2*cos(2*pi*5*t1);
[B,A] = butter(10,0.1,'low' );
zero_added_signal=zeros(1,length(y)*10);
for i=1:length(y)
          zero_added_signal(i*10)=y(i);
end
zero_added_signal(1:9)=[];
t2=linspace(0,1,length(zero_added_signal));
filtered_signal = filter(B,A,zero_added_signal);
figure(1),subplot(3,1,2);
plot(t1, y, 'b', t2, filtered_signal, 'r--');
title('Reconstruction from over sampling');
legend('Original signal', 'Reconstructed signal');

s=fft(filtered_signal);
s=fftshift(s);
fs=100; % why 100?? Write your comments in the m file
freq=linspace(-fs/2,fs/2,length(s));
figure(2),subplot(312)
plot(freq,abs(s))
xlabel('freq')
ylabel('magnitude')
title('minimum sampled signals')

% construction from undersampling sampling
t1=0:0.2:1;
y=2*cos(2*pi*5*t1);
[B,A] = butter(10,0.2,'low' );
zero_added_signal=zeros(1,length(y)*10);
for i=1:length(y)
          zero_added_signal(i*10)=y(i);
end
zero_added_signal(1:9)=[];
t2=linspace(0,1,length(zero_added_signal));
filtered_signal = filter(B,A,zero_added_signal);
figure(1),subplot(3,1,3);
plot(t1, y, 'b', t2, filtered_signal, 'r--');
title('Reconstruction from under sampling');
legend('Original signal', 'Reconstructed signal');

s=fft(filtered_signal);
s=fftshift(s);
fs=50; 
freq=linspace(-fs/2,fs/2,length(s));
figure(2),subplot(313)
plot(freq,abs(s))
xlabel('freq')
ylabel('magnitude')
title('under sampled signals')
