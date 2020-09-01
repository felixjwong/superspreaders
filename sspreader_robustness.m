%% Robustness checks for missing data and noise, for Fig. 1H

z=x;
figure(1); 
subplot(1,2,1)
hold on 

%% Random noise
xi_1 = []; 
for i = 1:10000
    x=x.*(0.5+rand(length(x),1)*1.0); % [0.5,1.5] range for noise
    xi = []; 
    n = length(x);
    for k = 2:n-1
        thishillestimator = @(x)hillestimator(x,k);  % Process capability
        xi(k,:) = [k/length(x) thishillestimator(x)]; 
    end
    X = xi(:,1);
    Y = xi(:,2);
    xi_1(i) = mean(Y);
    plot1 = plot(xi(:,1),xi(:,2));
    plot1.Color(4) = 0.1;
end
xlabel('Quantile')
ylabel('$\hat{\xi}$','Interpreter','latex')
box on

figure(2);
subplot(1,6,1)
edges=[0:3:30];
histogram(xi_1,edges,'Normalization','probability')
ylabel('Frequency')
xlabel('$\hat{\xi}$','Interpreter','latex')
box on

%% Random drops
figure(1);
subplot(1,2,2)
hold on
xi_2 = [];
for i = 1:10000
    x = z;
    x = x(randperm(length(x)));
    num_drop = randi(9);
    x(end-num_drop:end) = [];
        
    xi = []; 
    n = length(x);
    for k = 2:n-1
        thishillestimator = @(x)hillestimator(x,k);  % Process capability
        xi(k,:) = [k/length(x) thishillestimator(x)]; 
    end
    X = xi(:,1);
    Y = xi(:,2);
    xi_2(i) = mean(Y);
    plot1 = plot(xi(:,1),xi(:,2));
    plot1.Color(4) = 0.1;
end
xlabel('Quantile')
ylabel('$\hat{\xi}$','Interpreter','latex')
box on

figure(2);
subplot(1,6,2) 
edges=[0:0.1:1];
histogram(xi_2,edges,'Normalization','Probability')
ylabel('Frequency')
xlabel('$\hat{\xi}$','Interpreter','latex')
box on

x=z;