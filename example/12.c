s(int*a,int*b){for(int*c=b,t;c>a;)
t=*c--,*c>t?c[1]=*c,*c=t,c=b:0;}
