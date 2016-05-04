mm=0;
mw=0;
wm=0;
ww=0;
for id = 1:3
    test = datad(:,i_group)==id;
    predict33 = prediction2(test,:)>10;
    mm = mm+sum(datad(test,i_ws)==0 & predict33==0);
mw = mw+sum(datad(test,i_ws)==0 & predict33==1);
wm = wm+sum(datad(test,i_ws)==1 & predict33==0);
ww = ww+sum(datad(test,i_ws)==1 & predict33==1);

end

a=0;b=0;c=0;

for id = 1:3
    test = datad(:,i_group)==id;
    sub = datad(test,i_speed);
    predict33 = prediction2(test,:)>10;
index = (datad(test,i_ws)==0 & predict33==1);
a = a + sum(sub(index)==10 |sub(index)==9 );

b = b + sum(sub(index)==8 |sub(index)==7 );
c = c + sum(sub(index)<7 );
end
a = a/44353/3;
b = b/44353/3;
c=c/44353/3;


mm=mm/3
mw=mw/3
wm=wm/3
ww=ww/3

 test = datad(:,i_group)==1;
    predict33 = sum(yfit2(:,11:end),2)>0.5;
    mm = sum(datad(test,i_ws)==0 & predict33==0)
mw = sum(datad(test,i_ws)==0 & predict33==1)
wm = sum(datad(test,i_ws)==1 & predict33==0)
ww = sum(datad(test,i_ws)==1 & predict33==1)

 test = datad(:,i_group)==1;
    predict33 = sum(yfit,2)>0.45;
    mm = sum(datad(test,i_ws)==0 & predict33==0)
mw = sum(datad(test,i_ws)==0 & predict33==1)
wm = sum(datad(test,i_ws)==1 & predict33==0)
ww = sum(datad(test,i_ws)==1 & predict33==1)