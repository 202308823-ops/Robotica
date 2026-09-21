function Examen_gui_cinematica_brazo
% Brazo de 3 eslabones y 4 angulos del examen de Robotica.
% theta1 gira alrededor de Z; theta2, theta3 y theta4 alrededor de Y.

ventana = figure('Name','Cinematica directa del brazo', ...
    'NumberTitle','off','Position',[100 100 1000 620]);

grafica = axes('Parent',ventana,'Units','pixels', ...
    'Position',[345 140 610 430]);

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
    'Position',[345 55 610 60], ...
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
                    puntos = calcularMatrices(L,angulos);
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

    function puntos = calcularMatrices(L,a)
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
