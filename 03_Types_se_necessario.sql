-- ===============================================================
-- Projeto:       SolarMetrics 2.0
-- Sprint:        3 — Tipos objeto / nested table (quando necessário)
-- Uso:           Obrigatório antes de SolarMetrics_Cursores_Funcoes.sql
--                (funções pipelined TABLE). Não é exigido para 04–07.
-- Pré-requisito: 01_DDL.sql, 02_Dados.sql
-- ===============================================================
-- Recriação (laboratório): descomente o bloco DROP abaixo na ordem
-- inversa (tipo tabela aninhada antes do tipo objeto).

/*
DROP TYPE T_TABELA_RELATORIO_SENSORES FORCE;
DROP TYPE T_RELATORIO_SENSORES FORCE;
DROP TYPE T_TABELA_RELATORIO_SISTEMA_SENSOR FORCE;
DROP TYPE T_RELATORIO_SISTEMA_SENSOR FORCE;
*/

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
