warning('off', 'all');
source('./susceptibility.m');

data_by_susceptibility = {"hs";"ms";"ls"};

% Store all data across all susceptibility levels
sus_PRR_all = zeros(3, 3, 10000);
sus_PRR_per_pert = zeros(3, 3);
sus_mean_diff = zeros(3, 1);
sus_utility = zeros(3, 5);
for i = 1:3
    load(['sensitivity_analysis_' data_by_susceptibility{i}  '.mat']);
    sus_mean_diff(i) = mean_diff;
    sus_PRR_all(i, :, :) = PRR_all;
    sus_PRR_per_pert(i, :) = PRR_per_pert;
    sus_utility(i, :) = utility;
end


% Combine all line charts together by pertubation level
for si = 1:size(s,1)
    figure;
    for i = 1:3
        [susceptibility_lvl, susceptibility_lvl_full, susceptibility_chart_color] = susceptibility(sus_mean_diff(i));
        semilogx(1:ntimes, sus_PRR_all(i, si, :), 'LineWidth', 1, 'Color', susceptibility_chart_color);
        hold on;
    end
    hold off;
    legend([sprintf('High susceptability\nAverage Utility Difference = '), num2str(sus_mean_diff(1) * 100)(1:4), '%'],
            [sprintf('Medium susceptability\nAverage Utility Difference = '), num2str(sus_mean_diff(2) * 100)(1:4), '%'],
            [sprintf('Low susceptability\nAverage Utility Difference = '), num2str(sus_mean_diff(3) * 100)(1:4), '%'],
            'Location', 'northwest', 'FontSize', 5);
    xlabel('Iterations');
    ylabel('Probability of Ranking Reversal (PRR)');
    title(['PRR per Iteration for Perturbation Level: ', num2str(s{si})]);

    print(['./charts/all_PRR_per_Iteration_PertLvl_', num2str(s{si}), '.jpg'], '-djpg', "-r600");
    close;
end


% Combine all bar charts together by pertubation level
figure;
b = bar(cell2mat(s), flipud(sus_PRR_per_pert));
legend(
        [sprintf('Low susceptability\nAverage Utility Difference = '), num2str(sus_mean_diff(3) * 100)(1:4), '%'],
        [sprintf('Medium susceptability\nAverage Utility Difference = '), num2str(sus_mean_diff(2) * 100)(1:4), '%'],
        [sprintf('High susceptability\nAverage Utility Difference = '), num2str(sus_mean_diff(1) * 100)(1:4), '%'],
        'FontSize', 5);

%Set the colors of the bars
for i = 1:3
    [susceptibility_lvl, susceptibility_lvl_full, susceptibility_chart_color] = susceptibility(sus_mean_diff(4-i));
    set(b(i), 'FaceColor', susceptibility_chart_color);
end

xlabel('Perturbation Level');
ylabel('Probability of Ranking Reversal (PRR)');
title('PRR for each Perturbation Level');
print(['./charts/all_PRR_per_Perturbation_Level.jpg'], '-djpg', "-r600");
close;

% Generate errorbars for the utility with the added perturbation error for each susceptibility level
for pert_lvl = 1:3
    x = 1:5;
    figure;
    error = zeros(1, size(sus_utility, 2));
    for i = 1:3
        [susceptibility_lvl, susceptibility_lvl_full, susceptibility_chart_color] = susceptibility(sus_mean_diff(i));
        for j = 1:5
            % Calculate the error for each alternative
            error(j) = sus_utility(i, j) * sus_PRR_per_pert(pert_lvl, 4-i) * 0.5;
        end

        xv = x + 0.1 * (i - 2);
        eb = errorbar(xv, sus_utility(i, :), error, 'o');
        set(eb, 'MarkerFaceColor', susceptibility_chart_color, 'MarkerSize', 4, 'Color', susceptibility_chart_color);
        hold on;
    end
    legend(
            [sprintf('High susceptability\nAverage Utility Difference = '), num2str(sus_mean_diff(1) * 100)(1:4), '%'],
            [sprintf('Medium susceptability\nAverage Utility Difference = '), num2str(sus_mean_diff(2) * 100)(1:4), '%'],
            [sprintf('Low susceptability\nAverage Utility Difference = '), num2str(sus_mean_diff(3) * 100)(1:4), '%'],
            'Location', 'northwest', 'FontSize', 5);
    xlabel('Alternatives');
    ylabel('Utility');
    title(['Alternatives Utility with Perturbation Error with Perturbation Level: ', num2str(s{4-pert_lvl})]);
    print(['./charts/Alternatives_Utility_PertLvl_', num2str(s{4-pert_lvl}), '.jpg'], '-djpg', "-r600");
    close;
end
