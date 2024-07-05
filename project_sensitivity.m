load study_results.mat;
source('./rankinversion.m');
source('./smart_perturbation.m');

s = [0.1;0.2;0.6]; %perturbations +-10%;
ntimes = 10^4;

PRR_per_pert = zeros(size(s,1),1);
for si = 1:size(s,1)
    pert_lvl = s(si);
    disp(['Perturbation level: ', num2str(pert_lvl)]);

    NPRR = zeros(1,ntimes); %initialization of the matrix of RR for each iteration

    %initialization of the new weights.We initialize the weights with old ones
    criteria_weights_n = criteria_weights; %initialization of weights criteria
    alternatives_weights_n = alternatives_weights; %initialization of alternatives relative importance for each factor

    scores_alt = ones(ntimes, criteria_size, alternatives_size);
    utilities = ones(ntimes, alternatives_size);

    %MC simulation for ntimes iterations
    for iter = 1:ntimes

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
    end

    PRR = sum(NPRR)/ntimes;


    % disp('The utility for each iteration is:');
    % disp(utilities);
    % disp('Simulation Utility:');
    % disp(utility);
    disp(['The PRR is: ', num2str(PRR)]);

    PRR_per_pert(si) = PRR;

    % Create and save the PRR vs. number of samples chart
    NPRR_per_iter = zeros(1,ntimes);
    for i = 1:ntimes
        NPRR_per_iter(i) = sum(NPRR(1:i))/i;
    end
    
    figure;
    plot(1:ntimes, NPRR_per_iter, 'LineWidth', 2);
    xlabel('Number of Samples');
    ylabel('PRR Value');
    title(['PRR vs. Number of Samples for Perturbation Level w/ Large utility differences', num2str(pert_lvl)]);
    print(['./charts/PRR_vs_Samples_PertLvl_', num2str(pert_lvl), '.png'], '-dpng');
    close;

end

disp('Simulation Utility:');
disp(utility);
% Calculate the mean difference the simulation utility values
mean_diff = mean(abs(diff(utility)));
disp(['The mean difference between the simulation utility values is: ', num2str(mean_diff)]);

disp('The PRR for each perturbation level is:');
disp([s, PRR_per_pert]);


figure;
bar(s, PRR_per_pert);
xlabel('Perturbation Level');
ylabel('PRR Value');
title('PRR for Each Perturbation Level w/ Large utility differences');
print('./charts/PRR_per_Perturbation_Level.png', '-dpng');
close;


% save project_sensitivity_large_diff.mat