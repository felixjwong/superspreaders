
ev = [];
evbdd = [];
evmask = [];
for i = 1:10000
    XX = 1./wblrnd(1,1.4,50,1);
    ev(i) = max(XX);
    evbdd(i) = max(XX(XX<100));
    evmask(i) = max(1./wblrnd(2,1.4,50,1));
end

figure;
bins = 0:10:600;
histogram(ev,bins,'Normalization','Probability')
hold on
histogram(evbdd,bins,'Normalization','Probability')
hold on
histogram(evmask,bins,'Normalization','Probability')


[M,V] = wblstat(1,1.4)


[mean(ev) mean(evbdd) mean(evmask)] % cutting tail is akin to reducing R0 by factor of 2
