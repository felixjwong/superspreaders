%% Load SSE data
x=[10
9
6.5
11
11
15
11
10
37
16
51
19
15
73
17.5
52
78
29
22
19
17
14
533
21
19
13
13
33
112
16
21
23
23
40
15
10
8
12
44];


%% Fig. 1A
R0 = 3;
k = 0.1;
% For negative binomial, r is k and p is (1+R0/k)^(-1)
X = [0:0.1:10];
nbinomial = nbinrnd(k,(1+R0/k)^(-1),10000,1);
figure(1);subplot(2,2,1)
histogram(nbinomial,'Normalization','Probability') 
[M V]=nbinstat(k,(1+R0/k)^(-1));
[R0 R0*(1+R0/k)]; % check mean and variance
xlabel('Number of secondary cases (Z)')
ylabel('Predicted frequency')

%% Fig. 1B
R0 = 3;
k = 0.1;
% For negative binomial, a is k and b is R0/k
ngamma = gamrnd(k,R0/k,10000,1);
figure(1); subplot(2,2,2)
histogram(ngamma,'Normalization','Probability') 
[M V]=gamstat(k,R0/k);
xlabel('Individual reproductive number (v)')
ylabel('Predicted frequency')

%% Fig. 1D
figure(1); subplot(2,2,3)
edges = [0:10:600];
histogram(x,edges)
xlabel('Number of secondary cases (Z) from SSEs')
ylabel('Observed counts')


%% Fig. 2A
zipf = [];
for i = 1:length(x)
    F=length(find(x<x(i)))/length(x);
    zipf(i,:)=[x(i), 1-F];
end
figure(2);subplot(2,2,1);
scatter(log10(zipf(:,1)),log10(zipf(:,2)))

X = log10(zipf(:,1));
Y = log10(zipf(:,2));
Y(X<1) = []; X(X<1) = [];
Y(X==max(X)) = []; X(X==max(X)) = [];
[f,S]=polyfit(X,Y,1);
CI = polyparci(f,S,0.95);
X = [0:0.01:3];
hold on; plot(X,polyval(f,X))
box on

%% Fig. 2B
mep = [];
for i = 1:length(x)
    mep(i,:) = [x(i),mean(x(x>=x(i))-x(i))];
end
subplot(2,2,2)
scatter(mep(:,1),mep(:,2))

X = mep(:,1);
Y = mep(:,2);
uthres = 10;
Y(X<uthres) = []; X(X<uthres) = [];
Y(X==max(X)) = []; X(X==max(X)) = [];
[f,S]=polyfit(X,Y,1);
CI = polyparci(f,S,0.95);
X = [0:1:200];
hold on; plot(X,polyval(f,X))
xlim([0 200])
ylim([0 250])
box on

%% Fig. 2C
xi = []; xi1=[]; xi2=[];
n = length(x);
for k = 2:n-1
    thishillestimator = @(x)hillestimator(x,k);  % Process capability
    ci = bootci(5000,thishillestimator,x);  
    xi(k,:) = [k thishillestimator(x) ci(1) ci(2)]; 
end
subplot(2,2,3); hold on;
plot(xi(:,1)/length(x),xi(:,2))
plot(xi(:,1)/length(x),xi(:,3))
plot(xi(:,1)/length(x),xi(:,4))
xlabel('Quantile')
ylabel('$\hat{\xi}$','Interpreter','latex')
box on

figure(3); subplot(1,2,1)
xi = []; xi1=[]; xi2=[];
n = length(x);
for k = 2:floor(n/4)
    thispickandestimator = @(x)pickandestimator(x,k);  % Process capability
    ci = bootci(5000,thispickandestimator,x);  
    xi(k,:) = [k thispickandestimator(x) ci(1) ci(2)]; 
end
hold on;
plot(xi(:,1)/length(x),xi(:,2))
plot(xi(:,1)/length(x),xi(:,3))
plot(xi(:,1)/length(x),xi(:,4))
xlabel('Quantile')
ylabel('$\hat{\xi}$','Interpreter','latex')
box on


figure(3); subplot(1,2,2)
xi = []; xi1=[]; xi2=[];
n = length(x);
for k = 2:n-1
    thisDedHestimator = @(x)DedHestimator(x,k);  % Process capability
    ci = bootci(5000,thisDedHestimator,x);  
    xi(k,:) = [k thisDedHestimator(x) ci(1) ci(2)]; 
end
hold on;
plot(xi(:,1)/length(x),xi(:,2))
plot(xi(:,1)/length(x),xi(:,3))
plot(xi(:,1)/length(x),xi(:,4))
xlabel('Quantile')
ylabel('$\hat{\xi}$','Interpreter','latex')
box on




