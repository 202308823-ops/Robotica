clc;
clear;
close all;

L1 = input("Introduce la longitud del eslabon 1 [m]: ");
theta1 = input("Introduce el angulo de la articulacion 1 [rad]: ");

L2 = input("Introduce la longitud del eslabon 2 [m]: ");
theta2 = input("Introduce el angulo de la articulacion 2 [rad]: ");

L3 = input("Introduce la longitud del eslabon 3 [m]: ");
theta3 = input("Introduce el angulo de la articulacion 3 [rad]: ");

paso = 0.02;


for angulo1 = 0:paso:theta1

    clf;
    hold on;
    grid on;
    axis equal;

    line([0 2],[0 0],[0 0], ...
        "Color",'red','LineWidth',2);

    line([0 0],[0 2],[0 0], ...
        "Color",'green','LineWidth',2);

    joint_1 = [0 0]';

    L1x = L1*cos(angulo1);
    L1y = L1*sin(angulo1);
    joint_2 = [L1x L1y]';

    L2x = L2*cos(angulo1);
    L2y = L2*sin(angulo1);
    joint_3 = [L1x + L2x L1y + L2y]';

    L3x = L3*cos(angulo1);
    L3y = L3*sin(angulo1);
    EF = [joint_3(1) + L3x joint_3(2) + L3y]';

    scatter(joint_1(1),joint_1(2),100, ...
        'filled','MarkerFaceColor','blue');

    scatter(joint_2(1),joint_2(2),100, ...
        'filled','MarkerFaceColor','blue');

    scatter(joint_3(1),joint_3(2),100, ...
        'filled','MarkerFaceColor','blue');

    scatter(EF(1),EF(2),100, ...
        'filled','MarkerFaceColor','blue');

    line([joint_1(1) joint_2(1)], ...
        [joint_1(2) joint_2(2)], ...
        [0 0], ...
        "Color",'black','LineWidth',2);

    line([joint_2(1) joint_3(1)], ...
        [joint_2(2) joint_3(2)], ...
        [0 0], ...
        "Color",'black','LineWidth',2);

    line([joint_3(1) EF(1)], ...
        [joint_3(2) EF(2)], ...
        [0 0], ...
        "Color",'black','LineWidth',2);

    pause(0.3);
end



for angulo2 = 0:paso:theta2

    clf;
    hold on;
    grid on;
    axis equal;

    line([0 2],[0 0],[0 0], ...
        "Color",'red','LineWidth',2);

    line([0 0],[0 2],[0 0], ...
        "Color",'green','LineWidth',2);

    joint_1 = [0 0]';

    L1x = L1*cos(theta1);
    L1y = L1*sin(theta1);
    joint_2 = [L1x L1y]';

    anguloTotal2 = theta1 + angulo2;

    L2x = L2*cos(anguloTotal2);
    L2y = L2*sin(anguloTotal2);
    joint_3 = [L1x + L2x L1y + L2y]';

    L3x = L3*cos(anguloTotal2);
    L3y = L3*sin(anguloTotal2);
    EF = [joint_3(1) + L3x joint_3(2) + L3y]';

    scatter(joint_1(1),joint_1(2),100, ...
        'filled','MarkerFaceColor','blue');

    scatter(joint_2(1),joint_2(2),100, ...
        'filled','MarkerFaceColor','blue');

    scatter(joint_3(1),joint_3(2),100, ...
        'filled','MarkerFaceColor','blue');

    scatter(EF(1),EF(2),100, ...
        'filled','MarkerFaceColor','blue');

    line([joint_1(1) joint_2(1)], ...
        [joint_1(2) joint_2(2)], ...
        [0 0], ...
        "Color",'black','LineWidth',2);

    line([joint_2(1) joint_3(1)], ...
        [joint_2(2) joint_3(2)], ...
        [0 0], ...
        "Color",'black','LineWidth',2);

    line([joint_3(1) EF(1)], ...
        [joint_3(2) EF(2)], ...
        [0 0], ...
        "Color",'black','LineWidth',2);

    pause(0.3);
end



for angulo3 = 0:paso:theta3

    clf;
    hold on;
    grid on;
    axis equal;

    line([0 2],[0 0],[0 0], ...
        "Color",'red','LineWidth',2);

    line([0 0],[0 2],[0 0], ...
        "Color",'green','LineWidth',2);

    joint_1 = [0 0]';

    L1x = L1*cos(theta1);
    L1y = L1*sin(theta1);
    joint_2 = [L1x L1y]';

    anguloTotal2 = theta1 + theta2;

    L2x = L2*cos(anguloTotal2);
    L2y = L2*sin(anguloTotal2);
    joint_3 = [L1x + L2x L1y + L2y]';

    anguloTotal3 = theta1 + theta2 + angulo3;

    L3x = L3*cos(anguloTotal3);
    L3y = L3*sin(anguloTotal3);
    EF = [joint_3(1) + L3x joint_3(2) + L3y]';

    scatter(joint_1(1),joint_1(2),100, ...
        'filled','MarkerFaceColor','blue');

    scatter(joint_2(1),joint_2(2),100, ...
        'filled','MarkerFaceColor','blue');

    scatter(joint_3(1),joint_3(2),100, ...
        'filled','MarkerFaceColor','blue');

    scatter(EF(1),EF(2),100, ...
        'filled','MarkerFaceColor','blue');

    line([joint_1(1) joint_2(1)], ...
        [joint_1(2) joint_2(2)], ...
        [0 0], ...
        "Color",'black','LineWidth',2);

    line([joint_2(1) joint_3(1)], ...
        [joint_2(2) joint_3(2)], ...
        [0 0], ...
        "Color",'black','LineWidth',2);

    line([joint_3(1) EF(1)], ...
        [joint_3(2) EF(2)], ...
        [0 0], ...
        "Color",'black','LineWidth',2);

    pause(0.3);
end