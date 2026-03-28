CREATE OR REPLACE FUNCTION FN_VALIDAR_POTENCIA_SISTEMA (
    p_potencia_total NUMBER
)
RETURN VARCHAR2
IS
BEGIN
    IF p_potencia_total <= 0 THEN
        RETURN 'ERRO: Potência total inválida. Deve ser maior que zero.';
    ELSE
        RETURN 'Potência válida.';
    END IF;
END;

SELECT FN_VALIDAR_POTENCIA_SISTEMA(0) FROM DUAL;
-- Retorna: ERRO: Potência total inválida. Deve ser maior que zero.




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

SELECT FN_VALIDAR_EMAIL_USUARIO('arthur.algate@fiap.com') FROM DUAL;
-- Retorna: Email válido.


