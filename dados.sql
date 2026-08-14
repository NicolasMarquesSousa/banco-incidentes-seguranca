-- Usuários fictícios utilizados nas análises

INSERT INTO usuarios (nome, email, perfil)
VALUES
    ('Nicolas Marques', 'nicolas@example.com', 'ANALISTA'),
    ('Maria Oliveira', 'maria@example.com', 'ADMINISTRADORA'),
    ('Joao Santos', 'joao@example.com', 'USUARIO');

    -- Endereços IP fictícios

INSERT INTO enderecos_ip (endereco, origem, confiavel)
VALUES
    ('192.168.1.10', 'Rede interna', 1),
    ('192.168.1.25', 'Rede interna', 0),
    ('203.0.113.50', 'Internet', 0);

    -- Eventos de autenticação fictícios

INSERT INTO eventos (
    usuario_id,
    endereco_ip_id,
    data_hora,
    tipo,
    resultado
)
VALUES
    (1, 1, '2026-08-13 08:10:15', 'LOGIN', 'SUCESSO'),
    (2, 2, '2026-08-13 08:12:03', 'LOGIN', 'FALHA'),
    (2, 2, '2026-08-13 08:12:10', 'LOGIN', 'FALHA'),
    (2, 2, '2026-08-13 08:12:18', 'LOGIN', 'FALHA'),
    (3, 3, '2026-08-13 08:20:41', 'LOGIN', 'FALHA'),
    (3, 1, '2026-08-13 08:26:30', 'LOGIN', 'SUCESSO');
    
    -- Incidentes identificados durante a análise

INSERT INTO incidentes (
    titulo,
    descricao,
    gravidade,
    status,
    aberto_em
)
VALUES
    (
        'Possível ataque de força bruta',
        'Três falhas consecutivas de autenticação originadas pelo mesmo endereço IP.',
        'ALTA',
        'INVESTIGANDO',
        '2026-08-13 08:13:00'
    ),
    (
        'Falha de autenticação externa',
        'Tentativa de acesso malsucedida originada por endereço IP da internet.',
        'MEDIA',
        'ABERTO',
        '2026-08-13 08:21:00'
    );

    -- Associação entre incidentes e eventos relacionados

INSERT INTO incidentes_eventos (
    incidente_id,
    evento_id
)
VALUES
    (1, 2),
    (1, 3),
    (1, 4),
    (2, 5);
