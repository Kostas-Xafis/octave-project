source('./susceptibility.m');

data_by_susceptibility = {"hs";"ms";"ls"};

% Store all data across all susceptibility levels
sus_PRR_all = zeros(3, 3, 10000);
sus_PRR_per_pert = zeros(3, 3);
sus_mean_diff = zeros(3, 1);
for i = 1:3
    load(['project_sensitivity_' data_by_susceptibility{i}  '.mat']);
    sus_mean_diff(i) = mean_diff;
    sus_PRR_all(i, :, :) = PRR_all;
    sus_PRR_per_pert(i, :) = PRR_per_pert;

    % Generate each line and bar chart individually
    % [susceptibility_lvl, susceptibility_lvl_full, susceptibility_chart_color] = susceptibility(mean_diff);

    % for si = 1:size(s,1)
    %     figure;
    %     semilogx(1:ntimes, PRR_all(si, :), 'LineWidth', 1, 'Color', susceptibility_chart_color);
    %     xlabel('Iterations');
    %     ylabel('Probability of Ranking Reversal (PRR)');
    %     title(['PRR per Iteration for Perturbation Level: ', num2str(s(si)), "\nw/ ", susceptibility_lvl_full]);

    %     print(['./charts/PRR_per_Iteration_PertLvl_', num2str(s(si)), '_', susceptibility_lvl, '.jpg'], '-djpg', "-r400");
    %     close;
    % end
    % disp('The PRR for each perturbation level is:');
    % disp([s, PRR_per_pert]);

    % figure;
    % bar(s, PRR_per_pert, 'FaceColor', susceptibility_chart_color);
    % xlabel('Perturbation Level');
    % ylabel('Probability of Ranking Reversal (PRR)');
    % title('PRR for Each Perturbation Level w/ Large utility differences');
    % print(['./charts/PRR_per_Perturbation_Level_', susceptibility_lvl,'.jpg'], '-djpg', "-r400");
    % close;
end


% Combine all line charts together by pertubation level
% for si = 1:size(s,1)
%     figure;
%     for i = 1:3
%         [susceptibility_lvl, susceptibility_lvl_full, susceptibility_chart_color] = susceptibility(sus_mean_diff(i));
%         semilogx(1:ntimes, sus_PRR_all(i, si, :), 'LineWidth', 1, 'Color', susceptibility_chart_color);
%         hold on;
%     end
%     hold off;
%     legend([sprintf('High susceptability\nAverage Utility Difference = '), num2str(sus_mean_diff(1) * 100)(1:4), '%'],
%             [sprintf('Medium susceptability\nAverage Utility Difference = '), num2str(sus_mean_diff(2) * 100)(1:4), '%'],
%             [sprintf('Low susceptability\nAverage Utility Difference = '), num2str(sus_mean_diff(3) * 100)(1:4), '%'],
%             'Location', 'northwest', 'FontSize', 5);
%     xlabel('Iterations');
%     ylabel('Probability of Ranking Reversal (PRR)');
%     title(['PRR per Iteration for Perturbation Level: ', num2str(s(si))]);

%     print(['./charts/all_PRR_per_Iteration_PertLvl_', num2str(s(si)), '.jpg'], '-djpg', "-r600");
%     close;
% end

% Combine all bar charts together by pertubation level
figure;
b = bar(s, flipud(sus_PRR_per_pert));
legend([sprintf('Low susceptability\nAverage Utility Difference = '), num2str(sus_mean_diff(3) * 100)(1:4), '%'],
        [sprintf('Medium susceptability\nAverage Utility Difference = '), num2str(sus_mean_diff(2) * 100)(1:4), '%'],
        [sprintf('High susceptability\nAverage Utility Difference = '), num2str(sus_mean_diff(1) * 100)(1:4), '%'],
        'FontSize', 5);

%Set the colors of the bars
for i = 3:-1:1
    [susceptibility_lvl, susceptibility_lvl_full, susceptibility_chart_color] = susceptibility(sus_mean_diff(i));
    set(b(4-i), 'FaceColor', susceptibility_chart_color);
end

xlabel('Perturbation Level');
ylabel('Probability of Ranking Reversal (PRR)');
title('PRR for each Perturbation Level');
print(['./charts/all_PRR_per_Perturbation_Level.jpg'], '-djpg', "-r600");
close;