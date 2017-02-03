clear all

n_patient_per_day=70;%average new patient in the system each day.
inflation_factor=100;
visit_vec=[];
lag_vec=[];
date_vec=[];

fprob = @(j) tanh(inflation_factor*j);
%fprob = @(j) 2/pi*atan(inflation_factor*pi*j);

for day=1:300
    fprintf ('day %d \r', day)
    %repeat visits
    total=sum(visit_vec);
    lag_list=zeros(1,length(visit_vec));
    
    parfor iter=1:length(visit_vec)
        R = randsample([1 0],1,true,[fprob(visit_vec(iter)/total) 1-fprob(visit_vec(iter))/total]);
        if R==1
            visit_vec(iter)=visit_vec(iter)+1;
            lag_list(iter)=(day-date_vec(iter))*R;
            date_vec(iter)=day;
        end
    end
    
    lag_vec = cat(2,lag_vec,lag_list(lag_list~=0));
    
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
loglog(admissions_out(:,1),admissions_out(:,2),'ro')
xlabel('Number of admissions per patient')
ylabel('Number of Patients with this many admissions')
set(gca,'XTickLabel',num2str(get(gca,'XTick').'))
set(gca,'YTickLabel',num2str(get(gca,'YTick').'))

a = unique(lag_vec);
lag_out = [a',histc(lag_vec(:),a)];

figure(2)
plot(log10(lag_out(:,1)),log10(lag_out(:,2)),'ro')
xlabel('Log10 of # of lag')
ylabel('Log10 of # of Patients')
