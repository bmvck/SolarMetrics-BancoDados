-- ===============================================================
-- Projeto:       SolarMetrics 2.0
-- Sprint:        3 - Funções (3 exceções distintas cada)
-- Observação:    Sem JSON_OBJECT / JSON_ARRAY / TO_JSON (Oracle)
-- Pré-requisito: 01_DDL.sql, 02_Dados.sql
-- ===============================================================

CREATE OR REPLACE FUNCTION FN_JSON_LINHA_SISTEMA_SENSOR (
    p_id_sistema      IN VARCHAR2,
    p_nome_instalacao IN VARCHAR2,
    p_potencia_total  IN NUMBER,
    p_status_sistema  IN VARCHAR2,
    p_id_sensor       IN VARCHAR2,
    p_tipo_sensor     IN VARCHAR2,
    p_status_sensor   IN VARCHAR2,
    p_localizacao     IN VARCHAR2
) RETURN CLOB IS
    e_param_obrigatorio EXCEPTION;
    e_texto_grande      EXCEPTION;
    v_nome_esc          VARCHAR2(4000);
    v_loc_esc           VARCHAR2(4000);
    v_pot_txt           VARCHAR2(100);
    v_json              CLOB;
BEGIN
    IF p_id_sistema IS NULL OR p_id_sensor IS NULL THEN
        RAISE e_param_obrigatorio;
    END IF;

    v_nome_esc := REPLACE(REPLACE(NVL(p_nome_instalacao, ''), '\', '\\'), '"', '\"');
    v_loc_esc  := REPLACE(REPLACE(NVL(p_localizacao, ''), '\', '\\'), '"', '\"');

    IF LENGTHB(v_nome_esc) > 3500 THEN
        RAISE e_texto_grande;
    END IF;

    IF p_potencia_total IS NULL THEN
        v_pot_txt := 'null';
    ELSE
        v_pot_txt := TO_CHAR(p_potencia_total, 'TM9', 'NLS_NUMERIC_CHARACTERS=''.,''');
    END IF;

    v_json :=
        '{' ||
        '"id_sistema":"' || p_id_sistema || '",' ||
        '"nome_instalacao":"' || v_nome_esc || '",' ||
        '"potencia_total":' || v_pot_txt || ',' ||
        '"status_sistema":"' || NVL(p_status_sistema, '') || '",' ||
        '"sensor":{' ||
        '"id_sensor":"' || p_id_sensor || '",' ||
        '"tipo":"' || NVL(p_tipo_sensor, '') || '",' ||
        '"status":"' || NVL(p_status_sensor, '') || '",' ||
        '"localizacao":"' || v_loc_esc || '"' ||
        '}}';

    RETURN v_json;
EXCEPTION
    WHEN e_param_obrigatorio THEN
        RETURN '{"erro":"parametro_obrigatorio_nulo"}';
    WHEN e_texto_grande THEN
        RETURN '{"erro":"nome_instalacao_excede_limite_interno"}';
    WHEN OTHERS THEN
        RETURN '{"erro":"' || REPLACE(REPLACE(SQLERRM, '"', ''''), CHR(10), ' ') || '"}';
END;
/

CREATE OR REPLACE FUNCTION FN_VALIDAR_POTENCIA_SISTEMA (
    p_potencia_total IN NUMBER
) RETURN VARCHAR2 IS
    e_potencia_nula       EXCEPTION;
    e_potencia_acima_max  EXCEPTION;
BEGIN
    IF p_potencia_total IS NULL THEN
        RAISE e_potencia_nula;
    END IF;

    IF p_potencia_total <= 0 THEN
        RETURN 'ERRO: Potência total inválida. Deve ser maior que zero.';
    END IF;

    IF p_potencia_total > 1000000 THEN
        RAISE e_potencia_acima_max;
    END IF;

    RETURN 'Potência válida.';
EXCEPTION
    WHEN e_potencia_nula THEN
        RETURN 'ERRO: Potência não informada (NULL).';
    WHEN e_potencia_acima_max THEN
        RETURN 'ERRO: Potência acima do limite máximo permitido (1.000.000).';
    WHEN OTHERS THEN
        RETURN 'ERRO: Falha na validação de potência: ' || SQLERRM;
END;
/
