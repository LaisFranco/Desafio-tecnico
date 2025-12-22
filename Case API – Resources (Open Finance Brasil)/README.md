 # Plano de Teste – API de Recursos (Open Finance Brasil) #

## 1. Objetivo do Plano de Teste

O objetivo deste plano de testes é validar a implementação da API Resources, garantindo que as informações de recursos dos clientes sejam expostas de forma correta, segura e em conformidade com as especificações do Open Finance Brasil.
  
**Este plano foca na validação de:**
* Contrato e schema da API
* Regras de autorização e permissões
* Regras de status dos recursos
* Comportamento de paginação
* Tratamento de erros
* Conformidade com as alterações documentadas (changelog)

## 2. Visão Geral da API

**A API Resources expõe o endpoint:**

```GET /resources/v3/resources```

**Este endpoint retorna a lista de recursos do cliente associados a um consentimento específico, identificado indiretamente pelo token OAuth2.
Regras importantes da especificação:**
* A API está disponível apenas para consentimentos com status AUTHORISED
* A permissão obrigatória é RESOURCES_READ
* Cada recurso retornado deve refletir o status do consentimento e a disponibilidade do recurso
* A API não diferencia pessoa física de pessoa jurídica

## 3. Escopo de teste

**Dentro do Escopo**
* Endpoint GET /resources/v3/resources
* Headers obrigatórios e opcionais
* Autorização OAuth2 e permissões
* Parâmetros de paginação (page, page-size)
* Regras de status dos recursos
* Validação do schema das respostas
* Respostas de erro documentadas
* Alterações introduzidas na versão 3.0.0<br>
**Fora do Escopo**
* Fluxo de criação de consentimento
* Comportamento do servidor de autorização OAuth2
* APIs que consomem o resourceId
* Validação de interface gráfica

## 4. Abordagem de teste

**Os testes serão executados utilizando uma abordagem baseada em contrato, validando o comportamento da API em relação à especificação OpenAPI.
Devido à ausência de um ambiente bancário real, os testes serão:**
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

**Headers obrigatórios:**
* Authorization
* x-fapi-interaction-id (UUID – RFC4122)
**Validar:**
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

**Validar os seguintes erros:**
* 202, 400, 401, 403, 404, 405, 406, 429, 500, 504, 529
**Para cada erro:**
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

**Este plano de testes garante que a API Resources possa ser exposta com segurança no ecossistema Open Finance, com foco em correção, segurança e conformidade regulatória.**


