clc;
clear;
close all;

%pide la longitud, el angulo y el eje de giro de la articulacion 1
L1 = input("Introduce la longitud del eslabon 1 [m]: ");
theta1 = input("Introduce el angulo de la articulacion 1 [rad]: ");

disp("Eje de rotacion de la articulacion 1:");
disp("1. Eje X");
disp("2. Eje Y");
disp("3. Eje Z");
eje1 = input("Opcion: ");

%pide la longitud, el angulo y el eje de giro de la articulacion 2
L2 = input("Introduce la longitud del eslabon 2 [m]: ");
theta2 = input("Introduce el angulo de la articulacion 2 [rad]: ");

disp("Eje de rotacion de la articulacion 2:");
disp("1. Eje X");
disp("2. Eje Y");
disp("3. Eje Z");
eje2 = input("Opcion: ");

%pide la longitud, el angulo y el eje de giro de la articulacion 3
L3 = input("Introduce la longitud del eslabon 3 [m]: ");
theta3 = input("Introduce el angulo de la articulacion 3 [rad]: ");

disp("Eje de rotacion de la articulacion 3:");
disp("1. Eje X");
disp("2. Eje Y");
disp("3. Eje Z");
eje3 = input("Opcion: ");

%si alguna opcion esta fuera del 1 al 3 manda error
if eje1 < 1 || eje1 > 3 || ...
   eje2 < 1 || eje2 > 3 || ...
   eje3 < 1 || eje3 > 3

    error("Los ejes seleccionados no son validos");
end

paso = 0.02;
limite = L1 + L2 + L3;

%repite la animacion una vez para cada articulacion
for etapa = 1:3

    %selecciona el angulo que se va a animar
    if etapa == 1
        objetivo = theta1;
    elseif etapa == 2
        objetivo = theta2;
    else
        objetivo = theta3;
    end

    %permite usar angulos positivos o negativos
    if objetivo >= 0
        valores = 0:paso:objetivo;
    else
        valores = 0:-paso:objetivo;
    end

    for angulo = valores

        %los angulos comienzan en cero
        a1 = 0;
        a2 = 0;
        a3 = 0;

        if etapa == 1
            a1 = angulo;

        elseif etapa == 2
            a1 = theta1;
            a2 = angulo;

        elseif etapa == 3
            a1 = theta1;
            a2 = theta2;
            a3 = angulo;
        end

        %matriz de rotacion de la articulacion 1
        if eje1 == 1
            R1 = [1 0 0;
                  0 cos(a1) -sin(a1);
                  0 sin(a1) cos(a1)];

        elseif eje1 == 2
            R1 = [cos(a1) 0 sin(a1);
                  0 1 0;
                  -sin(a1) 0 cos(a1)];

        else
            R1 = [cos(a1) -sin(a1) 0;
                  sin(a1) cos(a1) 0;
                  0 0 1];
        end

        %matriz de rotacion de la articulacion 2
        if eje2 == 1
            R2 = [1 0 0;
                  0 cos(a2) -sin(a2);
                  0 sin(a2) cos(a2)];

        elseif eje2 == 2
            R2 = [cos(a2) 0 sin(a2);
                  0 1 0;
                  -sin(a2) 0 cos(a2)];

        else
            R2 = [cos(a2) -sin(a2) 0;
                  sin(a2) cos(a2) 0;
                  0 0 1];
        end

        %matriz de rotacion de la articulacion 3
        if eje3 == 1
            R3 = [1 0 0;
                  0 cos(a3) -sin(a3);
                  0 sin(a3) cos(a3)];

        elseif eje3 == 2
            R3 = [cos(a3) 0 sin(a3);
                  0 1 0;
                  -sin(a3) 0 cos(a3)];

        else
            R3 = [cos(a3) -sin(a3) 0;
                  sin(a3) cos(a3) 0;
                  0 0 1];
        end

        %la primera articulacion comienza en el origen
        joint_1 = [0 0 0]';

        %calcula la posicion de la segunda articulacion
        eslabon1 = [L1 0 0]';
        joint_2 = R1*eslabon1;

        %calcula la posicion de la tercera articulacion
        eslabon2 = [L2 0 0]';
        joint_3 = joint_2 + R1*R2*eslabon2;

        %calcula la posicion del efector final
        eslabon3 = [L3 0 0]';
        EF = joint_3 + R1*R2*R3*eslabon3;

        %limpia la figura anterior para dibujar la nueva posicion
        clf;
        hold on;
        grid on;

        %mantiene la misma escala en los 3 ejes
        axis equal;

        %acomoda la vista para observar el movimiento en 3D
        view(45,30);

        %limites de la grafica de acuerdo con el tamaño del brazo
        axis([-limite limite ...
              -limite limite ...
              -limite limite]);

        xlabel("Eje X");
        ylabel("Eje Y");
        zlabel("Eje Z");

        %dibuja el eje X en rojo
        line([-limite limite],[0 0],[0 0], ...
            "Color",'red','LineWidth',2);

        %dibuja el eje Y en verde
        line([0 0],[-limite limite],[0 0], ...
            "Color",'green','LineWidth',2);

        %dibuja el eje Z en azul
        line([0 0],[0 0],[-limite limite], ...
            "Color",'blue','LineWidth',2);

        %dibuja los 3 eslabones del brazo
        line([joint_1(1) joint_2(1)], ...
             [joint_1(2) joint_2(2)], ...
             [joint_1(3) joint_2(3)], ...
             "Color",'black','LineWidth',3);

        line([joint_2(1) joint_3(1)], ...
             [joint_2(2) joint_3(2)], ...
             [joint_2(3) joint_3(3)], ...
             "Color",'black','LineWidth',3);

        line([joint_3(1) EF(1)], ...
             [joint_3(2) EF(2)], ...
             [joint_3(3) EF(3)], ...
             "Color",'black','LineWidth',3);

        %dibuja las articulaciones y el efector final
        scatter3(joint_1(1),joint_1(2),joint_1(3),100, ...
            'filled','MarkerFaceColor','blue');

        scatter3(joint_2(1),joint_2(2),joint_2(3),100, ...
            'filled','MarkerFaceColor','blue');

        scatter3(joint_3(1),joint_3(2),joint_3(3),100, ...
            'filled','MarkerFaceColor','blue');

        scatter3(EF(1),EF(2),EF(3),100, ...
            'filled','MarkerFaceColor','blue');

        title("Movimiento del brazo de 3 eslabones");

        %pequeña pausa para observar la animacion
        pause(0.05);
    end
end

%muestra las coordenadas finales del efector
disp("Posicion final del efector:");
disp(EF);