function Examen_gui_cinematica_brazo_calculos
% Brazo de 3 eslabones y 4 angulos del examen de Robotica.
% theta1 gira alrededor de Z; theta2, theta3 y theta4 alrededor de Y.
% Esta version muestra a la derecha los calculos del metodo seleccionado.

ventana = figure('Name','Cinematica directa del brazo', ...
    'NumberTitle','off','Position',[80 80 1460 680]);

grafica = axes('Parent',ventana,'Units','pixels', ...
    'Position',[365 145 600 470]);

uicontrol('Parent',ventana,'Style','text', ...
    'String','Resumen del calculo', ...
    'Position',[990 610 440 32],'FontSize',14);

resumen = uicontrol('Parent',ventana,'Style','edit', ...
    'Max',30,'Min',0,'Enable','inactive', ...
    'HorizontalAlignment','left','FontName','Consolas', ...
    'FontSize',10,'Position',[990 105 440 495], ...
    'String','Selecciona un metodo y pulsa Simular.');

uicontrol('Parent',ventana,'Style','text', ...
    'String','Brazo de 3 eslabones', ...
    'Position',[20 565 290 30],'FontSize',14);

etiquetas = {'L1 [m]','L2 [m]','L3 [m]', ...
    'theta1 [rad] (Z)','theta2 [rad] (Y)', ...
    'theta3 [rad] (Y)','theta4 [rad] (Y)'};
ejemplos = {'1','0.8','0.6','0','-0.5','0.7','0.3'};
campos = cell(1,7);

for i = 1:7
    y = 525 - (i-1)*53;
    uicontrol('Parent',ventana,'Style','text', ...
        'String',etiquetas{i},'Position',[20 y 155 25], ...
        'HorizontalAlignment','left');
    campos{i} = uicontrol('Parent',ventana,'Style','edit', ...
        'String',ejemplos{i},'Position',[180 y 115 27]);
end

opcionGeometrica = uicontrol('Parent',ventana,'Style','checkbox', ...
    'String','Solucion geometrica','Value',1, ...
    'Position',[20 135 270 25], ...
    'Callback',@(~,~) seleccionarMetodo(1));

opcionMatrices = uicontrol('Parent',ventana,'Style','checkbox', ...
    'String','Matrices homogeneas','Value',0, ...
    'Position',[20 105 270 25], ...
    'Callback',@(~,~) seleccionarMetodo(2));

uicontrol('Parent',ventana,'Style','pushbutton', ...
    'String','Simular','Position',[20 55 275 38], ...
    'Callback',@(~,~) simular(true));

resultado = uicontrol('Parent',ventana,'Style','text', ...
    'String','Introduce los datos y pulsa Simular.', ...
    'Position',[365 55 600 60], ...
    'HorizontalAlignment','left','FontSize',11);

