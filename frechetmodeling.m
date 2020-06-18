
ev = [];
evbdd = [];
evmask = [];
for i = 1:1000000
    XX = 1./wblrnd(1,1.4,40,1);
    ev(i) = max(XX);
    evbdd(i) = max(XX(XX<15));
    evmask(i) = max(1./wblrnd(2,1.4,50,1));
end

figure;
subplot(2,2,2)
bins = 0:2:100;
histogram(ev,bins,'Normalization','Probability')
hold on
%histogram(evbdd,bins,'Normalization','Probability')
hold on
xlim([0 100])
plot([mean(ev) mean(ev)],[0,1])
plot([mean(evbdd) mean(evbdd)],[0,1])
ylim([0 0.5])
%histogram(evmask,bins,'Normalization','Probability')
xlabel('Number of secondary cases (Z) from SSEs')
ylabel('Frequency')

[mean(ev) mean(evbdd) mean(evmask)] % cutting tail is akin to reducing R0 by factor of 2

X = [0.0:0.1:100];
subplot(2,2,1)
plot(X,wblpdf(1./X,1,1.4)./(X.^2))
hold on;
ylim([0 0.8])
xlabel('Number of secondary cases (Z)')
ylabel('Frequency')


u = [1:1:100];
ZZ = [];
for i = 1:length(u)
    maxes = [];
    for j = 1:100000
        XX = 1./wblrnd(1,1.42,40,1);
        maxes(j)= max(XX(XX<u(i)));
    end
    ZZ(i) = mean(maxes);
end

integrand = @(w) w.*1.42.*exp(-1./(w.^1.42))./(w.^2.42);
thismean = @(w1) integral(integrand,0,w1);
YY = [];
for i = 1:length(s)
    YY(i) = thismean(s(i));
end

figure;
subplot(2,2,1)
plot(s,YY)
ylabel('Mean number of secondary cases')
yyaxis right
plot(u,ZZ)
ylabel('Mean number of secondary cases from SSEs')
xlabel('Contact threshold')

subplot(2,2,2)
plot(exp(-s.^(-1.4)),YY)
ylabel('Mean number of secondary cases')
yyaxis right
plot(exp(-u.^(-1.4)),ZZ)
ylabel('Mean number of secondary cases from SSEs')
xlabel('Z percentile')

