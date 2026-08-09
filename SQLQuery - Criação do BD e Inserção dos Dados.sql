-- 1. Criação do Banco de Dados
CREATE DATABASE DB_LOGISTICA_AEREA;
GO

USE DB_LOGISTICA_AEREA;
GO

-- 2. Tabela Dimensão: Passagens/Passageiros
CREATE TABLE Dim_Passageiros (
    ID_Passageiro INT PRIMARY KEY IDENTITY(1,1),
    Nome_Passageiro VARCHAR(100),
    Categoria_Fidelidade VARCHAR(20) -- Gold, Platinum, Black, Regular
);

-- 3. Tabela Dimensão: Rotas e Aeroportos
CREATE TABLE Dim_Rotas (
    ID_Rota INT PRIMARY KEY IDENTITY(1,1),
    Aeroporto_Origem VARCHAR(3),
    Aeroporto_Destino VARCHAR(3),
    Regiao VARCHAR(20)
);

-- 4. Tabela Fato: Ocorrências de Bagagem (Lost & Found / Damage)
CREATE TABLE Fato_Ocorrencias_Bagagem (
    ID_Ocorrencia INT PRIMARY KEY IDENTITY(1001,1),
    ID_Passageiro INT FOREIGN KEY REFERENCES Dim_Passageiros(ID_Passageiro),
    ID_Rota INT FOREIGN KEY REFERENCES Dim_Rotas(ID_Rota),
    Data_Ocorrencia DATE,
    Data_Resolucao DATE NULL,
    Tipo_Ocorrencia VARCHAR(50), -- Extravio Temporario, Avaria, Perda Definitiva
    Causa_Raiz VARCHAR(100),     -- Falha na Conexao, Etiqueta Danificada, Erro de Triagem, Rampa
    Status_Caso VARCHAR(20),     -- Resolvido, Em Andamento, Indenizado
    SLA_Horas_Limite INT,        -- Prazo contratual de resolucao (ex: 24h, 48h)
    Tempo_Resolucao_Horas INT NULL,
    Custo_Indenizacao_BRL DECIMAL(10,2) DEFAULT 0.00
);
GO

USE DB_LOGISTICA_AEREA;
GO

-- Inserindo Passagens
INSERT INTO Dim_Passageiros (Nome_Passageiro, Categoria_Fidelidade) VALUES
('Carlos Silva', 'Black'),
('Mariana Souza', 'Gold'),
('Roberto Alves', 'Regular'),
('Fernanda Lima', 'Platinum'),
('Lucas Mendes', 'Regular'),
('Juliana Paes', 'Black'),
('Ricardo Rocha', 'Regular'),
('Beatriz Costa', 'Gold');

-- Inserindo Rotas Operacionais
INSERT INTO Dim_Rotas (Aeroporto_Origem, Aeroporto_Destino, Regiao) VALUES
('GRU', 'BSB', 'Centro-Oeste'),
('GRU', 'FOR', 'Nordeste'),
('BSB', 'GYN', 'Centro-Oeste'),
('GIG', 'SSA', 'Nordeste'),
('CGH', 'SDU', 'Sudeste'),
('GRU', 'MAO', 'Norte');

-- Inserindo Ocorrências
INSERT INTO Fato_Ocorrencias_Bagagem 
(ID_Passageiro, ID_Rota, Data_Ocorrencia, Data_Resolucao, Tipo_Ocorrencia, Causa_Raiz, Status_Caso, SLA_Horas_Limite, Tempo_Resolucao_Horas, Custo_Indenizacao_BRL) 
VALUES
(1, 1, '2026-07-01', '2026-07-01', 'Extravio Temporario', 'Falha na Conexao', 'Resolvido', 24, 12, 0.00),
(2, 2, '2026-07-02', '2026-07-05', 'Extravio Temporario', 'Erro de Triagem', 'Resolvido', 48, 72, 250.00), -- SLA Estourado
(3, 3, '2026-07-03', '2026-07-03', 'Avaria', 'Rampa', 'Resolvido', 24, 8, 150.00),
(4, 1, '2026-07-05', NULL, 'Extravio Temporario', 'Falha na Conexao', 'Em Andamento', 24, NULL, 0.00),
(5, 4, '2026-07-06', '2026-07-15', 'Perda Definitiva', 'Etiqueta Danificada', 'Indenizado', 72, 216, 2800.00),
(6, 5, '2026-07-08', '2026-07-09', 'Avaria', 'Rampa', 'Resolvido', 24, 18, 120.00),
(7, 2, '2026-07-10', '2026-07-11', 'Extravio Temporario', 'Falha na Conexao', 'Resolvido', 24, 20, 0.00),
(8, 6, '2026-07-12', NULL, 'Extravio Temporario', 'Erro de Triagem', 'Em Andamento', 48, NULL, 0.00);
GO

USE DB_LOGISTICA_AEREA;
GO

CREATE VIEW VW_ANALISE_BAGAGENS AS
SELECT 
    F.ID_Ocorrencia,
    P.Nome_Passageiro,
    P.Categoria_Fidelidade,
    R.Aeroporto_Origem + '-' + R.Aeroporto_Destino AS Rota,
    R.Regiao,
    F.Data_Ocorrencia,
    F.Tipo_Ocorrencia,
    F.Causa_Raiz,
    F.Status_Caso,
    F.SLA_Horas_Limite,
    F.Tempo_Resolucao_Horas,
    F.Custo_Indenizacao_BRL,
    CASE 
        WHEN F.Status_Caso = 'Em Andamento' THEN 'Pendente'
        WHEN F.Tempo_Resolucao_Horas <= F.SLA_Horas_Limite THEN 'Dentro do SLA'
        ELSE 'SLA Estourado'
    END AS Status_SLA
FROM Fato_Ocorrencias_Bagagem F
INNER JOIN Dim_Passageiros P ON F.ID_Passageiro = P.ID_Passageiro
INNER JOIN Dim_Rotas R ON F.ID_Rota = R.ID_Rota;
GO

--TABELA COM OS DADOS DOS PASSAGEIROS
SELECT *
FROM Dim_Passageiros

--TABELA COM OS DADOS DAS ROTAS
SELECT *
FROM Dim_Rotas

--TABELA COM AS OCORRÊNCIAS COM AS BAGAGENS
SELECT *
FROM Fato_Ocorrencias_Bagagem

