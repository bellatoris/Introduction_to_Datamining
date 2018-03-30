clear

alpha = 1;
beta =   1;
a = [3.06, 500 * alpha, 6 * beta];
b = [2.68, 320 * alpha, 4 * beta];
c = [2.92, 640 * alpha, 6 * beta];

cos1 = dot(a,b)/(norm(a)*norm(b));
cos3 = dot(b,c)/(norm(b)*norm(c));
cos2 = dot(a,c)/(norm(a)*norm(c));

angle1 = acos(cos1)
angle2 = acos(cos3)
angle3 = acos(cos2)

alpha = 0.01;
beta =   0.5;
a = [3.06, 500 * alpha, 6 * beta];
b = [2.68, 320 * alpha, 4 * beta];
c = [2.92, 640 * alpha, 6 * beta];

cos1 = dot(a,b)/(norm(a)*norm(b));
cos3 = dot(b,c)/(norm(b)*norm(c));
cos2 = dot(a,c)/(norm(a)*norm(c));

angle1 = acos(cos1)
angle2 = acos(cos3)
angle3 = acos(cos2)

alpha = (a(1)+b(1)+c(1))/(500+320+640);
beta = (a(1)+b(1)+c(1))/(6+4+6);
a = [3.06, 500 * alpha, 6 * beta];
b = [2.68, 320 * alpha, 4 * beta];
c = [2.92, 640 * alpha, 6 * beta];

cos1 = dot(a,b)/(norm(a)*norm(b));
cos3 = dot(b,c)/(norm(b)*norm(c));
cos2 = dot(a,c)/(norm(a)*norm(c));

angle1 = acos(cos1)
angle2 = acos(cos3)
angle3 = acos(cos2)

%%

A = 4;
B = 2;
C = 5;

avg = A+B+C;
avg = avg/3;

A = A-avg;
B = B-avg;
C = C-avg;

a = [3.06, 500, 6];
b = [2.68, 320, 4];
c = [2.92, 640, 6];

user = A*a + B*b+ C*c;

%%

A = ['4';'5';'0';'5';'1';'0';'3';'2'];
B = ['0';'3';'4';'3';'1';'2';'1';'0'];
C = ['2';'0';'1';'3';'0';'4';'5';'3'];

A = str2num(A);
B = str2num(B);
C = str2num(C);

A = A>=1;
B = B>=1;
C = C>=1;

A = double(A)';
B = double(B)';
C = double(C)';

D = [A;B;C];

sim1 = sum(A==B)/8
sim2 = sum(B==C)/8
sim3 = sum(A==C)/8

cos1 = dot(A,B)/(norm(A)*norm(B))
cos3 = dot(B,C)/(norm(B)*norm(C))
cos2 = dot(A,C)/(norm(A)*norm(C))

A = ['4';'5';'0';'5';'1';'0';'3';'2'];
B = ['0';'3';'4';'3';'1';'2';'1';'0'];
C = ['2';'0';'1';'3';'0';'4';'5';'3'];

A = str2num(A);
B = str2num(B);
C = str2num(C);

A = A>=3;
B = B>=3;
C = C>=3;

A = double(A)';
B = double(B)';
C = double(C)';

D = [A;B;C];

sim1 = sum(A==B)/8
sim2 = sum(B==C)/8
sim3 = sum(A==C)/8

cos1 = dot(A,B)/(norm(A)*norm(B))
cos2 = dot(B,C)/(norm(B)*norm(C))
cos3 = dot(A,C)/(norm(A)*norm(C))


A = ['4';'5';'0';'5';'1';'0';'3';'2'];
B = ['0';'3';'4';'3';'1';'2';'1';'0'];
C = ['2';'0';'1';'3';'0';'4';'5';'3'];

A = str2num(A)';
B = str2num(B)';
C = str2num(C)';

A = A-sum(A)/6;
B = B-sum(B)/6;
C = C-sum(C)/6;

A(3) = 0;
A(6) = 0;
B(1) = 0;
B(8) = 0;
C(2) = 0;
C(5) = 0;

cos1 = dot(A,B)/(norm(A)*norm(B))
cos2 = dot(B,C)/(norm(B)*norm(C))
cos3 = dot(A,C)/(norm(A)*norm(C))

D = [A;B;C];


A = ['4';'5';'0';'5';'1';'0';'3';'2'];
B = ['0';'3';'4';'3';'1';'2';'1';'0'];
C = ['2';'0';'1';'3';'0';'4';'5';'3'];

A = str2num(A)';
B = str2num(B)';
C = str2num(C)';

A_1(1) = (A(1)+A(2)+A(4))/3;
A_1(2) = A(5);
A_1(3) = (A(8));
A_1(4) = A(7);

B_1(1) = (B(3)+B(2)+B(4))/3;
B_1(2) = B(5);
B_1(3) = (B(6));
B_1(4) = B(7);

C_1(1) = (C(1)+C(3)+C(4))/3;
C_1(2) = C(5);
C_1(3) = (C(6)+C(8))/2;
C_1(4) = C(7);

D_1 = [A_1;B_1;C_1];

cos1 = dot(A_1,B_1)/(norm(A_1)*norm(B_1))
cos2 = dot(B_1,C_1)/(norm(B_1)*norm(C_1))
cos3 = dot(A_1,C_1)/(norm(A_1)*norm(C_1))

