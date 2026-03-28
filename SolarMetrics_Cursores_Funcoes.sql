-- Projeto:       SolarMetrics 2.0
-- Sprint:        2 - Tópico 5 - Função com Cursor e JOINs
-- Função:        FN_RELATORIO_SISTEMAS_SENSORES
--
-- Descrição:
--   Função PL/SQL que retorna um relatório do tipo tabela (TABLE)
--   com a relação entre sistemas e sensores. A função utiliza um
--   cursor interno e realiza JOIN entre SM_SISTEMA e SM_SENSOR,
--   retornando as informações em formato tabular.


CREATE OR REPLACE TYPE T_RELATORIO_SISTEMA_SENSOR AS OBJECT (
    ID_SISTEMA        VARCHAR2(36),
    NOME_INSTALACAO   VARCHAR2(200),
    POTENCIA_TOTAL    NUMBER,
    ID_SENSOR         VARCHAR2(36),
    TIPO              VARCHAR2(50),
    STATUS            VARCHAR2(50)
);
/

CREATE OR REPLACE TYPE T_TABELA_RELATORIO_SISTEMA_SENSOR AS TABLE OF T_RELATORIO_SISTEMA_SENSOR;
/

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
-- Tópico 6 - Função com Regra de Negócio
-- Função:        FN_RELATORIO_SENSORES_POR_SISTEMA

-- Descrição:
--   Função PL/SQL que retorna um relatório detalhado com a 
--   contagem de sensores ATIVOS e INATIVOS por sistema, bem como 
--   a potência total de cada um.
--
-- Regras de Negócio:
--   - Um sistema pode ter vários sensores.
--   - A função realiza agregações (COUNT e SUM) e JOIN entre 
--     SM_SISTEMA e SM_SENSOR.
--   - O resultado é retornado no formato TABLE .


CREATE OR REPLACE TYPE T_RELATORIO_SENSORES AS OBJECT (
    ID_SISTEMA        VARCHAR2(36),
    NOME_INSTALACAO   VARCHAR2(200),
    QTD_ATIVOS        NUMBER,
    QTD_INATIVOS      NUMBER,
    POTENCIA_TOTAL    NUMBER
);
/

CREATE OR REPLACE TYPE T_TABELA_RELATORIO_SENSORES AS TABLE OF T_RELATORIO_SENSORES;
/

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

