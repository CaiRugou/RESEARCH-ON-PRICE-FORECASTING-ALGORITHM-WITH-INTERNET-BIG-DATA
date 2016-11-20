% p=[1183 1303 1278;1303 1278 1284;1278 1284 1187 ;...
%     1284 1187 1154;1187 1154 1267;1154 1267 1241;...
%     1267 1241 1302;1241 1302 1195;1302 1195 1256]'*0.001;
% t=[ 1284 1187 1154 1267 1241 1302 1195 1256 1348]*0.001;
% net=newff(minmax(p),[15,1],{'tansig','purelin'},'trainlm');
% net.trainParam.goal=0.001;
% net.trainParam.show=50;
% % net.trainParam.lr = 0.1
% net.trainParam.mc=0.9
% net.trainParam.min_grad=1e-10;
% net.trainParam.epochs=10000;
% [net,tr]=train(net,p,t);
% t1=sim(net,[1302 1195 1256]'*0.001);
% t2013=t1*1000%2013
% t2=sim(net,p)
% plot(2004:2012,t2,'+',2004:2012,t)

% X0=[101.43 99.98 101.13 102.23 103.65 104.75 109.38 107.6 105.5 107.58 106.5]
% x=[2000	2000	2050	2050	2050	2050	2000	2050	2050	2000	2000	2000	2000	2000	2050	2050	2000	2000	2000	2000	2050	2050	2000	2000	2050	2050	2050	2050	2000	2000	2050	2000	2050	2050	2000	2050	2025	2000	2000	2000	2050	2000	2000	2050	2000	2050	2000	2050	2000	2050	2050	2050	2050	2050	2050	2050	2050	2000	2050	2050	2000]
x1=[2000	2000	2050	2050	2050	2050	2000	2050	2050	2000	2000	2000	2000	2000	2050	2050	2000	2000	2000	2000	2050	2050	2000	2000	2050	2050	2050	2050	2000	2000	2050	2000	2050	2050	2000	2050	2025	2000	2000	2000	2050	2000	2000	2050	2000	2050	2000	2050	2000	2050	2050	2050	2050	2050	2050	2050	2050	2000	2050	2050	2000]
x2=[3600	3600	3600	3600	3600	3600	3600	3600	3600	3600	3600	3600	3600	3600	3600	3600	3600	3600	3600	3600	3600	3600	3600	3600	3600	3600	3600	3600	3600	3600	3600	3350	3420	3420	3420	3420	3420	3420	3420	3420	3420	3420	3420	3420	3420	3320	3320	3320	3320	3320	3320	3320	3320	3320	3320	3320	3320	3320	3320	3320	3320]
x3=[2499	2499	2499	2499	2499	2998	2499	2499	2999	2499	2499	2499	2499	2499	2499	2499	2499	2499	2999	2499	2499	3298	2999	2499	2499	2499	2999	2499	2999	2499	2999	2998	2499	2499	2999	2499	2749	2999	2999	2499	2499	2499	2499	2499	2999	2499	2499	2499	2499	1999	1999	1999	1999	2149	2299	1999	2499	1999	2499	2299	2299]
x4=[3588	3588	3588	3588	3588	3588	3588	3588	3588	3588	3588	3588	3588	3588	3588	3588	3588	3588	3588	3588	3588	3588	3588	3588	3588	3588	3588	3588	3588	3588	3588	3588	2888	3588	2888	3588	3588	3588	3588	2888	2888	3800	2970	2970	2970	2970	3800	2970	2970	2970	2970	2970	2970	2970	3385	3800	2970	3800	2970	3800	2970]

[T,minp,maxp]=premnmx(x1)
Q=length(T)
P=zeros(7,Q);
P(1,2:Q)=T(1:Q-1);
P(2,3:Q)=T(1:Q-2);
P(3,4:Q)=T(1:Q-3);
P(4,5:Q)=T(1:Q-4);
P(5,6:Q)=T(1:Q-5);
P(6,7:Q)=T(1:Q-6);
P(7,8:Q)=T(1:Q-7);
rand('state',0);
% 
% net=newff(minmax(P),[17,1],{'tansig','purelin'},'trainlm');
net=newff(minmax(P),[17,1],{'tansig','purelin'});
net.trainParam.goal=0.001;
net.trainParam.show=50;
net.trainParam.lr = 0.01
net.trainParam.mc=0.9
net.trainParam.min_grad=1e-10;
net.trainParam.epochs=10000;
[net,tr]=train(net,P,T);
Y=sim(net,P)

e=T-Y
R=norm(e)
X1=postmnmx(Y,minp,maxp)
m=1:Q
subplot(221)
plot(m,x1,'-+',m,X1,'-o')
ylabel('价格(元)')
xlabel('时间(天)')
legend('真实值','预测值')
title('HTC')
hold on



[T,minp,maxp]=premnmx(x2)
Q=length(T)
P=zeros(7,Q);
P(1,2:Q)=T(1:Q-1);
P(2,3:Q)=T(1:Q-2);
P(3,4:Q)=T(1:Q-3);
P(4,5:Q)=T(1:Q-4);
P(5,6:Q)=T(1:Q-5);
P(6,7:Q)=T(1:Q-6);
P(7,8:Q)=T(1:Q-7);
rand('state',0);
% 
% net=newff(minmax(P),[17,1],{'tansig','purelin'},'trainlm');
net=newff(minmax(P),[17,1],{'tansig','purelin'});
net.trainParam.goal=0.001;
net.trainParam.show=50;
net.trainParam.lr = 0.01
net.trainParam.mc=0.9
net.trainParam.min_grad=1e-10;
net.trainParam.epochs=10000;
[net,tr]=train(net,P,T);
Y=sim(net,P)

e=T-Y
R=norm(e)
X2=postmnmx(Y,minp,maxp)
m=1:Q
subplot(222)
plot(m,x2,'-+',m,X2,'-o')
ylabel('价格(元)')
xlabel('时间(天)')
legend('真实值','预测值')
title('Iphone 5S')
hold on

[T,minp,maxp]=premnmx(x3)
Q=length(T)
P=zeros(7,Q);
P(1,2:Q)=T(1:Q-1);
P(2,3:Q)=T(1:Q-2);
P(3,4:Q)=T(1:Q-3);
P(4,5:Q)=T(1:Q-4);
P(5,6:Q)=T(1:Q-5);
P(6,7:Q)=T(1:Q-6);
P(7,8:Q)=T(1:Q-7);
rand('state',0);
% 
% net=newff(minmax(P),[17,1],{'tansig','purelin'},'trainlm');
net=newff(minmax(P),[17,1],{'tansig','purelin'});
net.trainParam.goal=0.001;
net.trainParam.show=50;
net.trainParam.lr = 0.01
net.trainParam.mc=0.9
net.trainParam.min_grad=1e-10;
net.trainParam.epochs=10000;
[net,tr]=train(net,P,T);
Y=sim(net,P)

e=T-Y
R=norm(e)
X3=postmnmx(Y,minp,maxp)
m=1:Q
subplot(223)
plot(m,x3,'-+',m,X3,'-o')
ylabel('价格(元)')
xlabel('时间(天)')
legend('真实值','预测值')
title('OPPO')
hold on


[T,minp,maxp]=premnmx(x4)
Q=length(T)
P=zeros(7,Q);
P(1,2:Q)=T(1:Q-1);
P(2,3:Q)=T(1:Q-2);
P(3,4:Q)=T(1:Q-3);
P(4,5:Q)=T(1:Q-4);
P(5,6:Q)=T(1:Q-5);
P(6,7:Q)=T(1:Q-6);
P(7,8:Q)=T(1:Q-7);
rand('state',0);
% 
% net=newff(minmax(P),[17,1],{'tansig','purelin'},'trainlm');
net=newff(minmax(P),[17,1],{'tansig','purelin'});
net.trainParam.goal=0.001;
net.trainParam.show=50;
net.trainParam.lr = 0.01
net.trainParam.mc=0.9
net.trainParam.min_grad=1e-10;
net.trainParam.epochs=10000;
[net,tr]=train(net,P,T);
Y=sim(net,P)

e=T-Y
R=norm(e)
X4=postmnmx(Y,minp,maxp)
m=1:Q
subplot(224)
plot(m,x4,'-+',m,X4,'-o')
ylabel('价格(元)')
xlabel('时间(天)')
legend('真实值','预测值')
title('华为 P8')
hold on



