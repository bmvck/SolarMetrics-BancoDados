-- ===============================================================
-- Projeto:       SolarMetrics 2.0
-- Sprint:        2 — função auxiliar de e-mail
-- Importante:    FN_VALIDAR_POTENCIA_SISTEMA está em 04_Functions.sql (Sprint 3).
-- Ordem:         Após 01_DDL, 02_Dados e 04_Functions.sql
-- ===============================================================

CREATE OR REPLACE FUNCTION FN_VALIDAR_EMAIL_USUARIO (
    p_email VARCHAR2
)
RETURN VARCHAR2
IS
BEGIN
    IF INSTR(p_email, '@') = 0 OR INSTR(p_email, '.') = 0 THEN
        RETURN 'ERRO: Email inválido.';
    ELSE
        RETURN 'Email válido.';
    END IF;
END;
/

SELECT FN_VALIDAR_EMAIL_USUARIO('arthur.algate@fiap.com') FROM DUAL;
