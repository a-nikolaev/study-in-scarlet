void sort(int*a,int n){int*b,*c,t;for(b=a+n;--b>a;)
for(c=b;--c>=a;)if(*c>*b)t=*b,*b=*c,*c=t;}
