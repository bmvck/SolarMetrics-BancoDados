-- ===============================================================
-- Projeto:       SolarMetrics 2.0
-- Sprint:        2 - Procedures CRUD com Validação
-- Procedure:     PROC_INSERT_SISTEMA
-- Tabela:        SM_SISTEMA

SET SERVEROUTPUT ON;
CREATE OR REPLACE PROCEDURE PROC_INSERT_SISTEMA (
    p_id_sistema         IN SM_SISTEMA.ID_SISTEMA%TYPE,
    p_nome_instalacao    IN SM_SISTEMA.NOME_INSTALACAO%TYPE,
    p_data_instalacao    IN SM_SISTEMA.DATA_INSTALACAO%TYPE,
    p_potencia_total     IN SM_SISTEMA.POTENCIA_TOTAL%TYPE,
    p_status             IN SM_SISTEMA.STATUS%TYPE,
    p_id_user            IN SM_SISTEMA.SM_USUARIO_ID_USER%TYPE,
    p_id_end_sis         IN SM_SISTEMA.SM_END_SISTEMA_ID_END_SIS%TYPE
)
IS
    v_validacao VARCHAR2(100);
BEGIN
    v_validacao := FN_VALIDAR_POTENCIA_SISTEMA(p_potencia_total);

    IF v_validacao = 'Potência válida.' THEN
        INSERT INTO SM_SISTEMA (
            ID_SISTEMA, NOME_INSTALACAO, DATA_INSTALACAO,
            POTENCIA_TOTAL, STATUS, SM_USUARIO_ID_USER, SM_END_SISTEMA_ID_END_SIS
        ) VALUES (
            p_id_sistema, p_nome_instalacao, p_data_instalacao,
            p_potencia_total, p_status, p_id_user, p_id_end_sis
        );

        DBMS_OUTPUT.PUT_LINE('Sistema inserido com sucesso!');
        COMMIT;
    ELSE
        DBMS_OUTPUT.PUT_LINE(v_validacao);
    END IF;

EXCEPTION
    WHEN DUP_VAL_ON_INDEX THEN
        DBMS_OUTPUT.PUT_LINE('Erro: ID do sistema já existe.');
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('Erro inesperado: ' || SQLERRM);
END;


-- Insert dando certo:
BEGIN
    PROC_INSERT_SISTEMA(
        'S20',
        'Usina Solar - Shopping Campinas',
        TO_DATE('15/08/2024', 'DD/MM/YYYY'),
        20,
        'ATIVO',
        'U1',
        'END1'
    );
END;

-- Insert dando errado: 
BEGIN
    PROC_INSERT_SISTEMA(
        'S25',
        'Usina Solar - Escritorio Barra funda',
        TO_DATE('19/08/2024', 'DD/MM/YYYY'),
        0,
        'ATIVO',
        'U1',
        'END1'
    );
END;


-- ===============================================================
-- Procedures CRUD com Validação
-- Procedure:     PROC_UPDATE_SISTEMA
-- Tabela:        SM_SISTEMA

CREATE OR REPLACE PROCEDURE PROC_UPDATE_SISTEMA (
    p_id_sistema         IN SM_SISTEMA.ID_SISTEMA%TYPE,
    p_nome_instalacao    IN SM_SISTEMA.NOME_INSTALACAO%TYPE,
    p_data_instalacao    IN SM_SISTEMA.DATA_INSTALACAO%TYPE,
    p_potencia_total     IN SM_SISTEMA.POTENCIA_TOTAL%TYPE,
    p_status             IN SM_SISTEMA.STATUS%TYPE,
    p_id_user            IN SM_SISTEMA.SM_USUARIO_ID_USER%TYPE,
    p_id_end_sis         IN SM_SISTEMA.SM_END_SISTEMA_ID_END_SIS%TYPE
)
IS
    v_validacao VARCHAR2(100);
    v_existente NUMBER;
BEGIN
    
    SELECT COUNT(*) INTO v_existente
    FROM SM_SISTEMA
    WHERE ID_SISTEMA = p_id_sistema;

    IF v_existente = 0 THEN
        DBMS_OUTPUT.PUT_LINE('Erro: Sistema ' || p_id_sistema || ' não encontrado.');
        RETURN;
    END IF;

   
    v_validacao := FN_VALIDAR_POTENCIA_SISTEMA(p_potencia_total);

    IF v_validacao = 'Potência válida.' THEN
        UPDATE SM_SISTEMA
        SET
            NOME_INSTALACAO = p_nome_instalacao,
            DATA_INSTALACAO = p_data_instalacao,
            POTENCIA_TOTAL = p_potencia_total,
            STATUS = p_status,
            SM_USUARIO_ID_USER = p_id_user,
            SM_END_SISTEMA_ID_END_SIS = p_id_end_sis
        WHERE ID_SISTEMA = p_id_sistema;

        DBMS_OUTPUT.PUT_LINE('Sistema ' || p_id_sistema || ' atualizado com sucesso!');
        COMMIT;
    ELSE
        DBMS_OUTPUT.PUT_LINE(v_validacao);
    END IF;

