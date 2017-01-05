n_patient_per_day=70;%average new patient in the system each day.
new_to_old_ratio=1;
inflation_factor=50;
visit_vec=[];
lag_vec=[];
date_vec=[];

for day=1:300
    
    %repeat visits
    repeat_patients=poissrnd(n_patient_per_day/new_to_old_ratio);
    total=sum(visit_vec);
    
    for iter=1:length(visit_vec)
        R = randsample([1 0],1,true,[(visit_vec(iter))*inflation_factor total-(visit_vec(iter))*inflation_factor]);
        visit_vec(iter)=visit_vec(iter)+R;
        if R==1
            lag_vec=cat(1,lag_vec,day-date_vec(iter));
            date_vec(iter)=day;
        end
        
    end
    
    %add new patients
    new_patients=poissrnd(n_patient_per_day);
    visit_vec_new=ones(new_patients,1);
    date_vec_new=ones(new_patients,1)*day;
    visit_vec=cat(1,visit_vec,visit_vec_new);
    date_vec=cat(1,date_vec,date_vec_new);
    
end


a = unique(visit_vec);
admissions_out = [a,histc(visit_vec(:),a)];

figure(1)
plot(log10(admissions_out(:,1)),log10(admissions_out(:,2)),'ro')
xlabel('Log10 of # of admissions')
ylabel('Log10 of # of Patients')

a = unique(lag_vec);
lag_out = [a,histc(lag_vec(:),a)];

figure(2)
plot(log10(lag_out(:,1)),log10(lag_out(:,2)),'ro')
xlabel('Log10 of # of lag')
ylabel('Log10 of # of Patients')
