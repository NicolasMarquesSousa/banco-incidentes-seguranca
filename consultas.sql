-- 1. Lista detalhada dos eventos de autenticação

SELECT
    eventos.id,
    usuarios.nome AS usuario,
    enderecos_ip.endereco AS endereco_ip,
    enderecos_ip.origem,
    eventos.data_hora,
    eventos.tipo,
    eventos.resultado
FROM eventos
INNER JOIN usuarios
    ON eventos.usuario_id = usuarios.id
INNER JOIN enderecos_ip
    ON eventos.endereco_ip_id = enderecos_ip.id
ORDER BY eventos.data_hora;

-- 2. Endereços IP com múltiplas falhas de autenticação

SELECT
    enderecos_ip.endereco AS endereco_ip,
    enderecos_ip.origem,
    COUNT(eventos.id) AS total_falhas,
    MIN(eventos.data_hora) AS primeira_falha,
    MAX(eventos.data_hora) AS ultima_falha
FROM eventos
INNER JOIN enderecos_ip
    ON eventos.endereco_ip_id = enderecos_ip.id
WHERE eventos.resultado = 'FALHA'
GROUP BY
    enderecos_ip.id,
    enderecos_ip.endereco,
    enderecos_ip.origem
HAVING COUNT(eventos.id) >= 2
ORDER BY total_falhas DESC;

-- 3. Eventos associados a cada incidente

SELECT
    incidentes.id AS incidente_id,
    incidentes.titulo,
    incidentes.gravidade,
    incidentes.status,
    eventos.id AS evento_id,
    eventos.data_hora,
    usuarios.nome AS usuario,
    enderecos_ip.endereco AS endereco_ip,
    eventos.resultado
FROM incidentes
INNER JOIN incidentes_eventos
    ON incidentes.id = incidentes_eventos.incidente_id
INNER JOIN eventos
    ON incidentes_eventos.evento_id = eventos.id
INNER JOIN usuarios
    ON eventos.usuario_id = usuarios.id
INNER JOIN enderecos_ip
    ON eventos.endereco_ip_id = enderecos_ip.id
ORDER BY
    incidentes.id,
    eventos.data_hora;

    -- 4. Resumo executivo dos incidentes

SELECT
    incidentes.id AS incidente_id,
    incidentes.titulo,
    incidentes.gravidade,
    incidentes.status,
    COUNT(eventos.id) AS total_eventos,
    GROUP_CONCAT(
        DISTINCT enderecos_ip.endereco
    ) AS ips_relacionados,
    MIN(eventos.data_hora) AS primeiro_evento,
    MAX(eventos.data_hora) AS ultimo_evento
FROM incidentes
LEFT JOIN incidentes_eventos
    ON incidentes.id = incidentes_eventos.incidente_id
LEFT JOIN eventos
    ON incidentes_eventos.evento_id = eventos.id
LEFT JOIN enderecos_ip
    ON eventos.endereco_ip_id = enderecos_ip.id
GROUP BY
    incidentes.id,
    incidentes.titulo,
    incidentes.gravidade,
    incidentes.status
ORDER BY
    CASE incidentes.gravidade
        WHEN 'CRITICA' THEN 1
        WHEN 'ALTA' THEN 2
        WHEN 'MEDIA' THEN 3
        WHEN 'BAIXA' THEN 4
    END,
    incidentes.aberto_em;


    -- 5. Resumo de autenticações por usuário

SELECT
    usuarios.id AS usuario_id,
    usuarios.nome AS usuario,
    COUNT(eventos.id) AS total_tentativas,
    SUM(
        CASE
            WHEN eventos.resultado = 'SUCESSO' THEN 1
            ELSE 0
        END
    ) AS sucessos,
    SUM(
        CASE
            WHEN eventos.resultado = 'FALHA' THEN 1
            ELSE 0
        END
    ) AS falhas,
    CASE
        WHEN SUM(
            CASE
                WHEN eventos.resultado = 'FALHA' THEN 1
                ELSE 0
            END
        ) >= 3 THEN 'ATENCAO'
        WHEN SUM(
            CASE
                WHEN eventos.resultado = 'FALHA' THEN 1
                ELSE 0
            END
        ) >= 1 THEN 'OBSERVAR'
        ELSE 'NORMAL'
    END AS classificacao
FROM usuarios
LEFT JOIN eventos
    ON usuarios.id = eventos.usuario_id
GROUP BY
    usuarios.id,
    usuarios.nome
ORDER BY
    falhas DESC,
    total_tentativas DESC;
