load study_results.mat;
source('./rankinversion.m');
source('./smart_perturbation.m');
source('./susceptibility.m');

% Determine the difference between the utility values
mean_diff = mean(abs(diff(utility)));
disp(['The mean difference between the simulation utility values is: ', num2str(mean_diff)]);

% Susceptibility to perturbations
[susceptibility_lvl, susceptibility_lvl_full, susceptibility_chart_color] = susceptibility(mean_diff);

s = {0.1; 0.2; 0.6}; %perturbations levels
ntimes = 10^2;

PRR_per_pert = zeros(length(s),1);
PRR_all = zeros(length(s), ntimes);
for si = 1:length(s)
    pert_lvl = s{si};
    disp(['Perturbation level: ', num2str(pert_lvl)]);

    NPRR = zeros(1,ntimes); %initialization of the matrix of RR for each iteration

    %initialization of the new weights.We initialize the weights with old ones
    criteria_weights_n = criteria_weights; %initialization of weights criteria
    alternatives_weights_n = alternatives_weights; %initialization of alternatives relative importance for each factor

    scores_alt = ones(ntimes, criteria_size, alternatives_size);
    utilities = ones(ntimes, alternatives_size);

    %MC simulation for ntimes iterations
    NPRR_sum = 0;
    for iter = 1:ntimes

        if mod(iter, 1000) == 0
            disp(['Iteration: ', num2str(iter)]);
        end

        %Criteria matrix perturbation
        for m = 1:experts
            [criteria_weights_n(:,m)] = perturb_criteria(criteria_evaluations(:, m), pert_lvl); %perturbed matrix of criteria

            for i = 1:criteria_size
                alternatives_weights_n(:,i,m) = perturb_criteria(alternatives_criteria(:, i, m), pert_lvl); %perturbed matrix of criteria
            end
        end

        % Calculate score matrix
        for i=1:criteria_size
            for j=1:alternatives_size
                scores_alt(iter, i, j) = max(alternatives_weights_n(j,i,:));
            end
        end

        % Calculate utility matrix
        for j=1:alternatives_size
            usum = 0;
            for i=1:criteria_size
                mean_weight = mean(criteria_weights_n(i,:));
                usum += sum(mean_weight * mean(scores_alt(iter,i,j)));
            end
            utilities(iter, j) = usum;
        end

        NPRR(iter) = rankinversion(utility, utilities(iter,:)); %RR of alternatives priorities for each iteation
        NPRR_sum += NPRR(iter);
        PRR_all(si, iter) = NPRR_sum/iter;
    end
    PRR_per_pert(si) = NPRR_sum/ntimes;
end

disp('Simulation Utility:');
disp(utility);
disp('The PRR for each perturbation level is:');
disp([flipud(cell2mat(s)), PRR_per_pert]);

fileName = ['project_sensitivity_', susceptibility_lvl, '.mat'];

save(fileName, 's', 'mean_diff', 'ntimes', 'utility', 'PRR_per_pert', 'PRR_all');