%iphone 5s 6 6p 三次曲线拟合
x=1:10;
y=[3600     3600	3600	3600	3350	3420	3320	3320	3320	3200;
   4600     4600	4400	4400	4400	4400	4400	4400	4400	3750;
   6088     6088	6088	6088	6088	6088	6088	6088	6088	4850
   ];
%一次直线拟合5s
p2=polyfit(x,y(1,:),3)
Y2=polyval(p2,x);
plot(x,y(1,:),'-o',x,Y2,'-*')
hold on
%一次直线拟合6
p2=polyfit(x,y(2,:),3)
Y2=polyval(p2,x);
plot(x,y(2,:),'-o',x,Y2,'-*')
hold on
%一次直线拟合6plus
p2=polyfit(x,y(3,:),3)
Y2=polyval(p2,x);
plot(x,y(3,:),'-o',x,Y2,'-*')

x=11:15
Y5=polyval(p2,x)
% xlabel('时间')
ylabel('价格/元')
legend('Price trend','Fitting effect')
% title('3次多项式拟合')

%调用三次曲线拟合模型
%预测11:15产品周期的价格
x=11:15;
Y5 = polyval(p2,x)  %三次曲线




