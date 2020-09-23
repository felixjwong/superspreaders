%% Simulation on an SEIR model on BA and WS random graphs, for Fig. 2E,F
clear all
%close all
tic

n = 1000; % Number of nodes
ws_graph = 0; % 0 for BA, 1 for WS

A = zeros(n,n);
m = 5;
%% Barabasi-Albert graph
A(1:m,1:m) = 1;
for i = 1:m
    A(i,i) = 0;
end
for i = m+1:n
   v = sum(A(1:i,:),2);
   j = 0;
   while j < m
       new_node = find(rand<cumsum(v)/sum(v),1,'first');
       if (A(new_node,i) ~= 1)
           A(new_node,i) = 1;
           A(i,new_node) = 1;
           j = j + 1;
       end
   end
end

correction_factor = 1;
%% Watts-Strogatz graph
if ws_graph
    K = 5;
    beta = 0.5;
    g = WattsStrogatz(n,K,beta);
    A = full(adjacency(g));
    correction_factor = 2;
end

figure; hold on;
NUM_INF = [];
tend = 500;
sum_S = zeros(tend,n);

d = mean(sum(A,2));

for J = 1:100
num_infected = [];
Pe = 0.009*correction_factor; % beta
Pi = 0.2; % delta (1/5 days)
Pr = 0.0667; % gamma
S(1,:) = zeros(1,n);
init = 0;
while init < n/100
    ix = rand;
    if S(1,floor(ix*n)+1) ~=2
        S(1,floor(ix*n)+1) = 2; % Seed the initial infected
        init = init + 1;
    end
end
num_infected(1) = n/100;
allA{1} = A;
% States: 0, susceptible, 1, exposed, 2, infected, 3 recovered

this_A = A;
deg_dist = sum(A,2);
sspreaders = find(deg_dist>10);

for t = 2:tend
    S(t-1,sspreaders) = 3; % Superspreaders are removed
    exposed = [];
    infected = [];
    recovered = [];
    for i = 1:n
        if S(t-1,i) == 1 % Exposed
            if rand < Pi
                infected = [infected i];
            end
        end

        if S(t-1,i) == 2 % Infected
            if rand < Pr
                recovered = [recovered i];

            end
            for j = 1:n
                if this_A(i,j) && (S(t-1,j) == 0) % Connected and susceptible
                    if rand < Pe
                        exposed = [exposed j];
                    end
                end
            end
        end
    end
    
    S(t,:) = S(t-1,:);
    S(t,exposed) = 1;
    S(t,infected) = 2;
    S(t,recovered) = 3;
    num_infected(t) = length(infected);
    allA{t} = this_A;
end

plot(cumsum(num_infected)/n)
NUM_INF(:,J) = cumsum(num_infected)/n;
sum_S = sum_S + S;
end

plot(mean(NUM_INF,2),'g','LineWidth',5)
ylim([0 1.2])

%% Plot evolution of graph
figure; 
time = [1 45 52 60 150 200];
for i = 1:6
    G = graph(allA{time(i)});
    subplot(1,6,i)
    h = plot(G,'NodeLabel',{});
    highlight(h,find(S(time(i),:)==0),'NodeColor','k')
    highlight(h,find(S(time(i),:)==1),'NodeColor','r')
    highlight(h,find(S(time(i),:)==2),'NodeColor','g')
    highlight(h,find(S(time(i),:)==3),'NodeColor','b')
end