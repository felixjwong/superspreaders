function xihat = DedHestimator(x,k)

ox = sort(x,'descend');

runningtotal = 0;
rt2 = 0;
for i  = 1:k
    runningtotal =  runningtotal + log(ox(i)/ox(k));
    rt2 = rt2 + log(ox(i)/ox(k))^2;
end
xihat = runningtotal/k;
xihat2 = rt2/k;

xihat = 1+xihat+(1/2)*(xihat^2/xihat2 - 1)^(-1);