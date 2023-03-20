function ff=fitness(IAE, robustez, alfa)
    ff = alfa*robustez + (1-alfa)*IAE
end