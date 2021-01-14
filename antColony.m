clc;
clear all;

file='coordinates.xlsx';
coord=xlsread(file);

   
   [city,~]=size(coord);
   
   best_solution=[];
   best_fitness=10000000;
   
%    parameters 
% --------------------
   NA=100; %number of ants
   i_phe=400; %pheromone value for each cell
   alpha=1; 
   beta=5;
   rho=0.09; %pheromone evaporation coefficient 
   q0=0.5;
   q1=0.3;
   q2=0.2;
   max_iteration=1000;

   iteration=0;
   
   p_matrix=zeros(city,city);
   
   p_matrix=p_matrix+i_phe;
   
   distance=[];
   
   for i=1:city
       for j=1:city
           distance(i,j)=sqrt((coord(i,2)-coord(j,2))^2+(coord(i,3)-coord(j,3))^2);
       end
   end
   
   while iteration<max_iteration
   last_f = best_fitness;
   population=[];
   for i=1:NA
       cities=1:city;
       selected=randi(city);
       population(i,1)=selected;
       cities(selected)=[];
   for j=2:city
       
       prob=[];
       total=0;
       for k=1:length(cities)
            prob(k)=(p_matrix(selected,cities(k)))^alpha*(100/distance(selected,cities(k)))^beta;
            total=total+prob(k);
       end
       prob=prob/total;
       
       r=rand();
       if r<=q0
           [~,indice]=max(prob);
           selected=cities(indice);
           population(i,j)=selected;
           cities(indice)=[];
       elseif r>q0 && r<=q0+q1
           total1=sum(prob);
           n_prob=prob/total1;
           c_prob(1)=n_prob(1);
           for kk=2:length(prob)
               c_prob(kk)=n_prob(kk)+c_prob(kk-1);
           end
           r1=rand();
           for m=1:length(c_prob)
              if c_prob(m)>=r1
                  indice=m;
                  break;
              end
           end
           selected=cities(indice);
           population(i,j)=selected;
           cities(indice)=[];
       elseif r>q0+q1 && r<q0+q1+q2 %else
           indice=randi(length(cities));
           selected=cities(indice);
           population(i,j)=selected;
           cities(indice)=[];
       end
   end
   end
   %population
   
   fitness=[];
   for i=1:NA
       fitness(i)=0;
       
       for j=1:city-1
           fitness(i)=fitness(i)+distance(population(i,j),population(i,j+1));
       end
       fitness(i)=fitness(i)+distance(population(i,city),population(i,1));
       if fitness(i)<best_fitness
           best_solution=population(i,:);
           best_fitness=fitness(i);
       end
   end
   %fitness
   
   p_matrix=p_matrix*(1-rho);
   iteration=iteration+1;
   if best_fitness<last_f
       for i=1:NA
          for j=1:city-1
             p_matrix(population(i,j),population(i,j+1))=p_matrix(population(i,j),population(i,j+1))+1000/fitness(i); 
          end
          p_matrix(population(i,city),population(i,1))=p_matrix(population(i,city),population(i,1))+1000/fitness(i);
       end
       
       fprintf('%d.Iteration\n',iteration);
       fprintf('Best Fitness=%g\n',best_fitness);
       fprintf('Best Solution:\n');

            for i=1:city
                fprintf('%d\t',best_solution(i));
            end
        fprintf('\n');
   end
   end
   
