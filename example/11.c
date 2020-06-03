s(int*a,int*b){for(int*c=b,t;c>a;)
if(t=*c--,*c>t)c[1]=*c,*c=t,c=b;}
