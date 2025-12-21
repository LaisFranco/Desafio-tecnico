 # Plano de Teste – API de Recursos (Open Finance Brasil) #

 
## 1. Objetivo do Plano de Teste

O objetivo deste plano de testes é validar a implementação da API Resources, garantindo que as informações de recursos dos clientes sejam expostas de forma correta, segura e em conformidade com as especificações do Open Finance Brasil.
Este plano foca na validação de:
* Contrato e schema da API
* Regras de autorização e permissões
* Regras de status dos recursos
* Comportamento de paginação
* Tratamento de erros
* Conformidade com as alterações documentadas (changelog)



## 2. Visão Geral da API


A API Resources expõe o endpoint:

```GET /resources/v3/resources```

Este endpoint retorna a lista de recursos do cliente associados a um consentimento específico, identificado indiretamente pelo token OAuth2.
Regras importantes da especificação:
* A API está disponível apenas para consentimentos com status AUTHORISED
* A permissão obrigatória é RESOURCES_READ
* Cada recurso retornado deve refletir o status do consentimento e a disponibilidade do recurso
* A API não diferencia pessoa física de pessoa jurídica


## 3. Escopo de teste


Dentro do Escopo
* Endpoint GET /resources/v3/resources
* Headers obrigatórios e opcionais
* Autorização OAuth2 e permissões
* Parâmetros de paginação (page, page-size)
* Regras de status dos recursos
* Validação do schema das respostas
* Respostas de erro documentadas
* Alterações introduzidas na versão 3.0.0
Fora do Escopo
* Fluxo de criação de consentimento
* Comportamento do servidor de autorização OAuth2
* APIs que consomem o resourceId
* Validação de interface gráfica

## 4. Abordagem de teste


Os testes serão executados utilizando uma abordagem baseada em contrato, validando o comportamento da API em relação à especificação OpenAPI.
Devido à ausência de um ambiente bancário real, os testes serão:
* Executáveis por meio de mocks
* Validados por regras e schemas
* Facilmente automatizáveis futuramente

## 5. Tipos de Teste e Cenários 
## 5.1 Testes de Autorização e Permissão

* Validar acesso com token OAuth2 válido
* Validar permissão obrigatória RESOURCES_READ
* Validar acesso negado para permissão ausente ou inválida
* Validar acesso negado para consentimento não AUTHORISED


## 5.2 Testes de Validação de Cabeçalho

Headers obrigatórios:
* Authorization
* x-fapi-interaction-id (UUID – RFC4122)
Validar:
* Ausência de headers obrigatórios
* Formato inválido de UUID
* Espelhamento do header na resposta

## 5.3 Testes Funcionais - Resposta Bem-Sucedida (200)


* Validar resposta HTTP 200
* Validar content-type da resposta
* Validar estrutura:
    * data
    * links
    * meta
* Validar campos obrigatórios dos recursos
* Validar valores permitidos de enums
* Validar regras de paginação
* Validar links de navegação

## 5.4 Testes Funcionais - Cenários de Erro


Validar os seguintes erros:
* 202, 400, 401, 403, 404, 405, 406, 429, 500, 504, 529
Para cada erro:
* Validar schema de erro
* Garantir ausência de dados sensíveis
* Validar informações de meta

## 6. Regressão e Validação de Changelog

* Validar obrigatoriedade do x-fapi-interaction-id
* Validar formato UUID
* Validar novos valores de enum (EXCHANGE)
* Validar mudanças de paginação
* Garantir ausência de quebra de contrato

## 7. Estratégia de Dados de Teste

* Dados sintéticos e anonimizados
* Diferentes tipos e status de recursos
* Diferentes cenários de paginação


## 8. Critérios de Saída

* Todos os testes críticos executados
* Nenhum problema de segurança ou conformidade em aberto
* Comportamento da API alinhado à especificação

## 9. Riscos e Suposições

* Fluxos OAuth2 reais não disponíveis
* Testes baseados em contrato e mocks
* Assume conformidade das APIs consumidoras

## 10. Considerações finais

Este plano de testes garante que a API Resources possa ser exposta com segurança no ecossistema Open Finance, com foco em correção, segurança e conformidade regulatória.


------

# Test Plan – Resources API (Open Finance Brasil) - English #
 
 ## 1. Test Plan Objective

The objective of this test plan is to validate the implementation of the Resources API, ensuring that customer resource information is exposed correctly, securely, and in compliance with the Open Finance Brasil specifications.
This test plan focuses on validating:

* API contract and schema
* Authorization and permission rules
* Resource status rules
* Pagination behavior
* Error handling
* Compliance with documented changes (changelog)

## 2. API Overview

The Resources API exposes the endpoint:

```GET /resources/v3/resources```
ist of customer resources associated with a specific consent, identified indirectly by the OAuth2 access token.
Important rules from the specification:

* The API is available only for consents with status AUTHORISED
* The required permission is RESOURCES_READ
* Each returned resource must reflect both consent status and resource availability
* The API does not differentiate between individual and business customers

## 3. Test Scope

In Scope:

* Endpoint GET /resources/v3/resources
* Request headers (mandatory and optional)
* OAuth2 authorization and permissions
* Pagination parameters (page, page-size)
* Resource status rules
* Response schema validation
* Error responses defined in the OAS
* Changes introduced in version 3.0.0

Out of Scope

* Consent creation flow
* OAuth2 authorization server behavior
* Downstream APIs that consume resourceId
* UI or frontend validation

## 4. Test Approach

Testing will be performed using a contract-based approach, focusing on validating the API behavior against the OpenAPI specification.
Due to the absence of a real banking environment, tests will be designed to be:

* Executable using mock servers
* Validated through schema and rule enforcement
* Easily automated in the future

## 5. Test Types and Scenarios
## 5.1 Authorization and Permission Tests

* Validate access with valid OAuth2 token
* Validate required permission RESOURCES_READ
* Validate access denied for missing or invalid permission
* Validate access denied for non-AUTHORISED consent

## 5.2 Header Validation Tests

Mandatory headers:
* Authorization
* x-fapi-interaction-id (UUID – RFC4122)

## 5.3 Functional Tests – Successful Response (200)

* Validate HTTP 200 response
* Validate response content-type
* Validate response structure:
    * data
    * links
    * meta
* Validate each resource contains:
    * resourceId
    * type
    * status
* Validate allowed values for:
    * type enum
    * status enum
* Validate pagination rules:
    * Default page = 1
    * Minimum page-size = 25
* Validate navigation links


## 5.4 Functional Tests – Error Scenarios

Validate the following error responses:
* 202, 400, 401, 403, 404, 405, 406, 429, 500, 504, 529
For each error:
* Validate error schema
* Validate absence of sensitive data
* Validate meta information

## 6. Regression and Changelog Validation

* Validate mandatory x-fapi-interaction-id
* Validate UUID format enforcement
* Validate new enum values (EXCHANGE)
* Validate pagination minimum changes
* Ensure no contract breaking changes

## 7. Test Data Strategy

* Synthetic and anonymized data
* Different resource types and statuses
* Different pagination scenarios

## 8. Exit Criteria

* All critical test cases executed
* No open compliance or security issues
* API behavior aligned with specification

## 9. Risks and Assumptions

* Real OAuth2 flows are not available
* Tests rely on contract and mock execution
* Assumes downstream APIs comply with resource identifiers


## 10. Final Considerations

This test plan ensures that the Resources API can be safely exposed within the Open Finance ecosystem, focusing on correctness, security, and regulatory compliance.