EXCEPTION
    WHEN NO_DATA_FOUND THEN
        DBMS_OUTPUT.PUT_LINE('Erro: Sistema não encontrado.');
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('Erro inesperado: ' || SQLERRM);
END;


-- Atualiza um sistema com potência válida (> 0)
BEGIN
    PROC_UPDATE_SISTEMA(
        'S20',
        'Usina Solar - Shopping Campinas (Atualizada)',
        TO_DATE('20/08/2024', 'DD/MM/YYYY'),
        25,
        'ATIVO',
        'U1',
        'END1'
    );
END;

-- Testar caso onde a potência é 0
BEGIN
    PROC_UPDATE_SISTEMA(
        'S20',
        'Usina Solar - Shopping Campinas (Atualizada)',
        TO_DATE('20/08/2024', 'DD/MM/YYYY'),
        0,
        'ATIVO',
        'U1',
        'END1'
    );
END;



SELECT ID_SISTEMA, NOME_INSTALACAO, POTENCIA_TOTAL, STATUS
FROM SM_SISTEMA
WHERE ID_SISTEMA = 'S20';


-- ===============================================================
-- Procedures CRUD com Validação
-- Procedure:     PROC_DELETE_SISTEMA
-- Tabela:        SM_SISTEMA

CREATE OR REPLACE PROCEDURE PROC_DELETE_SISTEMA (
    p_id_sistema IN SM_SISTEMA.ID_SISTEMA%TYPE
)
IS
    v_existente NUMBER;
BEGIN
    
    SELECT COUNT(*) INTO v_existente
    FROM SM_SISTEMA
    WHERE ID_SISTEMA = p_id_sistema;

    IF v_existente = 0 THEN
        DBMS_OUTPUT.PUT_LINE('Erro: Sistema ' || p_id_sistema || ' não encontrado.');
        RETURN;
    END IF;

   
    DELETE FROM SM_MANUTENCAO
    WHERE SM_SISTEMA_ID_SISTEMA = p_id_sistema;

    DELETE FROM SM_SENSOR
    WHERE SM_SISTEMA_ID_SISTEMA = p_id_sistema;

    DELETE FROM SM_PAINEL_SOLAR
    WHERE SM_SISTEMA_ID_SISTEMA = p_id_sistema;

    
    DELETE FROM SM_SISTEMA
    WHERE ID_SISTEMA = p_id_sistema;

    DBMS_OUTPUT.PUT_LINE('Sistema ' || p_id_sistema || ' e seus registros relacionados foram removidos com sucesso.');

    COMMIT;

EXCEPTION
    WHEN NO_DATA_FOUND THEN
        DBMS_OUTPUT.PUT_LINE('Erro: Sistema não encontrado.');
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('Erro inesperado: ' || SQLERRM);
END;


-- delete sistema existente
BEGIN
    PROC_DELETE_SISTEMA('S20');
END;


-- delete Sistema inexistente

BEGIN
    PROC_DELETE_SISTEMA('S99');
END;


-- ===============================================================
-- Procedures CRUD com Validação
-- Procedure:     PROC_INSERT_SENSOR
-- Tabela:        SM_SENSOR

CREATE OR REPLACE PROCEDURE PROC_INSERT_SENSOR (
    p_id_sensor         IN SM_SENSOR.ID_SENSOR%TYPE,
    p_tipo              IN SM_SENSOR.TIPO%TYPE,
    p_status            IN SM_SENSOR.STATUS%TYPE,
    p_localizacao       IN SM_SENSOR.LOCALIZACAO%TYPE,
    p_id_sistema        IN SM_SENSOR.SM_SISTEMA_ID_SISTEMA%TYPE
)
IS
    v_tipo_valido NUMBER := 0;
    v_status_valido NUMBER := 0;
BEGIN
    IF UPPER(p_tipo) IN ('IRRADIANCIA', 'TEMPERATURA', 'UMIDADE', 'VENTO') THEN
        v_tipo_valido := 1;
    END IF;

    
    IF UPPER(p_status) IN ('ATIVO', 'INATIVO') THEN
        v_status_valido := 1;
    END IF;

    IF v_tipo_valido = 1 AND v_status_valido = 1 THEN
        INSERT INTO SM_SENSOR (
            ID_SENSOR, TIPO, STATUS, LOCALIZACAO, SM_SISTEMA_ID_SISTEMA
        ) VALUES (
            p_id_sensor, p_tipo, p_status, p_localizacao, p_id_sistema
        );

        DBMS_OUTPUT.PUT_LINE('Sensor inserido com sucesso!');
        COMMIT;
    ELSE
        DBMS_OUTPUT.PUT_LINE('Erro: Tipo ou status inválido.');
    END IF;

