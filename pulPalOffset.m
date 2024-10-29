TTL1_ON = events.timestamp(events.state == 1 & events.line == 1);
TTL2_ON = events.timestamp(events.state == 1 & events.line == 2);

figure(201); clf
scatter(TTL1_ON, ones(length(TTL1_ON), 1), '.')
hold on
scatter(TTL2_ON, 2*ones(length(TTL2_ON), 1), '.')


delay = TTL2_ON(1:50:end) - TTL1_ON;

figure(202); clf
histogram(delay, 20)