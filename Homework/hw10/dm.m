A = [1,1,1;1,2,3;,1,3,5];
[V, D] = eig(A);

M = [1,2,3;3,4,5;5,4,3;0,2,4;1,3,5];

B = M'*M;
C = M*M';

[VB, DB] = eig(B);
[VC, DC] = eig(C);

U = [VC(:,5), VC(:,4)];
V = [VB(:,3), VB(:,2)];
sigma = sqrt([DB(3,3),0;0,DB(2,2)]);

expM = U*sigma*V'
