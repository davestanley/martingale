


% mcc -R -singleCompThread -mv -o martingale_sim martingale_sim.m -R -nodisplay   % (For serial)
%% Betting algorithm
clear

get_user_input = 1;

if get_user_input
    % Get starting value of bank
    prompt = 'Welcome to  stanley casino. How much money did you bring? (starting size of bank) ';
    returns = input(prompt,'s');
    bank = str2num(returns);


    % Max turns
    prompt = 'Maximum number of turns? (Inf for unlimited)';
    returns = input(prompt,'s');
    max_turns = str2num(returns);

    % Autoplay mode
    prompt = 'Autoplay martingale mode? (y/n)';
    returns = input(prompt,'s');
    autoplay = returns;
else
    bank=10000;
    max_turns = 1000;
    autoplay = 'y';
    
end

% Initialize histories
earnings = 0;
bank_hist = bank;
earnings_hist = earnings;


do_continue = 1;
Nplays = 0;
autobet0 = 1;               % Starting bet for autobet mode.
bet_predict = autobet0;

while do_continue
    %autobet0 = bank*0.01;
    Nplays = Nplays + 1;
    
    if strcmp(autoplay,'n');
        % Get user's bet
        prompt = ['Balance = ' num2str(bank) '. Enter your bet, or press q to quit: '];
        returns = input(prompt,'s');
        if strcmp(returns,'q'); do_continue = 0;
        end
        bet=str2num(returns);
    else
        prompt = ['Balance = ' num2str(bank) '. Enter your bet, or press q to quit: '];
        fprintf(prompt);
        bet=bet_predict;
        fprintf([num2str(bet) '\n']);
    end
    
    
    
    if randn(1,1) > 0
        fprintf('You won \n');
        winnings = bet;
        bet_predict = autobet0;
    else
        fprintf('You lost \n');
        winnings = -1*bet;
        bet_predict = bet*2;
    end
    
    % Update bank, recording histories
    bank = bank + winnings;
    earnings = earnings + winnings;
    
    bank_hist = [bank_hist bank];
    earnings_hist = [earnings_hist earnings];
    
    if bank <= 0; fprintf('You are out of money!'); do_continue = 0; end
    if Nplays > max_turns; fprintf('Out of turns. Simulation ended.'); do_continue = 0; end
    
end

figure('visible','off');
if any(isinf(bank_hist))
    plot(0:Nplays,earnings_hist);xlabel('Turn number'); ylabel('Net earnings');
else
    plot(0:Nplays,bank_hist);xlabel('Turn number'); ylabel('Bank account');
end

saveas(gcf,'figure1','png')




