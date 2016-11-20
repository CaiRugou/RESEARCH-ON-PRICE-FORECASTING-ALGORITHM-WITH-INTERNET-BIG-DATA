%iphone 5s 6 6p 三次曲线拟合
x=1:10;
t=x-1;
N=[3600     3600	3600	3600	3350	3420	3320	3320	3320	3200];
N1=[4600     4600	4400	4400	4400	4400	4400	4400	4400	3750];
N2=[6088     6088	6088	6088	6088	6088	6088	6088	6088	4850];
%5s
N0=N(1)
c0=[15,0]';
[c,r,J]=nlinfit(t,N,'linderuo',c0)
[Y,delta]=nlpredci('linderuo',t,c,r,J)
plot(t,N,'-o',t,Y,'-*')
hold on
a=c(1)/N0-1

%6
N3=N1(1)
c0=[15,0]';
[c,r,J]=nlinfit(t,N1,'linderuo',c0)
[Y,delta]=nlpredci('linderuo',t,c,r,J)
plot(t,N1,'-o',t,Y,'-*')
hold on
a=c(2,:)/N3-1

%6P
N5=N2(1)
c0=[1000, 200]';
[c,r,J]=nlinfit(t,N2,'linderuo',c0)
[Y,delta]=nlpredci('linderuo',t,c,r,J)
plot(t,N2,'-o',t,Y,'-*')
a=c(1)/N5-1

% xlabel('时间')
ylabel('价格/元')
legend('Price trend','Fitting effect')
% title('逻辑增长曲线拟合')

%调用逻辑增长模型S
x1=11:15
[Y,delta] = nlpredci('linderuo',x1,c,r,J)
