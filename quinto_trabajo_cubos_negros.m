clc;
clear;
close all;

%pregunta el tamaño del cubo
lado = input("Introduce el tamaño del lado de los cubos: ");

%opciones disponibles para el movimiento
disp("Selecciona el eje de traslacion:");
disp("1. Traslacion en X");
disp("2. Traslacion en Y");
disp("3. Traslacion en Z");

eje = input("Opcion: ");

%si existe algo fuera del 1 al 3 manda error
if eje < 1 || eje > 3
    error("El eje seleccionado no es valido");
end

distancia = input("Introduce la distancia del movimiento: ");

%posicion cubo 1
x1 = 0;
y1 = 0;
z1 = 0;

%posicion cubo 2 inicial
x2 = 0;
y2 = 0;
z2 = 0;

%dependiendo de lo que escoja el usuario:
%x (x2,y2,z2)=(distancia,0,0)
%y (x2,y2,z2)=(0,distancia,0)
%z (x2,y2,z2)=(0,0,distancia)
if eje == 1
    x2 = distancia;
elseif eje == 2
    y2 = distancia;
elseif eje == 3
    z2 = distancia;
end

%define las aristas del cubo, indica qué vértices deben conectarse "1 2" se
%dibuja una linea entre el vértice 1 y el vértice 2.
aristas = [1 2;
           2 3;
           3 4;
           4 1;
           5 6;
           6 7;
           7 8;
           8 5;
           1 5;
           2 6;
           3 7;
           4 8];

%cuánto avanza la animación
paso = 0.02;

%movimiento comienza en 0 y termina en 1
for movimiento = 0:paso:1

    %limpia la figura anterior para dibujar la siguiente posicion
    clf;
    hold on;

    %cuadricula
    grid on;

    %hace que una unidad mida lo mismo en X, Y y Z para evitar que se
    %deforme el cubo
    axis equal;

    %acomoda la vista para observar los 3 ejes
    view(45,30);

    %nombres de los ejes
    xlabel("Eje X");
    ylabel("Eje Y");
    zlabel("Eje Z");

    %ejes linea
    line([-2 2],[0 0],[0 0], ...
        "Color",'red','LineWidth',2);

    line([0 0],[-2 2],[0 0], ...
        "Color",'green','LineWidth',2);

    line([0 0],[0 0],[-2 2], ...
        "Color",'blue','LineWidth',2);

    %vertices del cubo 2 cada fila representa un vértice y cada columna
    %representa una coordenada
    vertices2 = [x2        y2        z2;
                 x2+lado   y2        z2;
                 x2+lado   y2+lado   z2;
                 x2        y2+lado   z2;
                 x2        y2        z2+lado;
                 x2+lado   y2        z2+lado;
                 x2+lado   y2+lado   z2+lado;
                 x2        y2+lado   z2+lado];

    %cubo 2
    for i = 1:12

        %toma los 2 puntos que forman cada arista
        punto1 = aristas(i,1);
        punto2 = aristas(i,2);

        %dibuja las lineas del cubo 2
        line([vertices2(punto1,1) vertices2(punto2,1)], ...
             [vertices2(punto1,2) vertices2(punto2,2)], ...
             [vertices2(punto1,3) vertices2(punto2,3)], ...
             "Color",'black','LineWidth',2);
    end

    %la posicion comienza desde el origen
    xActual = x1;
    yActual = y1;
    zActual = z1;

    %solo cambia la coordenada del eje seleccionado
    if eje == 1
        xActual = movimiento*distancia;
    elseif eje == 2
        yActual = movimiento*distancia;
    elseif eje == 3
        zActual = movimiento*distancia;
    end

    %cubo en movimiento
    vertices1 = [xActual        yActual        zActual;
                 xActual+lado   yActual        zActual;
                 xActual+lado   yActual+lado   zActual;
                 xActual        yActual+lado   zActual;
                 xActual        yActual        zActual+lado;
                 xActual+lado   yActual        zActual+lado;
                 xActual+lado   yActual+lado   zActual+lado;
                 xActual        yActual+lado   zActual+lado];

    %durante el recorrido se mantiene negro
    colorCubo1 = 'black';

    %cambio de color cuando termina el recorrido
    if movimiento >= 1
        colorCubo1 = 'green';
    end

    %dibuja las 12 aristas del cubo 1
    for i = 1:12

        punto1 = aristas(i,1);
        punto2 = aristas(i,2);

        line([vertices1(punto1,1) vertices1(punto2,1)], ...
             [vertices1(punto1,2) vertices1(punto2,2)], ...
             [vertices1(punto1,3) vertices1(punto2,3)], ...
             "Color",colorCubo1,'LineWidth',3);
    end

    title("Movimiento del cubo 1 hacia el cubo 2");

    %pequeña pausa para poder observar la animación
    pause(0.05);
end

