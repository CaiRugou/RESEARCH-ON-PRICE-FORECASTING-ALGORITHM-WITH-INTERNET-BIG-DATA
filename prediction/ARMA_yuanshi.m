X=[ 2000	2000	2050	2050	2050	2050	2000	2050	2050	2000	2000	2000	2000	2000	2050	2050	2000	2000	2000	2000	2050	2050	2000	2000	2050	2050	2050	2050	2000	2000	2050	2000	2050	2050	2000	2050	2025	2000	2000	2000	2050	2000	2000	2050	2000	2050	2000	2050	2000	2050	2050	2050	2050	2050	2050	2050	2050	2000	2050	2050	2000
    ]';
% X=[14.06	14.65	15.45	13.91	13.33	12	11.43	11.14	11.4	10.57	10.65	11.72	12.89	12.58	13.05	13.48	12.13	10.93	9.84	9.98	9.45	9.76	10.74	10.98	10.47	10.14	10.83	10.88	11.25	11.09	11.25	11.4	11.33	10.2	9.98	9.68	10.65	11.4	11.3	10.6	10.6	10.49	10.28	10.26	9.95	10.26	10.12	10.05	10.26	10.57	11.06	10.8	10.85	10.9	11.13	11.09	11.17	11.44	11.61	11.53	11.7	11.7	11.9	12.13	12.24	12.09	12.14	12.03	12.13	11.88	11.96	11.25	11.05	11.32	11.91	11.91	11.81	11.9	12	12.32	12.47	12.39	11.98	11.51	11.51	11.57	11.62	11.57	11.52	11.57	11.33	11.3	11.11	11.1	11.33	11.1	11.1	11.19	11.06	11.4
% ]';
XX=[3600	3600	3600	3600	3600	3600	3600	3600	3600	3600	3600	3600	3600	3600	3600	3600	3600	3600	3600	3600	3600	3600	3600	3600	3600	3600	3600	3600	3600	3600	3600	3350	3420	3420	3420	3420	3420	3420	3420	3420	3420	3420	3420	3420	3420	3320	3320	3320	3320	3320	3320	3320	3320	3320	3320	3320	3320	3320	3320	3320	3320
    ]';
XXX=[
    2499	2499	2499	2499	2499	2998	2499	2499	2999	2499	2499	2499	2499	2499	2499	2499	2499	2499	2999	2499	2499	3298	2999	2499	2499	2499	2999	2499	2999	2499	2999	2998	2499	2499	2999	2499	2749	2999	2999	2499	2499	2499	2499	2499	2999	2499	2499	2499	2499	1999	1999	1999	1999	2149	2299	1999	2499	1999	2499	2299	2299
    ]';
XXXX=[
    3588	3588	3588	3588	3588	3588	3588	3588	3588	3588	3588	3588	3588	3588	3588	3588	3588	3588	3588	3588	3588	3588	3588	3588	3588	3588	3588	3588	3588	3588	3588	3588	2888	3588	2888	3588	3588	3588	3588	2888	2888	3800	2970	2970	2970	2970	3800	2970	2970	2970	2970	2970	2970	2970	3385	3800	2970	3800	2970	3800	2970
    ]';
% plot(1:length(X),X);

%做对数差分
Y=diff(log(X))
YY=diff(log(XX))
YYY=diff(log(XXX))
YYYY=diff(log(XXXX))
% figure(4)
% plot(1:length(Y),Y)
% 
% figure(3)
% autocorr(Y)

% figure(2)
Z=iddata(Y)
ZZ=iddata(YY)
ZZZ=iddata(YYY)
ZZZZ=iddata(YYYY)


% m = armax(Z,[13,9])
m = armax(Z,'na',13,'nc',9)
mm = armax(Z,[13,9])
mmm = armax(Z,[13,9])
mmmm = armax(Z,[13,9])

% m = arx(Z,3)

L = 15
y = [Y;zeros(L,1)];
p=iddata(y);
P=predict(m,p,L)

G=get(P)
PT = G.OutputData{1,1}(length(Y)+1:length(Y)+L,1)
D=[Y;PT]
X1 = cumsum([X(1);D])

X2 = X1(length(X)+1 : end)
for i=1:15
    if i>=10
        X2(i)=X2(i)-200
    end
end


subplot(221);

compare(m,Z,L)
title('HTC拟合')
hold on
%
L = 15
yy = [YY;zeros(L,1)];
pp=iddata(yy);
PP=predict(mm,pp,L)
GG=get(PP)
PTT = GG.OutputData{1,1}(length(YY)+1:length(YY)+L,1)
D=[YY;PTT]
XX1 = cumsum([XX(1);D])
XX2 = XX1(length(XX)+1 : end)

for i=1:15
    if i>=10
        XX2(i)=XX2(i)-250
    end
end
subplot(222);

compare(mm,ZZ,L)
title('Iphone5S拟合')
hold on

%
L = 15
yyy = [YYY;zeros(L,1)];
ppp=iddata(yyy);
PPP=predict(mmm,ppp,L)
GGG=get(PPP)
PTTT = GGG.OutputData{1,1}(length(YYY)+1:length(YYY)+L,1)
D=[YYY;PTTT]
XXX1 = cumsum([XXX(1);D])
XXX2 = XXX1(length(XXX)+1 : end)
for i=1:15
    if i>=10
        XXX2(i)=XXX2(i)-0
    end
end
subplot(223);

compare(mmm,ZZZ,L)
title('OPPO拟合')
hold on

%
L = 15
yyyy = [YYYY;zeros(L,1)];
pppp=iddata(yyyy);
PPPP=predict(mmmm,pppp,L)
GGGG=get(PPPP)
PTTTT = GGGG.OutputData{1,1}(length(YYY)+1:length(YYY)+L,1)
D=[YYYY;PTTTT]
XXXX1 = cumsum([XXXX(1);D])
XXXX2 = XXXX1(length(XXXX)+1 : end)
for i=1:15
    if i>=10
        XXXX2(i)=XXXX2(i)-600
    end
end
subplot(224);

compare(mmmm,ZZZZ,L)
title('华为P8拟合')
hold on

