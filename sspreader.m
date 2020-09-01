%% Main script for generating most figures of the main text.

%% Load SSE data
%SSEs_scientificstudies
%SSEs_news
%SSEs_korea

%% Fig. not shown in main text
R0 = 3;
k = 0.1;
% For negative binomial, r is k and p is (1+R0/k)^(-1)
X = [0:0.1:10];
nbinomial = nbinrnd(k,(1+R0/k)^(-1),10000,1);
figure(1);subplot(2,2,1)
histogram(nbinomial,'Normalization','Probability') 
[M V]=nbinstat(k,(1+R0/k)^(-1));
[R0 R0*(1+R0/k)]; % Check mean and variance
xlabel('Number of secondary cases (Z)')
ylabel('Predicted frequency')

%% Fig. not shown in main text
R0 = 3;
k = 0.1;
% For negative binomial, a is k and b is R0/k
ngamma = gamrnd(k,R0/k,10000,1);
figure(1); subplot(2,2,2)
histogram(ngamma,'Normalization','Probability') 
[M V]=gamstat(k,R0/k);
xlabel('Individual reproductive number (v)')
ylabel('Predicted frequency')

%% Fig. 1A
figure(1); subplot(2,2,3)
edges = [0:10:200];
histogram(x,edges)
xlabel('Number of secondary cases (Z) from SSEs')
ylabel('Observed counts')


%% Fig. 1C
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

%% Fig. 1D
mep = [];
for i = 1:length(x)
    mep(i,:) = [x(i),mean(x(x>=x(i))-x(i))];
end
subplot(2,2,2)
scatter(mep(:,1),mep(:,2))

X = mep(:,1);
Y = mep(:,2);
% To accommodate different linear ranges of data, this is set to
% 1 for the dataset for South Korea (SSEs_korea), and 10 for news data (SSEs_news).
uthres = 10; 
Y(X<uthres) = []; X(X<uthres) = [];
% To accommodate different linear ranges of data, this is set to
% 30 for the dataset for South Korea (SSEs_korea), and 100 for news data (SSEs_news).
uthres = 60; 
Y(X>uthres) = []; X(X>uthres) = [];
[f,S]=polyfit(X,Y,1);
CI = polyparci(f,S,0.95);
X = [0:1:200];
hold on; plot(X,polyval(f,X))
xlim([0 100])
ylim([0 100])
box on

%% Fig. 1E
xi = []; xi1=[]; xi2=[];
n = length(x);
for k = 2:n-1
    thishillestimator = @(x)hillestimator(x,k);  % Process capability
    ci = bootci(100,thishillestimator,x);  
    xi(k,:) = [k thishillestimator(x) ci(1) ci(2)]; 
end
subplot(2,2,3); hold on;
plot(xi(:,1)/length(x),xi(:,2))
plot(xi(:,1)/length(x),xi(:,3))
plot(xi(:,1)/length(x),xi(:,4))
xlabel('Quantile')
ylabel('$\hat{\xi}$','Interpreter','latex')
box on


%% Fig. not shown: other tail estimators
figure(3); subplot(1,2,1)
xi = []; xi1=[]; xi2=[];
n = length(x);
for k = 2:floor(n/4)-1
    thispickandestimator = @(x)pickandestimator(x,k);  % Process capability
    ci = bootci(1000,thispickandestimator,x);  
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



%% Fig. 1F
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

pd = fitdist(x(x>0),'Weibull'); % Weibull
[h p] = chi2gof(x(x>0),'CDF',pd)
[h p] = kstest(x(x>0),'CDF',pd)
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


%% Fig. 1C-E: negative binomial for comparison
z=x;
x = nbinomial;
x = x(x>6); % conditioned

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


%% Not shown in main text: control for Fig. 1F
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

