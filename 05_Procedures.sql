-- ===============================================================
-- Projeto:       SolarMetrics 2.0
-- Sprint:        3 - Procedures (3 exceções distintas cada)
-- Pré-requisito: 04_Functions.sql
-- ===============================================================

SET SERVEROUTPUT ON SIZE UNLIMITED FORMAT WRAPPED;

CREATE OR REPLACE PROCEDURE PROC_RELATORIO_SISTEMA_SENSOR_JSON IS
    v_json   CLOB;
    v_total  NUMBER := 0;
BEGIN
    FOR r IN (
        SELECT s.ID_SISTEMA,
               s.NOME_INSTALACAO,
               s.POTENCIA_TOTAL,
               s.STATUS            AS STATUS_SIS,
               sen.ID_SENSOR,
               sen.TIPO,
               sen.STATUS          AS STATUS_SENS,
               sen.LOCALIZACAO
        FROM   SM_SISTEMA s
        INNER JOIN SM_SENSOR sen
            ON s.ID_SISTEMA = sen.SM_SISTEMA_ID_SISTEMA
        ORDER BY s.ID_SISTEMA, sen.ID_SENSOR
    ) LOOP
        v_json := FN_JSON_LINHA_SISTEMA_SENSOR(
            r.ID_SISTEMA,
            r.NOME_INSTALACAO,
            r.POTENCIA_TOTAL,
            r.STATUS_SIS,
            r.ID_SENSOR,
            r.TIPO,
            r.STATUS_SENS,
            r.LOCALIZACAO
        );
        DBMS_OUTPUT.PUT_LINE('JSON=' || DBMS_LOB.SUBSTR(v_json, 4000, 1));
        v_total := v_total + 1;
    END LOOP;

    IF v_total = 0 THEN
        RAISE NO_DATA_FOUND;
    END IF;

    DBMS_OUTPUT.PUT_LINE('Total de linhas processadas: ' || v_total);
EXCEPTION
    WHEN NO_DATA_FOUND THEN
        DBMS_OUTPUT.PUT_LINE('Erro: nenhuma linha retornada pelo JOIN (SM_SISTEMA x SM_SENSOR).');
    WHEN VALUE_ERROR THEN
        DBMS_OUTPUT.PUT_LINE('Erro de valor ao processar relatório JSON: ' || SQLERRM);
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('Erro inesperado em PROC_RELATORIO_SISTEMA_SENSOR_JSON: ' || SQLERRM);
END;
/

CREATE OR REPLACE PROCEDURE PROC_RELATORIO_POTENCIA_ANT_ATUAL_PROX IS
    e_menos_de_cinco_linhas   EXCEPTION;
    e_relatorio_insuficiente  EXCEPTION;
    v_qtd                     NUMBER;
    v_linhas                  NUMBER := 0;
BEGIN
    SELECT COUNT(*) INTO v_qtd FROM SM_SISTEMA;

    IF v_qtd < 5 THEN
        RAISE e_menos_de_cinco_linhas;
    END IF;

    DBMS_OUTPUT.PUT_LINE('ID_SISTEMA | Anterior | Atual | Proximo');
    DBMS_OUTPUT.PUT_LINE('-----------+----------+-------+--------');

    FOR r IN (
        SELECT ID_SISTEMA,
               ANTERIOR,
               ATUAL,
               PROXIMO
        FROM (
            SELECT ID_SISTEMA,
                   CASE WHEN LAG_POT IS NULL THEN 'Vazio' ELSE TO_CHAR(LAG_POT) END AS ANTERIOR,
                   TO_CHAR(POTENCIA_ATUAL) AS ATUAL,
                   CASE WHEN LEAD_POT IS NULL THEN 'Vazio' ELSE TO_CHAR(LEAD_POT) END AS PROXIMO,
                   POTENCIA_ATUAL AS ORD_POT
            FROM (
                SELECT ID_SISTEMA,
                       POTENCIA_TOTAL AS POTENCIA_ATUAL,
                       LAG(POTENCIA_TOTAL) OVER (ORDER BY POTENCIA_TOTAL, ID_SISTEMA)  AS LAG_POT,
                       LEAD(POTENCIA_TOTAL) OVER (ORDER BY POTENCIA_TOTAL, ID_SISTEMA) AS LEAD_POT
                FROM SM_SISTEMA
            )
        )
        ORDER BY ORD_POT, ID_SISTEMA
    ) LOOP
        DBMS_OUTPUT.PUT_LINE(
            RPAD(r.ID_SISTEMA, 11) || ' | ' ||
            LPAD(r.ANTERIOR, 8) || ' | ' ||
            LPAD(r.ATUAL, 5) || ' | ' ||
            LPAD(r.PROXIMO, 8)
        );
        v_linhas := v_linhas + 1;
    END LOOP;

    IF v_linhas < 5 THEN
        RAISE e_relatorio_insuficiente;
    END IF;
EXCEPTION
    WHEN e_menos_de_cinco_linhas THEN
        DBMS_OUTPUT.PUT_LINE('Erro: é necessário ao menos 5 linhas em SM_SISTEMA para o relatório.');
    WHEN e_relatorio_insuficiente THEN
        DBMS_OUTPUT.PUT_LINE('Erro: o relatório gerou menos de 5 linhas (requisito da sprint).');
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('Erro inesperado em PROC_RELATORIO_POTENCIA_ANT_ATUAL_PROX: ' || SQLERRM);
END;
/
