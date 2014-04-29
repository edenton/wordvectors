function [idx_final] = getIndicesFromAnalogicalReasoning(sections_picked,N_small)

  load('./generated_mats/analog_question_indices.mat')

  N_sec = 14;
  loc{1}='./qwSections/questions-capital-common-countries.sec';
  loc{2}='./qwSections/questions-capital-world.sec';
  loc{3}='./qwSections/questions-city-in-state.sec';
  loc{4}='./qwSections/questions-currency.sec';
  loc{5}='./qwSections/questions-family.sec';
  loc{6}='./qwSections/questions-gram1-adjective-to-adverb.sec';
  loc{7}='./qwSections/questions-gram2-opposite.sec';
  loc{8}='./qwSections/questions-gram3-comparative.sec';
  loc{9}='./qwSections/questions-gram4-superlative.sec';
  loc{10}='./qwSections/questions-gram5-present-participle.sec';
  loc{11}='./qwSections/questions-gram6-nationality-adjective.sec';
  loc{12}='./qwSections/questions-gram7-past-tense.sec';
  loc{13}='./qwSections/questions-gram8-plural.sec';
  loc{14}='./qwSections/questions-gram9-plural-verbs.sec';


  %randomly pick k of the sections
  %sections_picked = randi(N_sec,k,1);
  %sections_picked = [1];
  %specify sections to pick
  %sections_picked = [1];
  %k=1;

  idx_final = zeros(N_small,1);
  t = 1;

  line_num = 1;
  for i=1:14
     doc = textscan(fopen(loc{i}),'%s %s %s %s'); 
     
     doc_size = max(size(doc{1}));
     all_idx = analog_question_indices(line_num:line_num+doc_size-1,:);
     indices_from_section = unique(all_idx(:));
     line_num = line_num + doc_size;

     if sum(sections_picked==i)==1
        fprintf('Size %d: %d Unique: %d\n',i,max(size(doc{1})),size(indices_from_section,1));
        idx_final(t:t+size(indices_from_section,1)-1) = indices_from_section;
        t = t +size(indices_from_section,1);
     end

  end

  idx_final = idx_final(1:t-1);

end
