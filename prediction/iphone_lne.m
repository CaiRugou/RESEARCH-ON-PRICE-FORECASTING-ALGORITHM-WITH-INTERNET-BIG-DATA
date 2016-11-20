%iphone 5s 6 6p 三次曲线拟合
x=1:10;
y=[3600     3600	3600	3600	3350	3420	3320	3320	3320	3200;
   4600     4600	4400	4400	4400	4400	4400	4400	4400	3750;
   6088     6088	6088	6088	6088	6088	6088	6088	6088	4850
   ];
%5s
p4=polyfit(x,log(y(1,:)),2)
Y4=exp(polyval(p4,x));
semilogy(x,y(1,:),'-o',x,Y4,'-*')
hold on
%6
p4=polyfit(x,log(y(2,:)),2)
Y4=exp(polyval(p4,x));
semilogy(x,y(2,:),'-o',x,Y4,'-*')
hold on
%6p

p4=polyfit(x,log(y(3,:)),2)
Y4=exp(polyval(p4,x));
semilogy(x,y(3,:),'-o',x,Y4,'-*')
% xlabel('时间')
ylabel('价格/元')
legend('Price trend','Fitting effect')
% title('指数拟合')
%调用指数lne曲线拟合模型
%预测11:15产品周期的价格
x=11:15;
Y5 = exp(polyval(p4,x))  %曲线
