function data = data_process_get_covariant(data_new,opp)

i_skill = 1;
i_student = 2;
i_oc= 3;
i_correct = 4;
i_cross =5;

index = data_new(:,i_oc)==opp;
data_new = data_new(index,:);

num = size(data_new,1);

% Covariate for student
students = unique(data_new(:,i_student));
num_students = length(students);
student_covariant = ones(num,1)*nan;
for id_student = 1:num_students
    index = data_new(:,i_student)==students(id_student);
    subdata = data_new(index,:);
    student_covariant(index) = nanmean(subdata(:,i_correct));

end

% Covariate for skill
skills = unique(data_new(:,i_skill));
num_skills = length(skills);
skill_covariant = ones(num,1)*nan;
for id_skill = 1:num_skills
    index = data_new(:,i_skill)==skills(id_skill);
    subdata = data_new(index,:);
    skill_covariant(index) = nanmean(subdata(:,i_correct));
end

data = [data_new(:,[i_skill,i_student]),skill_covariant,student_covariant,data_new(:,[i_correct,i_cross])];
