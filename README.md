# SolarMetrics 2.0 — Banco de dados (Oracle)

Entrega **Sprint 3** (FIAP / Challenge Oracle): DDL, dados (≥ 5 linhas por tabela), **2 funções** e **2 procedures** com três exceções cada, **trigger** de auditoria em `SM_SISTEMA`, roteiro de testes.

## Integrantes (ordem alfabética)

| Nome | RM | Turma |
|------|-----|--------|
| Édipo Borges de Carvalho | 567164 | 2TDSPS |
| Carlos Santiago Clementino | 561187 | 2TDSPR |
| Eder Silva | 559647 | 2TDSPR |

## Repositórios do projeto

- [.NET — SolarMetrics-Dotnet](https://github.com/ARC-ceo/SolarMetrics-Dotnet)
- [Java — SolarMetrics-JavaAdvanced](https://github.com/ARC-ceo/SolarMetrics-JavaAdvanced)

## Como executar (schema vazio)

1. `01_DDL.sql`
2. `02_Dados.sql`
3. `04_Functions.sql`
4. `05_Procedures.sql`
5. `06_Triggers_Auditoria.sql`
6. `07_Execucoes_Teste.sql` (demonstração / vídeo)

**Opcional (Sprint 2 — cursores):** entre `02` e as funções pipelined, execute `03_Types_se_necessario.sql` e em seguida `SolarMetrics_Cursores_Funcoes.sql`. A Sprint 3 (`04`–`07`) **não** depende do arquivo `03`.

**Auditoria:** com essa ordem, a carga de `02_Dados.sql` **não** gera linhas em `SM_AUDITORIA`. Para auditar também os inserts iniciais, execute `06_Triggers_Auditoria.sql` **antes** de `02_Dados.sql` (sempre após `01_DDL.sql`).

## Arquivos principais (Sprint 3)

| Arquivo | Conteúdo |
|---------|-----------|
| `01_DDL.sql` | Tabelas `SM_*`, sequência `SEQ_SM_AUDITORIA` |
| `02_Dados.sql` | Dados iniciais + `S20`/`SEN20` para scripts CRUD da Sprint 2 |
| `03_Types_se_necessario.sql` | Tipos `OBJECT` / nested `TABLE` para funções pipelined (Sprint 2); opcional para Sprint 3 |
| `04_Functions.sql` | `FN_JSON_LINHA_SISTEMA_SENSOR` (JSON manual), `FN_VALIDAR_POTENCIA_SISTEMA` |
| `05_Procedures.sql` | `PROC_RELATORIO_SISTEMA_SENSOR_JSON`, `PROC_RELATORIO_POTENCIA_ANT_ATUAL_PROX` |
| `06_Triggers_Auditoria.sql` | `TRG_AUDITORIA_SM_SISTEMA` |
| `07_Execucoes_Teste.sql` | Chamadas de teste e DML de exemplo |

## Opcional — Sprint 2

Execute após `01`, `02` e `04` (a função de potência vem de `04_Functions.sql`). Para cursores: `03` antes de `SolarMetrics_Cursores_Funcoes.sql`.

| Arquivo | Conteúdo |
|---------|-----------|
| `03_Types_se_necessario.sql` | Tipos para `FN_RELATORIO_*` (pipelined) |
| `SolarMetrics_Funcoes_Validacao.sql` | `FN_VALIDAR_EMAIL_USUARIO` |
| `SolarMetrics_Procedures_CRUD.sql` | Procedures CRUD |
| `SolarMetrics_Cursores_Funcoes.sql` | Funções pipelined (requer `03`) |

## Documentação e entrega


- **PDF** da disciplina: capa com nomes (alfabética) e RMs; link do repositório e do vídeo.
- **Vídeo:** seguir `07_Execucoes_Teste.sql` (áudio + resolução conforme critérios do challenge).

Referência de vídeo (substituir pelo link da Sprint 3 quando disponível): [YouTube](https://youtu.be/7BcSMc3xac4)