EXCEPTION
    WHEN DUP_VAL_ON_INDEX THEN
        DBMS_OUTPUT.PUT_LINE('Erro: ID do sensor já existe.');
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('Erro inesperado: ' || SQLERRM);
END;

-- inserção valida
BEGIN
    PROC_INSERT_SENSOR(
        'SEN20',
        'IRRADIANCIA',
        'ATIVO',
        'Telhado Central',
        'S20'
    );
END;

-- inserção invalida
BEGIN
    PROC_INSERT_SENSOR(
        'SEN21',
        'PRESSAO',
        'ATIVO',
        'Cobertura Oeste',
        'S20'
    );
END;



-- ===============================================================
-- Procedures CRUD com Validação
-- Procedure:     PROC_UPDATE_SENSOR
-- Tabela:        SM_SENSOR

CREATE OR REPLACE PROCEDURE PROC_UPDATE_SENSOR (
    p_id_sensor     IN SM_SENSOR.ID_SENSOR%TYPE,
    p_tipo          IN SM_SENSOR.TIPO%TYPE,
    p_status        IN SM_SENSOR.STATUS%TYPE,
    p_localizacao   IN SM_SENSOR.LOCALIZACAO%TYPE,
    p_id_sistema    IN SM_SENSOR.SM_SISTEMA_ID_SISTEMA%TYPE
)
IS
    v_existente NUMBER := 0;
    v_tipo_valido NUMBER := 0;
    v_status_valido NUMBER := 0;
BEGIN
    
    SELECT COUNT(*) INTO v_existente
    FROM SM_SENSOR
    WHERE ID_SENSOR = p_id_sensor;

    IF v_existente = 0 THEN
        DBMS_OUTPUT.PUT_LINE('Erro: Sensor ' || p_id_sensor || ' não encontrado.');
        RETURN;
    END IF;

    
    IF UPPER(p_tipo) IN ('IRRADIANCIA', 'TEMPERATURA', 'UMIDADE', 'VENTO') THEN
        v_tipo_valido := 1;
    END IF;

    
    IF UPPER(p_status) IN ('ATIVO', 'INATIVO') THEN
        v_status_valido := 1;
    END IF;

    IF v_tipo_valido = 1 AND v_status_valido = 1 THEN
        UPDATE SM_SENSOR
        SET
            TIPO = p_tipo,
            STATUS = p_status,
            LOCALIZACAO = p_localizacao,
            SM_SISTEMA_ID_SISTEMA = p_id_sistema
        WHERE ID_SENSOR = p_id_sensor;

        DBMS_OUTPUT.PUT_LINE('Sensor ' || p_id_sensor || ' atualizado com sucesso!');
        COMMIT;
    ELSE
        DBMS_OUTPUT.PUT_LINE('Erro: Tipo ou status inválido. Nenhuma atualização realizada.');
    END IF;

EXCEPTION
    WHEN NO_DATA_FOUND THEN
        DBMS_OUTPUT.PUT_LINE('Erro: Sensor não encontrado.');
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('Erro inesperado: ' || SQLERRM);
END;


-- atualização certa
BEGIN
    PROC_UPDATE_SENSOR(
        'SEN20',
        'VENTO',
        'ATIVO',
        'Cobertura Leste',
        'S20'
    );
END;


-- atualização errada
BEGIN
    PROC_UPDATE_SENSOR(
        'SEN20',
        'PRESSAO',
        'ATIVO',
        'Cobertura Oeste',
        'S20'
    );
END;

-- ===============================================================
-- Procedures CRUD com Validação
-- Procedure:     PROC_DELETE_SENSOR
-- Tabela:        SM_SENSOR

CREATE OR REPLACE PROCEDURE PROC_DELETE_SENSOR (
    p_id_sensor IN SM_SENSOR.ID_SENSOR%TYPE
)
IS
    v_existente NUMBER;
BEGIN
    
    SELECT COUNT(*) INTO v_existente
    FROM SM_SENSOR
    WHERE ID_SENSOR = p_id_sensor;

    IF v_existente = 0 THEN
        DBMS_OUTPUT.PUT_LINE('Erro: Sensor ' || p_id_sensor || ' não encontrado.');
        RETURN;
    END IF;

    
    DELETE FROM SM_MONITORAMENTO
    WHERE SM_SENSOR_ID_SENSOR = p_id_sensor;

    
    DELETE FROM SM_SENSOR
    WHERE ID_SENSOR = p_id_sensor;

    DBMS_OUTPUT.PUT_LINE('Sensor ' || p_id_sensor || ' e seus monitoramentos foram removidos com sucesso.');
    COMMIT;

EXCEPTION
    WHEN NO_DATA_FOUND THEN
        DBMS_OUTPUT.PUT_LINE('Erro: Sensor não encontrado.');
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('Erro inesperado: ' || SQLERRM);
END;

-- Sensor existente
BEGIN
    PROC_DELETE_SENSOR('SEN20');
END;

-- Sensor inexistente
BEGIN
    PROC_DELETE_SENSOR('SEN99');
END;




