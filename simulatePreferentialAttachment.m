n_patient_per_day=70;%average new patient in the system each day.
new_to_old_ratio=1;
inflation_factor=50;
visit_vec=[];

for days=1:300
    
    %repeat visits
    repeat_patients=poissrnd(n_patient_per_day/new_to_old_ratio);
    total=sum(visit_vec);
    
    for iter=1:length(visit_vec)
        R = randsample([1 0],1,true,[(visit_vec(iter))*fudge_factor total-(visit_vec(iter))*fudge_factor]);
        visit_vec(iter)=visit_vec(iter)+R;
    end
    
    %add new patients
    new_patients=poissrnd(n_patient_per_day);
    visit_vec_new=ones(new_patients,1);
    visit_vec=cat(1,visit_vec,visit_vec_new);
    
    
end


a = unique(visit_vec);
out = [a,histc(visit_vec(:),a)];

plot(log(out(:,1)),log(out(:,2)),'ro')