%% Fig. 2D
xs = [1:1:600];
nbins = 30;
figure(2);

pd = fitdist(-x,'ExtremeValue'); % Gumbel
[h p] = chi2gof(-x,'CDF',pd)
[h p] = kstest(-x,'CDF',pd)
subplot(2,2,4); hold on
%histfit(-x,10,'ev')
[~,edges] = histcounts(log10(x));
histogram(x,10.^edges,'Normalization','pdf')
set(gca, 'xscale','log')
%histogram(x,nbins,'Normalization','Probability','FaceColor','b')
plot(xs,evpdf(-xs,pd.mu,pd.sigma),'r','LineWidth',2)

pd = fitdist(x,'Weibull'); % Weibull
[h p] = chi2gof(x,'CDF',pd)
[h p] = kstest(x,'CDF',pd)
%subplot(2,2,2); hold on
%histfit(x,10,'Weibull')
%[~,edges] = histcounts(log10(x));
%histogram(x,10.^edges,'Normalization','Probability','FaceColor','b')
%set(gca, 'xscale','log')
%histogram(x,nbins,'Normalization','Probability','FaceColor','b')
plot(xs,wblpdf(xs,pd.A,pd.B),'g','LineWidth',2)

pd = fitdist(1./x,'Weibull'); % Frechet
[h p] = chi2gof(1./x,'CDF',pd)
[h p] = kstest(1./x,'CDF',pd)
%subplot(2,2,3); hold on
%histfit(1./x,10,'Weibull')
%[~,edges] = histcounts(log10(x));
%histogram(x,10.^edges,'Normalization','Probability','FaceColor','b')
%set(gca, 'xscale','log')
%histogram(x,nbins,'Normalization','Probability','FaceColor','b')
plot(xs,wblpdf(1./xs,pd.A,pd.B)./(xs.^2),'b','LineWidth',2)

xlabel('Number of secondary cases (Z) from SSEs')
ylabel('Frequency')
box on


%% Fig. 2: negative binomial for comparison
z=x;
x = nbinomial;

zipf = [];
for i = 1:length(x)
    F=length(find(x<x(i)))/length(x);
    zipf(i,:)=[x(i), 1-F];
end
figure(2); subplot(2,2,1); hold on;
scatter(log10(zipf(:,1)),log10(zipf(:,2)))

xlabel('Log(Z)')
ylabel('Log survival')

mep = [];
for i = 1:length(x)
    mep(i,:) = [x(i),mean(x(x>=x(i))-x(i))];
end
figure(2); subplot(2,2,2); hold on;
scatter(mep(:,1),mep(:,2))

xlabel('Threshold (u)')
ylabel('Mean excess value')

xi = []; xi1=[]; xi2=[];
n = length(x);
for k = 2:n-1
    thishillestimator = @(x)hillestimator(x,k);  % Process capability
    %ci = bootci(5,thishillestimator,x);  
    xi(k,:) = [k thishillestimator(x+1) ci(1) ci(2)]; % take support to be at 1
end
figure(2); subplot(2,2,3); hold on;
plot(xi(:,1)/length(x),xi(:,2))
%plot(xi(:,1),xi(:,3))
%plot(xi(:,1),xi(:,4))


%% Not shown in text: Fig. 2D - control
ev = [];
for i = 1:10000
    ev(i) = max(nbinrnd(k,(1+R0/k)^(-1),1000,1));
end

figure; hold on
x = ev';
xs = [1:1.5:600];
nbins = 30;

pd = fitdist(-x,'ExtremeValue'); % Gumbel
[h p] = chi2gof(-x,'CDF',pd)
[h p] = kstest(-x,'CDF',pd)
[~,edges] = histcounts(log10(x));
histogram(x,10.^edges,'Normalization','Probability')
set(gca, 'xscale','log')
plot(xs,evpdf(-xs,pd.mu,pd.sigma),'r','LineWidth',2)

pd = fitdist(x,'Weibull'); % Weibull
[h p] = chi2gof(x,'CDF',pd)
[h p] = kstest(x,'CDF',pd)
plot(xs,wblpdf(xs,pd.A,pd.B),'g','LineWidth',2)

pd = fitdist(1./x,'Weibull'); % Frechet
[h p] = chi2gof(1./x,'CDF',pd)
[h p] = kstest(1./x,'CDF',pd)
plot(xs,wblpdf(1./xs,pd.A,pd.B)./(xs.^2),'b','LineWidth',2)

xlabel('Number of secondary cases (Z) from SSEs')
ylabel('Frequency')

x=z;
