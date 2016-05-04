function bnet = make_knowledge_model()
% number of nodes
N = 12;

% variable names for the knowledge nodes (latent) and their node numbers

% K1=1;
% K2=2;
% K3=3;
% K4=4;
% K5=5;
% K6=6;
% K7=7;
% K8=8;
% K9=9;
% K10=10;
K1=1;
K2=2;
K3=3;
K4=4;
K5=5;
K6=6;



% variable names for the question nodes (observable) and their node numbers

% Q1=11;
% Q2=12;
% Q3=13;
% Q4=14;
% Q5=15;
% Q6=16;
% Q7=17;
% Q8=18;
% Q9=19;
% Q10=20;
Q1=7;
Q2=8;
Q3=9;
Q4=10;
Q5=11;
Q6=12;



% topology is defined in a directed acyclic graph
dag = zeros(N,N);

% dag(K1,K2) = 1;
% dag(K2,K3) = 1;
% dag(K3,K4) = 1;
% dag(K4,K5) = 1;
% dag(K5,K6) = 1;
% dag(K6,K7) = 1;
% dag(K7,K8) = 1;
% dag(K8,K9) = 1;
% dag(K9,K10) = 1;
% 
% dag(K1,Q1) = 1;
% dag(K2,Q2) = 1;
% dag(K3,Q3) = 1;
% dag(K4,Q4) = 1;
% dag(K5,Q5) = 1;
% dag(K6,Q6) = 1;
% dag(K7,Q7) = 1;
% dag(K8,Q8) = 1;
% dag(K9,Q9) = 1;
% dag(K10,Q10) = 1;

dag(K1,K2) = 1;
dag(K2,K3) = 1;
dag(K3,K4) = 1;
dag(K4,K5) = 1;
dag(K5,K6) = 1;

dag(K1,Q1) = 1;
dag(K2,Q2) = 1;
dag(K3,Q3) = 1;
dag(K4,Q4) = 1;
dag(K5,Q5) = 1;
dag(K6,Q6) = 1;


% equivalence classes specify which nodes share a single CPT
eclass = zeros(1,N);

% K1 gets a separate eclass because it has no parent (different CPT dimension)
% K1 CPT contains the prior probability
eclass(K1) = 1;

% all the other knowledge nodes share the same transition probabilities
% eclass([K2 K3 K4 K5 K6 K7 K8 K9 K10]) = 2;
eclass([K2 K3 K4 K5 K6]) = 2;
% all question nodes share the same emission probabilities
% eclass([Q1 Q2 Q3 Q4 Q5 Q6 Q7 Q8 Q9 Q10]) = 3;
eclass([Q1 Q2 Q3 Q4 Q5 Q6]) = 3;

% observed variables
% obs = 11:20;
obs = 7:12;
% all nodes modeled as binary variables
node_sizes = 2*ones(1,N);

% all nodes are discrete variables
discrete_nodes = 1:N;

bnet = mk_bnet(dag,node_sizes,'discrete',discrete_nodes,'observed',obs,'equiv_class',eclass);

