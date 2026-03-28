-- Projeto:       SolarMetrics 2.0
-- Sprint:        2 - Funções pipelined (TABLE) com JOINs
-- Pré-requisitos: 01_DDL.sql, 02_Dados.sql, 03_Types_se_necessario.sql
--
-- Descrição:
--   Relatórios tabulares via PIPELINED. Os tipos OBJECT / TABLE estão em
--   03_Types_se_necessario.sql.

CREATE OR REPLACE FUNCTION FN_RELATORIO_SISTEMAS_SENSORES
RETURN T_TABELA_RELATORIO_SISTEMA_SENSOR PIPELINED
IS
BEGIN
    FOR reg IN (
        SELECT
            s.ID_SISTEMA,
            s.NOME_INSTALACAO,
            s.POTENCIA_TOTAL,
            se.ID_SENSOR,
            se.TIPO,
            se.STATUS
        FROM SM_SISTEMA s
        JOIN SM_SENSOR se
            ON s.ID_SISTEMA = se.SM_SISTEMA_ID_SISTEMA
        ORDER BY s.ID_SISTEMA
    ) LOOP
        PIPE ROW (
            T_RELATORIO_SISTEMA_SENSOR(
                reg.ID_SISTEMA,
                reg.NOME_INSTALACAO,
                reg.POTENCIA_TOTAL,
                reg.ID_SENSOR,
                reg.TIPO,
                reg.STATUS
            )
        );
    END LOOP;
    RETURN;
END;
/

SELECT * FROM TABLE(FN_RELATORIO_SISTEMAS_SENSORES);


-- ===============================================================
-- Tópico 6 - Função com regra de negócio
-- Função: FN_RELATORIO_SENSORES_POR_SISTEMA
-- ===============================================================

CREATE OR REPLACE FUNCTION FN_RELATORIO_SENSORES_POR_SISTEMA
RETURN T_TABELA_RELATORIO_SENSORES PIPELINED
IS
BEGIN
    FOR reg IN (
        SELECT
            s.ID_SISTEMA,
            s.NOME_INSTALACAO,
            SUM(CASE WHEN se.STATUS = 'ATIVO' THEN 1 ELSE 0 END) AS QTD_ATIVOS,
            SUM(CASE WHEN se.STATUS = 'INATIVO' THEN 1 ELSE 0 END) AS QTD_INATIVOS,
            s.POTENCIA_TOTAL
        FROM SM_SISTEMA s
        LEFT JOIN SM_SENSOR se
            ON s.ID_SISTEMA = se.SM_SISTEMA_ID_SISTEMA
        GROUP BY s.ID_SISTEMA, s.NOME_INSTALACAO, s.POTENCIA_TOTAL
        ORDER BY s.NOME_INSTALACAO
    ) LOOP
        PIPE ROW (
            T_RELATORIO_SENSORES(
                reg.ID_SISTEMA,
                reg.NOME_INSTALACAO,
                reg.QTD_ATIVOS,
                reg.QTD_INATIVOS,
                reg.POTENCIA_TOTAL
            )
        );
    END LOOP;
    RETURN;
END;
/

SELECT * FROM TABLE(FN_RELATORIO_SENSORES_POR_SISTEMA);
