%% Forward modeling with a Frechet distribution, for Figs. 2A-C

%% Fig. 2A,B
ev = [];
evbdd = [];
for i = 1:1000000
    XX = 1./wblrnd(0.7,1.7,30,1);
    ev(i) = max(XX(XX>=1));
end

figure;
subplot(2,2,2)
bins = 0:2:100;
histogram(ev,bins,'Normalization','Probability')
hold on
xlim([0 100])
plot([mean(ev) mean(ev)],[0,1])
ylim([0 0.2])
xlabel('Number of secondary cases (Z) from SSEs')
ylabel('Frequency')

X = [0.0:0.01:100];
subplot(2,2,1)
plot(X,wblpdf(1./X,0.7,1.7)./(X.^2))
hold on;
ylim([0 0.8])
xlabel('Number of secondary cases (Z)')
ylabel('Frequency')

%% Fig. 2C
u = [0.1:0.5:100];
ZZ = [];
for i = 1:length(u)
    maxes = [];
    for j = 1:1000
        XX = 1./wblrnd(0.7,1.7,30,1);
        if isempty(max(XX(XX<=u(i))))
            maxes(j)  = 0;
        else 
            maxes(j)= max(XX(XX<=u(i)));
        end
    end
    ZZ(i) = mean(maxes);
end

integrand = @(w) w.*wblpdf(1./w,0.7,1.7)./(w.^2);
thismean = @(w1) integral(integrand,0,w1);

thisintegrand = @(w) wblpdf(1./w,0.7,1.7)./(w.^2);
thispercentile = @(w1) integral(thisintegrand,0,w1);

% Calculate mean
YY = [];
s = [];
for i = 1:length(u)
    YY(i) = thismean(u(i));
    s(i) = thispercentile(u(i));
end

figure;
subplot(2,2,1)
plot(u,YY)
ylabel('Mean number of secondary cases')
yyaxis right
plot(u,ZZ)
ylabel('Mean number of secondary cases from SSEs')
xlabel('Contact threshold')

subplot(2,2,2)
plot(s*100,YY)
ylabel('Mean number of secondary cases')
yyaxis right
plot(s*100,ZZ)
ylabel('Mean number of secondary cases from SSEs')
xlabel('Z percentile')

