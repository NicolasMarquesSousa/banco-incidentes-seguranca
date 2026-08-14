-- Estrutura das tabelas será construída durante as aulas práticas.

PRAGMA foreign_keys = ON;

CREATE TABLE usuarios (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    nome VARCHAR(100) NOT NULL,
    email VARCHAR(150) NOT NULL UNIQUE,
    perfil VARCHAR(30) NOT NULL,
    ativo BOOLEAN NOT NULL DEFAULT 1
);

CREATE TABLE enderecos_ip (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    endereco VARCHAR(45) NOT NULL UNIQUE,
    origem VARCHAR(100),
    confiavel BOOLEAN NOT NULL DEFAULT 0
);

CREATE TABLE eventos (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    usuario_id INTEGER NOT NULL,
    endereco_ip_id INTEGER NOT NULL,
    data_hora DATETIME NOT NULL,
    tipo VARCHAR(50) NOT NULL,
    resultado VARCHAR(20) NOT NULL
        CHECK (resultado IN ('SUCESSO', 'FALHA')),

    FOREIGN KEY (usuario_id)
        REFERENCES usuarios(id),

    FOREIGN KEY (endereco_ip_id)
        REFERENCES enderecos_ip(id)
);

CREATE TABLE incidentes (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    titulo VARCHAR(150) NOT NULL,
    descricao TEXT,
    gravidade VARCHAR(20) NOT NULL
        CHECK (gravidade IN ('BAIXA', 'MEDIA', 'ALTA', 'CRITICA')),
    status VARCHAR(20) NOT NULL DEFAULT 'ABERTO'
        CHECK (status IN ('ABERTO', 'INVESTIGANDO', 'RESOLVIDO')),
    aberto_em DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    encerrado_em DATETIME
);

CREATE TABLE incidentes_eventos (
    incidente_id INTEGER NOT NULL,
    evento_id INTEGER NOT NULL,
    adicionado_em DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,

    PRIMARY KEY (incidente_id, evento_id),

    FOREIGN KEY (incidente_id)
        REFERENCES incidentes(id)
        ON DELETE CASCADE,

    FOREIGN KEY (evento_id)
        REFERENCES eventos(id)
        ON DELETE CASCADE
);
