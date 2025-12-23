# Test Plan – Automation Strategy/ Estrategia de Automação

**Apesar de não existir uma collection do Postman neste repositório, este documento descreve como os testes seriam implementados utilizando Postman e Newman assim que um ambiente real de homologação estivesse disponível.**

## 1. Objetivo

**Validar a implementação da API Resources (GET /resources) garantindo:**
- Conformidade com a especificação Open Finance Brasil v3.0.0
- Atendimento às regras regulatórias
- Integridade do contrato da API
- Comportamento correto frente às mudanças introduzidas nesta versão
**Este plano contempla testes funcionais, de contrato, negativos e regulatórios, com foco em automação via Postman + Newman.**

## 2. Escopo

**Em escopo**
- Endpoint: GET /resources
- Headers obrigatórios e opcionais
- Paginação (page, page-size)
- Enumerações (type, status)
- Validação de respostas por status HTTP
- Mudanças descritas no changelog v3.0.0
- Geração e validação de x-fapi-interaction-id
  
**Fora de escopo**
- Testes de performance
- Testes de segurança profunda (pentest)
- Fluxo completo de consentimento (assumido como pré-condição)

## 3. Referências
- Open Finance Brasil – DC Recursos v3.0.0
- Swagger / OAS 3.0
- Changelog oficial do endpoint GET /resources

## 4. Premissas
- Consentimento válido e no status AUTHORISED
- Token OAuth válido com escopo RESOURCES_READ
- Ambiente disponível e acessível
- Dados de teste previamente preparados

## 5. Ferramentas
- Postman: modelagem, execução e validação
- Newman: execução automatizada e integração CI
- JSON Schema Validation (quando aplicável)

## 6. Estratégia de Testes
- 6.1 Tipo de testes
  - Testes funcionais
  - Testes de contrato (schema + regras)
  - Testes regulatórios
  - Testes negativos
  - Testes de regressão (mudanças v3.0.0)

## 7. Estrutura de Automação no Postman
 **7.1 Pre-request Script** <br>
- Responsável por:
  - Gerar x-fapi-interaction-id (UUID v4 – RFC4122)
  - Armazenar em variável de ambiente
  - Reutilizar o valor para validação no response<br>

**Justificativa: exigência regulatória de correlação request/response.**

### 7.2 Headers Validados
- Obrigatórios:
  - Authorization
  - x-fapi-interaction-id
- Opcionais (quando aplicável):
  - x-fapi-auth-date
  - x-fapi-customer-ip-address
  - x-customer-user-agent

## 8. Cenários de Teste
**8.1 Cenários de Sucesso**
**GET /resources – 200 OK**<br>

- Validar:
  - Status code = 200
  - x-fapi-interaction-id retornado e igual ao enviado
- Body contém:
  - data[]
  - links
  - meta.requestDateTime
  - meta.totalRecords
  - meta.totalPages
**Cada item de data[]:**
  - resourceId válido
  - type ∈ enum (incluindo EXCHANGE)
  - status ∈ enum:
    - AVAILABLE
    - UNAVAILABLE
    - TEMPORARILY_UNAVAILABLE
    - PENDING_AUTHORISATION <br>

**GET /resources – 202 Accepted**
<br>
- Validar:
  - Status code = 202
  - Header x-fapi-interaction-id presente
  - Corpo sem data obrigatória
  - Usado quando a requisição foi aceita mas não processada imediatamente<br>

**Novo comportamento introduzido na v3.0.0**

### 8.2 Paginação (mudanças críticas)
**page-size**
- Validar:
  - Se page-size < 25 → API deve considerar 25
  - Default = 25 quando não informado
  - Somente última página pode retornar < 25 registros
  - meta.totalPages consistente com totalRecords

### 8.3 Testes de Erro / Negativos
 **400 – Bad Request**
- Exemplos:
  - x-fapi-interaction-id ausente
  - x-fapi-interaction-id inválido (não UUID)<br>
**Query params inválidos**
- Validar:
  - errors[]
  - meta.requestDateTime
  - Não deve conter totalRecords nem totalPages

 **401 – Unauthorized**
- Token ausente ou inválido

**403 – Forbidden**
- Token válido, mas sem escopo RESOURCES_READ

**404 – Not Found**
- Endpoint inexistente

**406 – Not Acceptable**
- Header Accept diferente de application/json; charset=utf-8

**429 – Too Many Requests**
- Rate limit excedido

**5xx – Erros de servidor**
- Estrutura de erro conforme padrão
- Sem campos removidos no changelog

## 9. Validações Regulatórias Importantes
**API disponível apenas para consentimentos AUTHORISED**
- resourceId deve corresponder ao ID da API específica:
  - accountId
  - creditCardAccountId
  - contractId
  - investmentId
  - operationId (EXCHANGE)
- Campos totalRecords e totalPages:
  - Apenas no 200
  - Não devem existir em erros

## 10. Execução Automatizada (Newman)
A collection será:
- Executável localmente
- Integrável em pipeline CI/CD
- Geradora de evidências (logs + reports)<br>

**Isso garante repetibilidade, rastreabilidade e conformidade regulatória.**

## 11. Riscos
- Instabilidade de ambiente
- Dados inconsistentes
- Consentimentos expirados
  - Mitigação:
    - Dados controlados
    - Reexecução automatizada
    - Logs detalhados via Newman

## 12. Critérios de Aceite
- 100% dos testes críticos aprovados
- Nenhuma quebra de contrato
- Conformidade total com v3.0.0


