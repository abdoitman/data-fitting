clc;
format short g
%%% Taking inputs %%%

fprintf('Please enter your data in a vector form (within 2 brackets)\n\n');
x = input("Enter X in order (from X1 to Xn): ");
y = input("Enter Y in order (from Y1 to Yn): ");

%%% Error Checking %%%

cond = 1;
while cond == 1
    if length(x) ~= length(y)
        fprintf('\nMissing data!\n');
        
        fprintf('X= [ ');
        fprintf('%g ',x);
        fprintf(']\n');
        fprintf('Y= [ ');
        fprintf('%g ',y);
        fprintf(']\n\n');
        
        fprintf('Please re-enter your data in a vector form (within 2 brackets)\n\n');
        x = input("Enter X in order (from X1 to Xn): ");
        y = input("Enter Y in order (from Y1 to Yn): ");
    else
        cond = 0;
    end
end

%%% Preparing Data %%%

%x_per = x;
x_per = linspace(min(x),max(x),1000);  %to be used as x-axis values later
                             %we add much more points to refine the line drawn
n = length(x);
sum_x = sum(x);
sum_x_2 = sum(x.^2);
sum_y = sum(y);
sum_xy = sum(x.*y);
A = [];

%%% Plotting Data %%%

plot(x,y,'o');
hold on;

%%% Choosing the fit to apply %%%

choice = input('Choose the model to fit your data:\n1)Linear Model\n2)Exponential Model\n3)Power Model\n4)Growth Rate Model\n');
switch choice
    case 1
        %%% Linear Regression %%%

        A = [sum_y sum_xy]/[n sum_x;sum_x sum_x_2];
        Y = A(1) + A(2).*x_per;
        plot(x_per,Y);
        title('Linear Model');
        
        fprintf('\nEquation is Y=(%.4f)+(%.4f)X',A(1),A(2));
        
    case 2
        %%% Exponential Model %%%
        
        y = log(y);
        n = length(x);
        sum_x = sum(x);
        sum_x_2 = sum(x.^2);
        sum_y = sum(y);
        sum_xy = sum(x.*y);
        
        A = [sum_y sum_xy]/[n sum_x;sum_x sum_x_2];
        a = exp(A(1));
        b = A(2);
        Y = a * exp(b*x_per);
        plot(x_per,Y);
        title('Exponential Model');
        fprintf('\nEquation is Y=(%.4f).e^(%.4fX)',a,b);
        
    case 3
        %%% Power Model %%%
        
        x = log10(x);
        y = log10(y);
        n = length(x);
        sum_x = sum(x);
        sum_x_2 = sum(x.^2);
        sum_y = sum(y);
        sum_xy = sum(x.*y);
        
        A = [sum_y sum_xy]/[n sum_x;sum_x sum_x_2];
        a = 10^(A(1));
        b = A(2);
        Y = a * (x_per.^b);
        plot(x_per,Y);
        title('Power Model');
        fprintf('\nEquation is Y=(%.4f).X^(%.4f)',a,b);
        
    case 4
        %%% Growth Rate Model %%%
        
        x = 1./x;
        y = 1./y;
        n = length(x);
        sum_x = sum(x);
        sum_x_2 = sum(x.^2);
        sum_y = sum(y);
        sum_xy = sum(x.*y);
        
        A = [sum_y sum_xy]/[n sum_x;sum_x sum_x_2];
        a = 1/A(1);
        b = A(2)*a;
        Y = (a * x_per)./(x_per + b);
        plot(x_per,Y);
        title('Growth Rate Model');
        fprintf('\nEquation is Y=%.4fX/(%.4f)+X',a,b);
        
    otherwise
        fprintf('Not Valid!\n');
        return;
        
end

St = sum( ( y - sum_y/n ).^2 );
Sr = sum( ( y - A(1) - A(2).*x ) .^2 );
r = sqrt( (St-Sr)/St ) * 100; %correlation coefficient

Sy = sqrt( St/(n-1) );  %Std of the data
Sy_x = sqrt( Sr/(n-2) ); %Std of the error

fprintf('\nCorrelation coefficient (r) = %.4f%%\n' ,r);
fprintf('Squared error (Sr) = %.4f\n' ,Sr);
fprintf('Squared error with mean (St) = %.4f\n' ,St);
fprintf('Standard deviation of the data (Sy) = %.4f\n',Sy);
fprintf('Standard error of estimate (Sy/x) = %.4f\n',Sy_x);