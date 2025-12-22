# Test Plan – API Resources (GET /resources) - Atualização baseada Changelog - [DC] Recursos - v3.0.0 - v2.1.0 #

### 1. Visão Geral
Este plano de testes cobre a API Resources do Open Finance Brasil, versão v3.0.0, responsável por retornar a lista de recursos consentidos pelo cliente, considerando status do consentimento e disponibilidade do recurso na instituição transmissora.
A API é exclusivamente informativa, criada para dar visibilidade de impedimentos no compartilhamento de recursos. Seu uso é permitido apenas quando o consentimento estiver no status AUTHORISED.

### 2. Escopo
**Em escopo**
- Endpoint: GET /resources
- Validação de headers obrigatórios e opcionais
- Validação de permissões (RESOURCES_READ)
- Validação de paginação
- Validação de payload de sucesso (200)
- Validação de todos os cenários de erro documentados
- Validação de regras regulatórias (x-regulatory-required)
- Validação das alterações introduzidas na versão v3.0.0<br>
**Fora de escopo**
- Criação de consentimento
- Fluxo OAuth completo (assumido como pré-condição)
- Testes de APIs dependentes (accounts, credit-cards, etc.)

### 3. Referências
- Documentação oficial Open Finance Brasil – DC Recursos v3.0.0
- Swagger / OpenAPI v3.0.0
- Changelog v3.0.0

### 4. Premissas e Dependências
- Consentimento válido previamente criado
- Consentimento no status AUTHORISED
- Token OAuth2 válido com escopo resources
- Permission RESOURCES_READ concedida
- Ambiente de homologação disponível

### 5. Ambiente de Teste

As URLs apresentadas na documentação oficial do Open Finance Brasil são apenas exemplos ilustrativos (**placeholders**) e não representam ambientes reais de homologação ou produção, uma vez que instituições financeiras não expõem publicamente seus endpoints.

- Exemplo de URL documentada:  
  https://api.banco.com.br/open-banking/api/v1/resource

- Ferramenta utilizada para modelagem e validação:  
  Postman

**Observação:**  
O erro `getaddrinfo ENOTFOUND` indica indisponibilidade de DNS ou inexistência do endpoint, não caracterizando um defeito funcional da API ou da implementação proposta.


## 6. Endpoint em Teste
GET /resources <br>
**Headers obrigatórios:**

- Authorization
- x-fapi-interaction-id (UUID RFC4122 – obrigatório)
  
**Headers opcionais:** 
- x-fapi-auth-date
- x-fapi-customer-ip-address
- x-customer-user-agent
  
**Query Params:**
- page (default: 1)
- page-size (mínimo: 25 | máximo: 1000)

## 7. Regras de Negócio Críticas
- A API **NÃO** deve responder para consentimentos diferentes de **AUTHORISED**
- x-fapi-interaction-id é **obrigatório** e deve ser **espelhado na resposta**
- **page-size menor que 25 deve ser tratado como 25**
- O campo **resourceId, type e status são regulatórios obrigatórios**
- O **status do recurso não depende apenas do consentimento, mas também da disponibilidade do recurso**

## 8. Cenários de Teste – Sucesso

**CT01 – Listar recursos com sucesso**

- Consentimento: AUTHORISED
- Permission: RESOURCES_READ
- Resultado esperado:
    - HTTP 200
    - Lista de recursos
    - Meta com totalRecords e totalPages
      
**CT02 – Lista vazia de recursos**

- Consentimento AUTHORISED
- Nenhum recurso vinculado
- Resultado esperado:
    - HTTP 200
    - data: []

## 9. Cenários de Teste – Status de Recursos

**CT03 – Validação dos status dos recursos**<br>
- AVAILABLE
- UNAVAILABLE
- TEMPORARILY_UNAVAILABLE
- PENDING_AUTHORISATION<br>
  **Validar:**
- Enum correto
- Regra de negócio descrita no swagger

## 10. Cenários de Teste – Paginação

**CT04 – page-size menor que 25** <br>
- Enviar page-size=10
- Resultado esperado:
  - API trata como 25 <br>
      
**CT05 – Navegação entre páginas** 
- page=1, page=2
- Validação dos links: self, first, prev, next, last

## 11. Cenários de Teste – Validação de Headers

**CT06 – Ausência de Authorization**

- Resultado esperado: 401<br>

**CT07 – x-fapi-interaction-id ausente**

- Resultado esperado: 400<br>

