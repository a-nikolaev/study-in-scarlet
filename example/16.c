s(a,n,t)int*a;{t=*a++;--n?s(a,n,0),
t>*a?a[-1]=*a,*a=t,s(a,n,0):0:0;}
