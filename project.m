source('./populate_criteria.m');
source('./map.m');
source('./display_as_percentages.m');
% Hard drive criterias and alternatives
criteria = {"Price", "Capacity", "Speed", "Reliability", "Warranty", "Failure Rate", "Brand", "Noise", "Design", "Power Consumption"};
alternatives = {"Product_A", "Product_B", "Product_C", "Product_D", "Product_E"};

experts=15; %number of experts
criteria_size=size(criteria)(2); %number of criteria
alternatives_size=size(alternatives)(2); %number of alternatives

criteria_evaluations=ones(criteria_size, experts); %initialize the PWC matrix of criteria
alternatives_criteria=ones(alternatives_size, criteria_size, experts); %initialize PWC of alternatives relative importance for each factor

for m=1:experts
    disp(['Expert ', num2str(m)]);
    criteria_evaluations(:,m) = map(populate_criteria(criteria_size), 0, 1, 10, 100);

    for i=1:criteria_size
        alternatives_criteria(:,i,m)= map(populate_criteria(alternatives_size), 0, 1, 10, 100);
    end
end

% disp("Criteria Evaluations");
% disp(criteria_evaluations);
% disp("Alternatives relative importance for each factor Matrix");
% disp(alternatives_criteria);


criteria_weights = zeros(criteria_size, experts);% initialize the matrix of criteria weights - wk (m)
alternatives_weights = zeros(alternatives_size, criteria_size, experts); %initialize the matrix of alternatives relative importance for each factor - Rijk (m)

for m=1:experts
    csum = sum(criteria_evaluations(:,m));
    for i=1:criteria_size
        criteria_weights(i,m) = criteria_evaluations(i,m) / csum;
    end
    for i=1:alternatives_size
        for j=1:criteria_size
            alternatives_weights(i,j,m) = alternatives_criteria(i,j,m) / sum(alternatives_criteria(:,j,m));
        end
    end
end

% disp("Weights of criteria");
% disp(criteria_weights);

% disp("Relative importance of alternatives for each factor");
% disp(alternatives_weights);


% Calculate score matrix
score_alt = ones(criteria_size, alternatives_size);

for i=1:criteria_size
    for j=1:alternatives_size
        score_alt(i,j) = max(alternatives_weights(j,i,:));
    end
end

% disp("Score matrix for alternatives");
% disp(score_alt);

% Calculate utility matrix
utility = ones(1, alternatives_size);

for j=1:alternatives_size
    usum = 0;
    for i=1:criteria_size
        mean_weight = mean(criteria_weights(i,:));
        usum += sum(mean_weight * mean(score_alt(i,j)));
    end
    utility(1, j) = usum;
end

disp("Utility of alternatives");
display_as_percentages(utility);

mean_diff = mean(abs(diff(utility)));
disp(['The mean difference between the simulation utility values is: ', num2str(mean_diff)]);

save study_results.mat;