**CT08 – x-fapi-interaction-id inválido**

- Resultado esperado: 400<br>

## 12. Cenários de Teste – Permissões e Segurança

**CT09 – Token sem RESOURCES_READ**
- Resultado esperado: 403 <br>
**CT10 – Consentimento não AUTHORISED**
- Resultado esperado: 403 ou 401 (conforme implementação) <br>

## 13. Cenários de Teste – Erros HTTP

 **CT11 – 400 – Bad Request** <br>
 **CT12 – 401 – Unauthorized** <br>
 **CT13 – 403 – Forbidden** <br>
 **CT14 – 404 – Not Found** <br>
 **CT15 – 405 – Method Not Allowed** <br>
 **CT16 – 406 – Not Acceptable** <br>
 **CT17 – 429 – Too Many Requests** <br>
 **CT18 – 500 – Internal Server Error** <br>
 **CT19 – 504 – Gateway Timeout** <br>
 **CT10 – 529 – Site Is Overloaded** <br>
 **CT21 – default – Erro inesperado** <br>

**Validar:**
  - Estrutura padrão de erro
  - Campo meta.requestDateTime

## 14. Estratégia de Testes

- Testes manuais iniciais no Postman
- Automação futura via coleção Postman + Newman
- Evolução para BDD (Cucumber / Gherkin)

## 15. Riscos

- Dependência de consentimentos válidos
- Instabilidade de ambiente de homologação
- Ambiguidade entre erro funcional e erro de infraestrutura

## 16. Validação das Mudanças – GET /resources (v3.0.0)
**Esta seção descreve como as alterações introduzidas na versão v3.0.0 impactam os cenários de teste existentes e quais novos cenários são necessários.**

### 16.1 Alterações em Query Parameters – page-size

_Reutilização de cenários existentes_

**As mudanças impactam diretamente:**
- CT04 – page-size menor que 25
- CT05 – Navegação entre páginas

**Regras atualizadas:**
  - Valor mínimo alterado de 1 para 25
  - Valores menores que 25 devem ser tratados como 25 <br>
  
**Apenas a última página pode retornar menos de 25 registros**

### 16.2 Alterações no Header x-fapi-interaction-id

_Reutilização de cenários existentes_

**As mudanças impactam:**
- CT06 – Ausência de Authorization
- CT07 – x-fapi-interaction-id ausente
- CT08 – x-fapi-interaction-id inválido

 **Regras atualizadas:**
  - Header obrigatório
  - Formato UUID RFC4122
  - maxLength = 36
  - Espelhamento do valor na resposta

### 16.3 IInclusão do HTTP Status 202

_Novo cenário necessário_

**CT22 – Resposta HTTP 202 Accepted** <br>
- Requisição aceita, mas não processada imediatamente
- **Resultado esperado:**
  - HTTP 202
  - Header x-fapi-interaction-id presente
  - Corpo conforme schema definido no contrato

### 16.4 AAlterações no Payload – Campos Regulatórios

 _Novo cenário necessário_
 
 **CT23 – Validação do campo x-regulatory-required** <br>
* Validar presença do campo em todos os itens de data[]
* Garantir que campos regulatórios nunca sejam omitidos

### 16.5 AAlterações no resourceId

_Novo cenário necessário_

**CT24 – Validação do mapeamento resourceId por tipo**
- resourceId deve corresponder à API específica:
  - accountId 
  - creditCardAccountId
  - contractId
  - investmentId
  - operationId (EXCHANGE)

### 16.6 Alterações no Enum type

_Novo cenário necessário_

**CT25 – Validação do enum type**
- Validar aceitação do valor EXCHANGE
- Validar rejeição de valores fora do enum

### 16.7 AAlterações no Header de Resposta x-fapi-interaction-id

_Novo cenário necessário_

**CT26 – Validação do header x-fapi-interaction-id na resposta**
- Header presente na resposta
- Formato UUID RFC4122
- Valor espelhado em relação ao request

### 16.8 Alterações nos Responses de Erro – Meta

_Reutilização de cenários existentes_

**As mudanças impactam:**

**CT11 a CT21 – Cenários de Erro HTTP** <br>

**Validações:**
- Respostas de erro NÃO devem conter:
  - totalRecords
  - totalPages

## 17. Conclusão
**Este Test Plan garante cobertura funcional, regulatória e contratual completa da API Resources v3.0.0, contemplando tanto a reutilização de cenários existentes quanto a criação de novos cenários necessários em função das alterações do contrato.**

