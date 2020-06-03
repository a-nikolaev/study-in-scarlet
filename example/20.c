s(int*a,int*b){int t;if(b>a)t=*a,t>*b?*a=*b,*b=t:0,
s(a++,b-1),s(a,b);}
