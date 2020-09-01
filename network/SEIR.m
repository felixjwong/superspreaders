%% Simulates well-mixed SEIR model predictions.

clear all;

%% Parameters
beta = 0.02; % units 1/time, transmission rate
gamma = 0.0667; % units 1/time, recovery rate, transmission rate/recovery rate is basic reproduction number R0
delta = 1/5; % units 1/time, incubation rate
d = 10;

% initial S/E/I/R fractions
n = 100;
E(1) = 0;
I(1) = n/100;
S(1) = n-I(1);
R(1) = 0;
totalI(1) = I(1); % total infected over time

% number of timesteps
dt = 1;
tend = 500;

reference_beta = beta;
pruned_beta_ss = beta*1.5/3;
for t=2:tend
    beta = pruned_beta_ss; 
    S(t) = S(t-1) - (beta*I(t-1)*S(t-1))*dt*d/n;
    E(t) = E(t-1) + beta*I(t-1)*S(t-1)*dt*d/n - delta*E(t-1)*dt;
    I(t) = I(t-1) + delta*E(t-1)*dt - gamma*I(t-1)*dt;
    totalI(t) = totalI(t-1) + delta*E(t-1)*dt;
    R(t) = 1 - I(t) - S(t) - E(t); 
end

%figure; 
hold on
plot(1+[1:length(totalI)]*dt,totalI/n,'--r','LineWidth',5)
box on;
xlabel('Time'); ylabel('Fraction')
legend('Total Infected')
ylim([0 1.2])
xlim([0 tend*dt])