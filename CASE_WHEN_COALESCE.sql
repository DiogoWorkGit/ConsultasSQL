--Traga do banco as seguintes informações:
--  Código do Cliente,
--  Nome do Cliente,
--  Tipo do Cliente ('Pessoa Jurídica' ou 'Pessoa Física')
--  CGC/CPF (Se o cliente for PF traga o CPF, se PJ, traga o CNPJ)
--  Data de Nascimento (apenas para PF)
--  Idade do cliente (apenas para PF)
--  Faixa etária do cliente ('até 10 anos'
--                           '11 a 20 anos'
--                           '21 a 30 anos'
--                           '31 a 40 anos'
--                           '41 a 50 anos'
--                           '51 a 60 anos'
--                           '60 anos ou mais')
--  Data de fundação (apenas PJ)
--  Endereço atual completo.
--  Quantidade de Estrelas,
--  Email


SELECT
    C.NR_CLIENTE AS "Código do Cliente",
    C.NM_CLIENTE AS "Nome do Cliente",
    CASE
        WHEN CF.NR_CPF IS NOT NULL THEN 'Pessoa Física'
        WHEN CJ.NR_CNPJ IS NOT NULL THEN 'Pessoa Jurídica'
        ELSE 'Tipo não identificado'
    END AS "Tipo do Cliente",
    COALESCE(CF.NR_CPF, CJ.NR_CNPJ) AS "CGC/CPF/CNPJ",
    CF.DT_NASCIMENTO AS "Data de Nascimento",
    CASE
        WHEN CF.DT_NASCIMENTO IS NOT NULL THEN TRUNC(MONTHS_BETWEEN(SYSDATE, CF.DT_NASCIMENTO) / 12)
        ELSE NULL
    END AS "Idade do cliente",
    CASE
        WHEN CF.DT_NASCIMENTO IS NOT NULL THEN
            CASE
                WHEN TRUNC(MONTHS_BETWEEN(SYSDATE, CF.DT_NASCIMENTO) / 12) <= 10 THEN 'até 10 anos'
                WHEN TRUNC(MONTHS_BETWEEN(SYSDATE, CF.DT_NASCIMENTO) / 12) BETWEEN 11 AND 20 THEN '11 a 20 anos'
                WHEN TRUNC(MONTHS_BETWEEN(SYSDATE, CF.DT_NASCIMENTO) / 12) BETWEEN 21 AND 30 THEN '21 a 30 anos'
                WHEN TRUNC(MONTHS_BETWEEN(SYSDATE, CF.DT_NASCIMENTO) / 12) BETWEEN 31 AND 40 THEN '31 a 40 anos'
                WHEN TRUNC(MONTHS_BETWEEN(SYSDATE, CF.DT_NASCIMENTO) / 12) BETWEEN 41 AND 50 THEN '41 a 50 anos'
                WHEN TRUNC(MONTHS_BETWEEN(SYSDATE, CF.DT_NASCIMENTO) / 12) BETWEEN 51 AND 60 THEN '51 a 60 anos'
                ELSE '60 anos ou mais'
            END
        ELSE NULL
    END AS "Faixa etária do cliente",
    CJ.DT_FUNDACAO AS "Data de Fundação",
    L.NM_LOGRADOURO || ', ' || EC.NR_END || ', ' || B.NM_BAIRRO || ', ' || CI.NM_CIDADE || ' - ' || E.NM_ESTADO || ' (' || E.SG_ESTADO || '), ' || L.NR_CEP  AS "Endereço completo",
    C.QT_ESTRELAS AS "Quantidade de Estrelas",
    C.DS_EMAIL AS "Email"
FROM
    DB_CLIENTE C
LEFT JOIN
    DB_CLI_FISICA CF ON C.NR_CLIENTE = CF.NR_CLIENTE
LEFT JOIN
    DB_CLI_JURIDICA CJ ON C.NR_CLIENTE = CJ.NR_CLIENTE
LEFT JOIN
    DB_END_CLI EC ON C.NR_CLIENTE = EC.NR_CLIENTE
LEFT JOIN
    DB_LOGRADOURO L ON EC.CD_LOGRADOURO_CLI = L.CD_LOGRADOURO
LEFT JOIN
    DB_BAIRRO B ON L.CD_BAIRRO = B.CD_BAIRRO
LEFT JOIN
    DB_CIDADE CI ON B.CD_CIDADE = CI.CD_CIDADE
LEFT JOIN
    DB_ESTADO E ON CI.SG_ESTADO = E.SG_ESTADO
ORDER BY C.NR_CLIENTE ASC; 

