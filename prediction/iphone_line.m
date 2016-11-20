%iphone 5s 6 6p
x=1:10;
y=[3600     3600	3600	3600	3350	3420	3320	3320	3320	3200;
   4600     4600	4400	4400	4400	4400	4400	4400	4400	3750;
   6088     6088	6088	6088	6088	6088	6088	6088	6088	4850
   ];
%一次直线拟合5s
p1=polyfit(x,y(1,:),1)
Y1=polyval(p1,x);
plot(x,y(1,:),'-o',x,Y1,'-*')
% xlabel('时间')
ylabel('价格/元')
legend('价格走势','拟合效果')
title('iphone5S拟合效果')
hold on
%一次直线拟合6
p1=polyfit(x,y(2,:),1)
Y1=polyval(p1,x);
plot(x,y(2,:),'-o',x,Y1,'-*')
% xlabel('时间')
ylabel('价格/元')
legend('价格走势','拟合效果')
title('iphone6 拟合效果')
hold on
%一次直线拟合6plus
p1=polyfit(x,y(3,:),1)
Y1=polyval(p1,x);
plot(x,y(3,:),'-o',x,Y1,'-*')
%xlabel('时间')
ylabel('价格/元')
legend('Price trend','Fitting effect')
%title('iphone6 plus拟合效果')
title('直线性拟合')