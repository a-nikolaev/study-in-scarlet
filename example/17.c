s(a,n,t)int*a;{t=*a;n--?s(a+1,n,0),
*a=a[1],a[t>*a]=t,s(a+1,n,0):0;}
