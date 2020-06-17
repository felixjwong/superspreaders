function xihat = pickandestimator(x,k)

ox = sort(x,'descend');

xihat = log((ox(k)-ox(2*k))/(ox(2*k)-ox(4*k)))/log(2);