function x = TDMA(A,f)
% AΪϵ������ fΪ�������� xΪ��������Ax=f��
% AӦΪ�Խ�ռ�ŵ����Խ���
% �㷨�������� ����ֵ�㷨�� ����� p159-161

% ȡ�����ģ
sizeOfA = size(A);
sizeOfA = sizeOfA(1,1);

% �����м�����beta��׷��
beta = [];
i = 1;
beta(i)= A(i,i+1)/A(i,i);
for i = 2: sizeOfA-1
    beta(i) = A(i,i+1)/(A(i,i)-A(i,i-1)*beta(i-1));
end

% �����м�����y��׷��
y = [];
i= 1;
y(i) = f(i)/A(i,i);

for i = 2: sizeOfA
    y(i) = (f(i) - A(i,i-1)*y(i-1))/(A(i,i)-A(i,i-1)*beta(i-1));
end

% ���������x���ϣ�
x(i) = y(i);
while i >1
    i = i-1;
    x(i) = y(i) - beta(i)*x(i+1);
    
end

% ת�ó�������
x= x';
end
