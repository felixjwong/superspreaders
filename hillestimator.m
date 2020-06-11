function xihat = hillestimator(x,k)

ox = sort(x,'descend');

runningtotal = 0;
for i  = 1:k
    runningtotal =  runningtotal + log(ox(i)/ox(k));
end
xihat = runningtotal/k;
