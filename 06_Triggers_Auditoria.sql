-- ===============================================================
-- Projeto:       SolarMetrics 2.0
-- Sprint:        3 - Trigger de auditoria (INSERT/UPDATE/DELETE)
-- Pré-requisito: 01_DDL.sql (SEQ_SM_AUDITORIA, SM_AUDITORIA)
-- Ordem:         Após 02 para não auditar carga; antes de 02 para auditar inserts da carga.
-- ===============================================================

CREATE OR REPLACE TRIGGER TRG_AUDITORIA_SM_SISTEMA
    AFTER INSERT OR UPDATE OR DELETE ON SM_SISTEMA
    FOR EACH ROW
DECLARE
    v_id     NUMBER;
    v_old_cl CLOB;
    v_new_cl CLOB;
BEGIN
    v_id := SEQ_SM_AUDITORIA.NEXTVAL;

    IF INSERTING THEN
        v_new_cl :=
            'ID_SISTEMA=' || :NEW.ID_SISTEMA || CHR(10) ||
            'NOME_INSTALACAO=' || :NEW.NOME_INSTALACAO || CHR(10) ||
            'DATA_INSTALACAO=' || TO_CHAR(:NEW.DATA_INSTALACAO, 'YYYY-MM-DD') || CHR(10) ||
            'POTENCIA_TOTAL=' || TO_CHAR(:NEW.POTENCIA_TOTAL) || CHR(10) ||
            'STATUS=' || :NEW.STATUS || CHR(10) ||
            'SM_USUARIO_ID_USER=' || :NEW.SM_USUARIO_ID_USER || CHR(10) ||
            'SM_END_SISTEMA_ID_END_SIS=' || :NEW.SM_END_SISTEMA_ID_END_SIS;

        INSERT INTO SM_AUDITORIA (
            ID_AUDITORIA, NOME_TABELA, OPERACAO, USUARIO_ORACLE,
            DATA_OPERACAO, DADOS_OLD, DADOS_NEW
        ) VALUES (
            v_id, 'SM_SISTEMA', 'INSERT', USER, SYSTIMESTAMP, NULL, v_new_cl
        );
    ELSIF DELETING THEN
        v_old_cl :=
            'ID_SISTEMA=' || :OLD.ID_SISTEMA || CHR(10) ||
            'NOME_INSTALACAO=' || :OLD.NOME_INSTALACAO || CHR(10) ||
            'DATA_INSTALACAO=' || TO_CHAR(:OLD.DATA_INSTALACAO, 'YYYY-MM-DD') || CHR(10) ||
            'POTENCIA_TOTAL=' || TO_CHAR(:OLD.POTENCIA_TOTAL) || CHR(10) ||
            'STATUS=' || :OLD.STATUS || CHR(10) ||
            'SM_USUARIO_ID_USER=' || :OLD.SM_USUARIO_ID_USER || CHR(10) ||
            'SM_END_SISTEMA_ID_END_SIS=' || :OLD.SM_END_SISTEMA_ID_END_SIS;

        INSERT INTO SM_AUDITORIA (
            ID_AUDITORIA, NOME_TABELA, OPERACAO, USUARIO_ORACLE,
            DATA_OPERACAO, DADOS_OLD, DADOS_NEW
        ) VALUES (
            v_id, 'SM_SISTEMA', 'DELETE', USER, SYSTIMESTAMP, v_old_cl, NULL
        );
    ELSE
        v_old_cl :=
            'ID_SISTEMA=' || :OLD.ID_SISTEMA || CHR(10) ||
            'NOME_INSTALACAO=' || :OLD.NOME_INSTALACAO || CHR(10) ||
            'DATA_INSTALACAO=' || TO_CHAR(:OLD.DATA_INSTALACAO, 'YYYY-MM-DD') || CHR(10) ||
            'POTENCIA_TOTAL=' || TO_CHAR(:OLD.POTENCIA_TOTAL) || CHR(10) ||
            'STATUS=' || :OLD.STATUS || CHR(10) ||
            'SM_USUARIO_ID_USER=' || :OLD.SM_USUARIO_ID_USER || CHR(10) ||
            'SM_END_SISTEMA_ID_END_SIS=' || :OLD.SM_END_SISTEMA_ID_END_SIS;

        v_new_cl :=
            'ID_SISTEMA=' || :NEW.ID_SISTEMA || CHR(10) ||
            'NOME_INSTALACAO=' || :NEW.NOME_INSTALACAO || CHR(10) ||
            'DATA_INSTALACAO=' || TO_CHAR(:NEW.DATA_INSTALACAO, 'YYYY-MM-DD') || CHR(10) ||
            'POTENCIA_TOTAL=' || TO_CHAR(:NEW.POTENCIA_TOTAL) || CHR(10) ||
            'STATUS=' || :NEW.STATUS || CHR(10) ||
            'SM_USUARIO_ID_USER=' || :NEW.SM_USUARIO_ID_USER || CHR(10) ||
            'SM_END_SISTEMA_ID_END_SIS=' || :NEW.SM_END_SISTEMA_ID_END_SIS;

        INSERT INTO SM_AUDITORIA (
            ID_AUDITORIA, NOME_TABELA, OPERACAO, USUARIO_ORACLE,
            DATA_OPERACAO, DADOS_OLD, DADOS_NEW
        ) VALUES (
            v_id, 'SM_SISTEMA', 'UPDATE', USER, SYSTIMESTAMP, v_old_cl, v_new_cl
        );
    END IF;
END;
/
