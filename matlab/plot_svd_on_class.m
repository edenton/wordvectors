classes = {'animal', 'country', 'emotion', 'flower', 'food', 'fruit', 'languages', 'plant', 'sports', 'vegetable', 'vehicle'};

all_errors = zeros(length(classes), 300);
for c = 1 : length(classes)
    class = classes{c};
    [errors, X] = svd_on_class(class);
    all_errors(c, 1:length(errors)) = errors;
end
    
cols = [1, 0, 0;
          0, 1, 0;
          0, 0, 1;
          0.5, 0.5, 0;
          0, 0.5, 0.5;
          0.5, 0, 0.5;
          0.75, 0.25, 0;
          0, 0.75, 0.25;
          0.25, 0, 0.75;
          0.75, 0, 0.25;
          0, 0.25, 0.75;
          0.25, 0.75, 0;
          0.5, 0, 0];

figure(1); hold on;
for c = 1 : length(classes)
    plot(1:300, all_errors(c, :), 'linewidth', 2, 'color', cols(c, :));
end
legend('animal (4252)', ...
       'country (253)',...
       'emotion (391)', ...
       'flower (179)', ...
       'food (3966)', ...
       'fruit (467)', ...
       'languages (2101)',... 
       'plant (2347)', ...
       'sports (234)', ...
       'vegetable (297)',...
       'vehicle (991)');
   
title('Approximation error for varying rank', 'FontSize', 15, 'FontName', 'TimesNewRoman', 'FontWeight', 'bold');
ylabel('L2 approximation error', 'FontSize', 15, 'FontName', 'TimesNewRoman', 'FontWeight', 'bold');
xlabel('Rank of approximation', 'FontSize', 15, 'FontName', 'TimesNewRoman', 'FontWeight', 'bold');