%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%                     %%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%      Question1      %%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%                     %%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
beta = 1;
epsilon = 10^-6;
N = 3;
M = [[1/3; 1/3; 1/3], [1/2; 0; 1/2], [0; 1/2; 1/2]];

r1 = [1/3; 1/3; 1/3];
r2 = [];

for i = 0:10000
    r2 = beta * M *r1;
    r2 = r2 + (1 - sum(r2)) / N;
    if sum(abs(r1 - r2)) <= epsilon
        break;
    end
    r1 = r2;
end
ans1 = r1

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%                     %%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%      Question2      %%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%                     %%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
beta = 0.8;
epsilon = 10^-6;
N = 3;
M = [[1/3; 1/3; 1/3], [1/2; 0; 1/2], [0; 1/2; 1/2]];

r1 = [1/3; 1/3; 1/3];
r2 = [];

for i = 0:10000
    r2 = beta * M *r1;
    r2 = r2 + (1 - sum(r2)) / N;
    if sum(abs(r1 - r2)) <= epsilon
        break;
    end
    r1 = r2;
end
ans2 = r1

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%                      %%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%     Question3-(a)    %%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%                      %%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
beta = 0.8;
epsilon = 10^-6;
M2 = [[0; 1/3; 1/3; 1/3], [1/2; 0; 0; 1/2], [1; 0; 0; 0], ...
    [0; 1/2; 1/2; 0]];
S = 1;
r1 = [1/4; 1/4; 1/4; 1/4];
r2 = [];

for i = 0:10000
    r2 = beta * M2 * r1;
    r2 = r2 + (1 - beta) * [1; 0; 0; 0] / S;
    if sum(abs(r1 - r2)) <= epsilon
        break;
    end
    r1 = r2;
end
ans3 = r1

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%                      %%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%     Question3-(b)    %%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%                      %%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
beta = 0.8;
epsilon = 10^-6;
M2 = [[0; 1/3; 1/3; 1/3], [1/2; 0; 0; 1/2], [1; 0; 0; 0], ...
    [0; 1/2; 1/2; 0]];
S = 2;
r1 = [1/4; 1/4; 1/4; 1/4];
r2 = [];

for i = 0:10000
    r2 = beta * M2 * r1;
    r2 = r2 + (1 - beta) * [1; 0; 1; 0] / S;
    if sum(abs(r1 - r2)) <= epsilon
        break;
    end
    r1 = r2;
end
ans4 = r1

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%                       %%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%     Question4-(a)     %%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%                       %%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
beta = 0.8;
epsilon = 10^-6;
M2 = [[0; 1/3; 1/3; 1/3], [1/2; 0; 0; 1/2], [1; 0; 0; 0], ...
    [0; 1/2; 1/2; 0]];
S = 1;
r1 = [1/4; 1/4; 1/4; 1/4];
r2 = [];

for i = 0:10000
    r2 = beta * M2 * r1;
    r2 = r2 + (1 - beta) * [0; 1; 0; 0] / S;
    if sum(abs(r1 - r2)) <= epsilon
        break;
    end
    r1 = r2;
end
ans5 = r1 %%trust rank

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%                       %%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%     Question4-(b)     %%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%                       %%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
beta = 0.8;
epsilon = 10^-6;
M2 = [[0; 1/3; 1/3; 1/3], [1/2; 0; 0; 1/2], [1; 0; 0; 0], ...
    [0; 1/2; 1/2; 0]];
N = 4;
r1 = [1/4; 1/4; 1/4; 1/4];
r2 = [];

for i = 0:10000
    r2 = beta * M2 * r1;
    r2 = r2 + (1 - beta) / N;
    if sum(abs(r1 - r2)) <= epsilon
        break;
    end
    r1 = r2;
end
ans6 = r1 %%page rank

spam_mass = (ans6 - ans5) ./ ans6

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%                     %%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%      Question5      %%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%                     %%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

beta = 0.8;
epsilon = 10^-6;
M2 = [[0; 1/3; 1/3; 1/3], [1/2; 0; 0; 1/2], [1; 0; 0; 0], ...
    [0; 1/2; 1/2; 0]];
A = M2';

h = [1/4; 1/4; 1/4; 1/4];
a = [1/4; 1/4; 1/4; 1/4];

K = A * A';
L = A' * A;

for i = 0:10000
    if sum(abs(h - (K * h)/sum(K * h))) <= epsilon
        break;
    end
    h = K * h;
    h = h/sum(h);
end

for i = 0:10000
    if sum(abs(a - (L * a)/sum(L * a))) <= epsilon
        break;
    end
    a = L * a;
    a = a/sum(a);
end

ans7 = [h, a] %%page rank