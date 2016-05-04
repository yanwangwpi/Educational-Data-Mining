function dev = loglike(b,predictor,predicted )
lin = [ones(size(predictor,1),1), predictor]*b;
dev = -sum(log(1+exp(lin)))+lin'*predicted;