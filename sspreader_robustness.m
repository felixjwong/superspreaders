
z=x;

figure(1); 
subplot(1,2,1)
hold on 

%% Random noise
xi_1 = []; 
for i = 1:10000
    x=x.*(0.9+rand(length(x),1)*0.2);
    xi = []; 
    n = length(x);
    for k = 2:n-1
        thishillestimator = @(x)hillestimator(x,k);  % Process capability
        xi(k,:) = [k/length(x) thishillestimator(x)]; 
    end
    X = xi(:,1);
    Y = xi(:,2);
    xi_1(i) = mean(Y(X>0.5&X<0.7));
    plot1 = plot(xi(:,1),xi(:,2));
    plot1.Color(4) = 0.1;
end
xlabel('Quantile')
ylabel('$\hat{\xi}$','Interpreter','latex')
box on

figure(2);
subplot(1,2,1)
edges=[0:0.5:6];
histogram(xi_1,edges,'Normalization','Probability')
ylabel('Probability')
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
    xi_2(i) = mean(Y(X>0.5&X<0.7));
    plot1 = plot(xi(:,1),xi(:,2));
    plot1.Color(4) = 0.1;
end
xlabel('Quantile')
ylabel('$\hat{\xi}$','Interpreter','latex')
box on

figure(2);
subplot(1,2,2) 
edges=[0:0.1:1];
histogram(xi_2,edges,'Normalization','Probability')
ylabel('Probability')
xlabel('$\hat{\xi}$','Interpreter','latex')
box on

x=z;