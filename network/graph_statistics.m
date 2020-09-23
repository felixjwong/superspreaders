X=sum(A,2);

thresh = 10;
phi = length(X(X>thresh))/length(X);
X=X(X<=thresh);

CV = std(X)/mean(X);
R0 = Pe/Pr*mean(X);
F = (1+CV^2);
adjR0 = R0*F;

[thresh mean(X) phi adjR0]