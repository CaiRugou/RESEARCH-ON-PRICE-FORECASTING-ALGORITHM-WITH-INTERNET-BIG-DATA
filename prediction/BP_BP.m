p=[1183 1303 1278;1303 1278 1284;1278 1284 1187 ;...
    1284 1187 1154;1187 1154 1267;1154 1267 1241;...
    1267 1241 1302;1241 1302 1195;1302 1195 1256]'*0.001;
t=[ 2050	2050	2050	2050	2050	2000	2050	2050	2000]*0.001;
net=newff(minmax(p),[15,1],{'tansig','purelin'},'trainlm');
net.trainParam.goal=0.001;
net.trainParam.show=50;
% net.trainParam.lr = 0.1
net.trainParam.mc=0.9
net.trainParam.min_grad=1e-10;
net.trainParam.epochs=10000;
[net,tr]=train(net,p,t);
t1=sim(net,[1302 1195 1256]'*0.001);
t2013=t1*1000%2013