dibujar([0 0 0; 1 0 0; 1.8 0 0; 2.4 0 0],2.4);

    function seleccionarMetodo(metodo)
        %Solo puede quedar seleccionada una de las dos opciones.
        set(opcionGeometrica,'Value',metodo == 1);
        set(opcionMatrices,'Value',metodo == 2);
        simular(false);
    end

    function simular(conMovimiento)
        datos = zeros(1,7);
        for j = 1:7
            datos(j) = str2double(get(campos{j},'String'));
        end

        if any(~isfinite(datos)) || any(datos(1:3) <= 0)
            set(resultado,'String', ...
                'Escribe longitudes positivas y angulos numericos en radianes.');
            set(resumen,'String','Corrige los valores de entrada.');
            return;
        end

        L = datos(1:3);
        objetivo = datos(4:7);
        limite = sum(L);

        if conMovimiento
            etapas = 1:4;
        else
            etapas = 4;
        end

        for etapa = etapas
            if conMovimiento
                pasos = 0:40;
            else
                pasos = 40;
            end

            for paso = pasos
                if ~ishandle(ventana)
                    return;
                end

                %Las articulaciones anteriores conservan su angulo final.
                angulos = zeros(1,4);
                if etapa > 1
                    angulos(1:etapa-1) = objetivo(1:etapa-1);
                end
                angulos(etapa) = objetivo(etapa)*paso/40;

                if get(opcionGeometrica,'Value') == 1
                    puntos = calcularGeometrico(L,angulos);
                    nombreMetodo = 'Geometrico';
                else
                    [puntos,T1,T2,T3] = calcularMatrices(L,angulos);
                    nombreMetodo = 'Matrices homogeneas';
                end

                dibujar(puntos,limite);
                if conMovimiento
                    pause(0.025);
                end
            end
        end

        EF = puntos(4,:);
        set(resultado,'String',sprintf( ...
            '%s   |   Efector final [m]: X = %.4f, Y = %.4f, Z = %.4f', ...
            nombreMetodo,EF(1),EF(2),EF(3)));

        if get(opcionGeometrica,'Value') == 1
            set(resumen,'String',resumenGeometrico(L,objetivo,puntos));
        else
            set(resumen,'String',resumenMatrices(L,objetivo,T1,T2,T3));
        end
    end

    function puntos = calcularGeometrico(L,a)
        %Se suman las componentes de los tres eslabones en el plano vertical.
        a2 = a(2);
        a23 = a(2) + a(3);
        a234 = a(2) + a(3) + a(4);

        r1 = L(1)*cos(a2);
        r2 = r1 + L(2)*cos(a23);
        r3 = r2 + L(3)*cos(a234);

        z1 = -L(1)*sin(a2);
        z2 = z1 - L(2)*sin(a23);
        z3 = z2 - L(3)*sin(a234);

        puntos = [0 0 0;
            r1*cos(a(1)) r1*sin(a(1)) z1;
            r2*cos(a(1)) r2*sin(a(1)) z2;
            r3*cos(a(1)) r3*sin(a(1)) z3];
    end

    function [puntos,T1,T2,T3] = calcularMatrices(L,a)
        %Misma cadena del examen: Rz Ry Tx Ry Tx Ry Tx.
        Rz = [cos(a(1)) -sin(a(1)) 0 0;
              sin(a(1))  cos(a(1)) 0 0;
              0          0         1 0;
              0          0         0 1];

        Ry2 = [cos(a(2)) 0 sin(a(2)) 0;
               0         1 0         0;
               -sin(a(2)) 0 cos(a(2)) 0;
               0         0 0         1];
        Ry3 = [cos(a(3)) 0 sin(a(3)) 0;
               0         1 0         0;
               -sin(a(3)) 0 cos(a(3)) 0;
               0         0 0         1];
        Ry4 = [cos(a(4)) 0 sin(a(4)) 0;
               0         1 0         0;
               -sin(a(4)) 0 cos(a(4)) 0;
               0         0 0         1];

        Tx1 = [1 0 0 L(1); 0 1 0 0; 0 0 1 0; 0 0 0 1];
        Tx2 = [1 0 0 L(2); 0 1 0 0; 0 0 1 0; 0 0 0 1];
        Tx3 = [1 0 0 L(3); 0 1 0 0; 0 0 1 0; 0 0 0 1];

        T1 = Rz*Ry2*Tx1;
        T2 = T1*Ry3*Tx2;
        T3 = T2*Ry4*Tx3;

        puntos = [0 0 0;
                  T1(1:3,4)';
                  T2(1:3,4)';
                  T3(1:3,4)'];
    end

    function lineas = resumenGeometrico(L,a,p)
        b1 = a(2);
        b2 = a(2) + a(3);
        b3 = a(2) + a(3) + a(4);
        r = L(1)*cos(b1) + L(2)*cos(b2) + L(3)*cos(b3);
        z = -L(1)*sin(b1) - L(2)*sin(b2) - L(3)*sin(b3);

        lineas = {
            'SOLUCION GEOMETRICA'
            'Angulos en radianes; distancias en metros.'
            ' '
            '1. Angulos acumulados de los eslabones:'
            sprintf('b1 = theta2 = %.4f',b1)
            sprintf('b2 = theta2 + theta3 = %.4f',b2)
            sprintf('b3 = theta2 + theta3 + theta4 = %.4f',b3)
            ' '
            '2. Proyeccion horizontal y altura:'
            'r = L1 cos(b1) + L2 cos(b2) + L3 cos(b3)'
            sprintf('r = %.3f cos(%.3f) + %.3f cos(%.3f)', ...
                    L(1),b1,L(2),b2)
            sprintf('    + %.3f cos(%.3f) = %.4f m',L(3),b3,r)
            'z = -L1 sin(b1) - L2 sin(b2) - L3 sin(b3)'
            sprintf('z = -%.3f sin(%.3f) - %.3f sin(%.3f)', ...
                    L(1),b1,L(2),b2)
            sprintf('    - %.3f sin(%.3f) = %.4f m',L(3),b3,z)
            ' '
            '3. Giro de la base alrededor de Z:'
            sprintf('x = r cos(theta1) = %.4f cos(%.3f)',r,a(1))
            sprintf('  = %.4f m',p(4,1))
            sprintf('y = r sin(theta1) = %.4f sin(%.3f)',r,a(1))
            sprintf('  = %.4f m',p(4,2))
            sprintf('EF = [%.4f, %.4f, %.4f] m',p(4,:))
            };
    end

    function lineas = resumenMatrices(L,a,T1,T2,T3)
        lineas = {
            'MATRICES HOMOGENEAS (4 x 4)'
            'Angulos en radianes; distancias en metros.'
            ' '
            sprintf('Rz(theta1): giro Z de %.3f rad',a(1))
            sprintf('Ry(theta2): giro Y de %.3f rad',a(2))
            sprintf('Ry(theta3): giro Y de %.3f rad',a(3))
            sprintf('Ry(theta4): giro Y de %.3f rad',a(4))
            sprintf('Tx(L1), Tx(L2), Tx(L3): %.3f, %.3f, %.3f m',L)
            ' '
            '1. Multiplicaciones en este orden:'
            'T1 = Rz(theta1) Ry(theta2) Tx(L1)'
            'T2 = T1 Ry(theta3) Tx(L2)'
            'T3 = T2 Ry(theta4) Tx(L3)'
            ' '
            '2. Posiciones: columna 4 de cada matriz:'
            sprintf('T1(1:3,4) = [%.4f %.4f %.4f] m',T1(1:3,4))
            sprintf('T2(1:3,4) = [%.4f %.4f %.4f] m',T2(1:3,4))
            sprintf('T3(1:3,4) = [%.4f %.4f %.4f] m',T3(1:3,4))
            ' '
            '3. Matriz final T3:'
            sprintf('[%8.4f %8.4f %8.4f %8.4f]',T3(1,:))
            sprintf('[%8.4f %8.4f %8.4f %8.4f]',T3(2,:))
            sprintf('[%8.4f %8.4f %8.4f %8.4f]',T3(3,:))
            sprintf('[%8.4f %8.4f %8.4f %8.4f]',T3(4,:))
            ' '
            'EF = columna 4, filas 1 a 3, de T3.'
            };
    end

    function dibujar(puntos,limite)
        %Conservamos los ejes y los colores de los ejercicios de clase.
        cla(grafica);
        hold(grafica,'on');
        grid(grafica,'on');
        axis(grafica,'equal');
        axis(grafica,[-limite limite -limite limite -limite limite]);
        view(grafica,45,30);

        line(grafica,[-limite limite],[0 0],[0 0], ...
            'Color','red','LineWidth',1);
        line(grafica,[0 0],[-limite limite],[0 0], ...
            'Color','green','LineWidth',1);
        line(grafica,[0 0],[0 0],[-limite limite], ...
            'Color','blue','LineWidth',1);

        for j = 1:3
            line(grafica,[puntos(j,1) puntos(j+1,1)], ...
                [puntos(j,2) puntos(j+1,2)], ...
                [puntos(j,3) puntos(j+1,3)], ...
                'Color','black','LineWidth',3);
        end

        scatter3(grafica,puntos(:,1),puntos(:,2),puntos(:,3), ...
            75,'filled','MarkerFaceColor','blue');
        xlabel(grafica,'Eje X [m]');
        ylabel(grafica,'Eje Y [m]');
        zlabel(grafica,'Eje Z [m]');
        title(grafica,'Brazo de tres eslabones y cuatro articulaciones');
    end
end