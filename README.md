# ✈️ Dashboard de Inteligência Operacional & Resolução de SLA (Setor de Desembarque)

## 📌 Visão Geral do Projeto
Este projeto simula uma solução de inteligência de dados voltada para o setor de atendimento e logística de bagagens em aviação comercial (Lost & Found). O objetivo é monitorar o volume de ocorrências (extravios, avarias), medir o cumprimento dos prazos contratuais de atendimento (SLA) e mensurar o impacto financeiro com indenizações a passageiros.

---

## 🛠️ Tecnologias Utilizadas
* **Microsoft SQL Server:** Modelagem relacional, tratamento de dados e criação de Views para análise de SLA.
* **Power BI Desktop:** Modelagem de dados, criação de métricas avançadas em **DAX** e desenvolvimento de dashboard interativo.

---

## 🗄️ Estrutura do Banco de Dados (SQL Server)
O banco de dados foi construído seguindo o modelo estrela (Star Schema), contendo:
* `Dim_Passageiros`: Informações cadastrais e nível de fidelidade dos passageiros.
* `Dim_Rotas`: Origem, destino e região operacional.
* `Fato_Ocorrencias_Bagagem`: Ocorrências de bagagens, tipos de falha, horas de resolução e custos.
* `VW_ANALISE_BAGAGENS`: View analítica responsável pelo cálculo automatizado de regras de negócio de SLA.

---

## 📊 Indicadores Principais (KPIs e DAX)
* **Total de Ocorrências:** Quantidade total de chamados abertos.
* **% Dentro do SLA:** Percentual de casos resolvidos dentro do tempo limite contratual.
* **Casos Pendentes / Resolvidos:** Acompanhamento do backlog operacional.
* **Custo com Indenizações:** Impacto financeiro total acumulado.

---

## 💡 Insights de Negócio Identificados
1. **Causa Raiz Gargalo:** A *Falha na Conexão* representa o maior volume de ocorrências no setor.
2. **Impacto Financeiro:** A categoria *Perda Definitiva* é responsável pela maior fatia dos custos de indenização ($R\$ 2.800,00$ de um total de $R\$ 3.320,00$).
3. **Eficiência de SLA:** A taxa atual de cumprimento do SLA está em **66,67%**, apontando a necessidade de revisão no tempo de resposta das rotas de longa distância.

---

## 📸 Demonstração do Painel
*(Insira a foto/print do seu Dashboard aqui)*
