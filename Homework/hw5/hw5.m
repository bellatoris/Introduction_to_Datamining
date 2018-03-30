clear

basket = zeros(20,20);

for i = 1:20
    for j = 1:20
        if mod(j,i) == 0
            basket(j,i) = 1;
        end
    end
end

support = sum(basket);
a = support >= 3;

pairs = zeros(20,20);
for i = 1:20
    for j = 1:20
        for k = 1:20
            if (basket(i,j) == 1) && (basket(i,k) == 1) && (j > k)
                pairs(j,k) = pairs(j,k) + 1;
                %pairs(k,j) = pairs(k,j) + 1;
            end
        end
    end
end

for i = 1:20
    pairs(i,i) = 0;
end

b = pairs >= 3;

%pcy

basket2 = zeros(12,6);
for i = 1:4
    for j = 0:2
        basket2(i, i + j) = 1;
    end
end

for i = 5:6
    for j = 0:2:4
        basket2(i, i + j - 4) = 1;
    end
end

for i = 7:9
    for j = 0:2:2
        basket2(i, i + j - 6) = 1;
    end
end

for i = 7:9
    for j = 3
        basket2(i, i + j - 6) = 1;
    end
end

for i = 10:12
    for j = 0:1
        basket2(i, i + j - 9) = 1;
    end
end

for i = 10:12
    for j = 3
        basket2(i, i + j - 9) = 1;
    end
end


support2 = sum(basket2);

pairs2 = zeros(6,6);
for i = 1:12
    for j = 1:6
        for k = 1:6
            if (basket2(i,j) == 1) && (basket2(i,k) == 1) && (j > k)
                pairs2(j,k) = pairs2(j,k) + 1;
                %pairs(k,j) = pairs(k,j) + 1;
            end
        end
    end
end

index = zeros(6,6);
hash = zeros(1, 11);
for i = 1:6
    for j = 1:6
        if i < j
            index(j,i) = mod(i*j, 11);
            hash(mod(i*j,11)) = hash(mod(i*j,11)) + pairs2(j,i);
        end
    end
end

c = hash >= 4;


candidate = zeros(6,6);
for i = 1:6
    for j = 1:6
        if i < j
            if c(mod(i*j, 11)) == 1 && support2(i) >= 4 && support2(j) >= 4
                candidate(j, i) = 1;
            end
        end
    end
end



