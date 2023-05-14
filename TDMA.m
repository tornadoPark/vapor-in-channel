function x = TDMA(A,f)
% A为系数矩阵 f为常数向量 x为解向量（Ax=f）
% A应为对角占优的三对角阵
% 算法见李庆扬 《数值算法》 第五版 p159-161

% 取矩阵规模
sizeOfA = size(A);
sizeOfA = sizeOfA(1,1);

% 计算中间向量beta（追）
beta = [];
i = 1;
beta(i)= A(i,i+1)/A(i,i);
for i = 2: sizeOfA-1
    beta(i) = A(i,i+1)/(A(i,i)-A(i,i-1)*beta(i-1));
end

% 计算中间向量y（追）
y = [];
i= 1;
y(i) = f(i)/A(i,i);

for i = 2: sizeOfA
    y(i) = (f(i) - A(i,i-1)*y(i-1))/(A(i,i)-A(i,i-1)*beta(i-1));
end

% 计算解向量x（赶）
x(i) = y(i);
while i >1
    i = i-1;
    x(i) = y(i) - beta(i)*x(i+1);
    
end

% 转置成列向量
x= x';
end
