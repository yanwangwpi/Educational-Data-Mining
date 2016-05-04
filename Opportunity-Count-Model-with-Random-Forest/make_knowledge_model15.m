function bnet = make_knowledge_model15()
% number of nodes
N = 32;

% variable names for the knowledge nodes (latent) and their node numbers

K1=1;
K2=2;
K3=3;
K4=4;
K5=5;
K6=6;
K7=7;
K8=8;
K9=9;
K10=10;
K11=11;
K12=12;
K13=13;
K14=14;
K15=15;
K16=16;

% variable names for the question nodes (observable) and their node numbers

Q1=16+1;
Q2=17+1;
Q3=18+1;
Q4=19+1;
Q5=20+1;
Q6=21+1;
Q7=22+1;
Q8=23+1;
Q9=24+1;
Q10=25+1;
Q11=26+1;
Q12=27+1;
Q13=28+1;
Q14=29+1;
Q15=30+1;
Q16=31+1;

% topology is defined in a directed acyclic graph
dag = zeros(N,N);

dag(K1,K2) = 1;
dag(K2,K3) = 1;
dag(K3,K4) = 1;
dag(K4,K5) = 1;
dag(K5,K6) = 1;
dag(K6,K7) = 1;
dag(K7,K8) = 1;
dag(K8,K9) = 1;
dag(K9,K10) = 1;
dag(K10,K11) = 1;
dag(K11,K12) = 1;
dag(K12,K13) = 1;
dag(K13,K14) = 1;
dag(K14,K15) = 1;
dag(K15,K16) = 1;

dag(K1,Q1) = 1;
dag(K2,Q2) = 1;
dag(K3,Q3) = 1;
dag(K4,Q4) = 1;
dag(K5,Q5) = 1;
dag(K6,Q6) = 1;
dag(K7,Q7) = 1;
dag(K8,Q8) = 1;
dag(K9,Q9) = 1;
dag(K10,Q10) = 1;
dag(K11,Q11) = 1;
dag(K12,Q12) = 1;
dag(K13,Q13) = 1;
dag(K14,Q14) = 1;
dag(K15,Q15) = 1;
dag(K16,Q16) = 1;
% equivalence classes specify which nodes share a single CPT
eclass = zeros(1,N);

% K1 gets a separate eclass because it has no parent (different CPT dimension)
% K1 CPT contains the prior probability
eclass(K1) = 1;

% all the other knowledge nodes share the same transition probabilities
eclass([K2 K3 K4 K5 K6 K7 K8 K9 K10 K11 K12 K13 K14 K15 K16]) = 2;

% all question nodes share the same emission probabilities
eclass([Q1 Q2 Q3 Q4 Q5 Q6 Q7 Q8 Q9 Q10 Q11 Q12 Q13 Q14 Q15 Q16]) = 3;

% observed variables
obs = 17:32;

% all nodes modeled as binary variables
node_sizes = 2*ones(1,N);

% all nodes are discrete variables
discrete_nodes = 1:N;

bnet = mk_bnet(dag,node_sizes,'discrete',discrete_nodes,'observed',obs,'equiv_class',eclass);

