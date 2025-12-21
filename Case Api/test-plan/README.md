### Test Plan – API Resources (GET /resources) - Atualização baseada Changelog - [DC] Recursos - v3.0.0 - v2.1.0 ##

## 1. Visão Geral
Este plano de testes cobre a API Resources do Open Finance Brasil, versão v3.0.0, responsável por retornar a lista de recursos consentidos pelo cliente, considerando status do consentimento e disponibilidade do recurso na instituição transmissora.
A API é exclusivamente informativa, criada para dar visibilidade de impedimentos no compartilhamento de recursos. Seu uso é permitido apenas quando o consentimento estiver no status AUTHORISED.

## 2. Escopo
Em escopo
* Endpoint: GET /resources
* Validação de headers obrigatórios e opcionais
* Validação de permissões (RESOURCES_READ)
* Validação de paginação
* Validação de payload de sucesso (200)
* Validação de todos os cenários de erro documentados
* Validação de regras regulatórias (x-regulatory-required)
* Validação das alterações introduzidas na versão v3.0.0
Fora de escopo
* Criação de consentimento
* Fluxo OAuth completo (assumido como pré-condição)
* Testes de APIs dependentes (accounts, credit-cards, etc.)

## 3. Referências
* Documentação oficial Open Finance Brasil – DC Recursos v3.0.0
* Swagger / OpenAPI v3.0.0
* Changelog v3.0.0

## 4. Premissas e Dependências
* Consentimento válido previamente criado
* Consentimento no status AUTHORISED
* Token OAuth2 válido com escopo resources
* Permission RESOURCES_READ concedida
* Ambiente de homologação disponível

## 5. Ambiente de Teste ( esse url que aparece na documentado nao e url real, pelo fato que vcs nao podem expor, então api.banco é um placeholder, não um servidor de verdade.)
* Exemplo de url: https://api.banco.com.br/open-banking/api/v1/resource
* Ferramenta: Postman

   Observação: erro getaddrinfo ENOTFOUND indica DNS ou endpoint indisponível – não é defeito funcional da API.

## 6. Endpoint em Teste
GET /resources
Headers obrigatórios:

* Authorization
* x-fapi-interaction-id (UUID RFC4122 – obrigatório)
  
Headers opcionais:
* x-fapi-auth-date
* x-fapi-customer-ip-address
* x-customer-user-agent
  
Query Params:
* page (default: 1)
* page-size (mínimo: 25 | máximo: 1000)

## 7. Regras de Negócio Críticas
* A API NÃO deve responder para consentimentos diferentes de AUTHORISED
* x-fapi-interaction-id é obrigatório e deve ser espelhado na resposta
* page-size menor que 25 deve ser tratado como 25
* O campo resourceId, type e status são regulatórios obrigatórios
* O status do recurso não depende apenas do consentimento, mas também da disponibilidade do recurso

## 8. Cenários de Teste – Sucesso

CT01 – Listar recursos com sucesso

* Consentimento: AUTHORISED
* Permission: RESOURCES_READ
* Resultado esperado:
    * HTTP 200
    * Lista de recursos
    * Meta com totalRecords e totalPages
      
CT02 – Lista vazia de recursos

* Consentimento AUTHORISED
* Nenhum recurso vinculado
* Resultado esperado:
    * HTTP 200
    * data: []

## 9. Cenários de Teste – Status de Recursos
* AVAILABLE
* UNAVAILABLE
* TEMPORARILY_UNAVAILABLE
* PENDING_AUTHORISATION
  
 Validar:
* Enum correto
* Regra de negócio descrita no swagger

##10. Cenários de Teste – Paginação

CT10 – page-size menor que 25
* Enviar page-size=10
* Resultado esperado:
    * API trata como 25
      
CT11 – Navegação entre páginas
* page=1, page=2
* Validação dos links: self, first, prev, next, last

## 11. Cenários de Teste – Validação de Headers

CT20 – Ausência de Authorization
* Resultado esperado: 401
CT21 – x-fapi-interaction-id ausente
* Resultado esperado: 400
* Header retornado pela transmissora
CT22 – x-fapi-interaction-id inválido
* Resultado esperado: 400

## 12. Cenários de Teste – Permissões e Segurança

CT30 – Token sem RESOURCES_READ
* Resultado esperado: 403
CT31 – Consentimento não AUTHORISED
* Resultado esperado: 403 ou 401 (conforme implementação)

## 13. Cenários de Teste – Erros HTTP

* 400 – Bad Request
* 401 – Unauthorized
* 403 – Forbidden
* 404 – Not Found
* 405 – Method Not Allowed
* 406 – Not Acceptable
* 429 – Too Many Requests
* 500 – Internal Server Error
* 504 – Gateway Timeout
* 529 – Site Is Overloaded
* default – Erro inesperado

Validar:
* Estrutura padrão de erro
* Campo meta.requestDateTime

## 14. Estratégia de Testes

* Testes manuais iniciais no Postman
* Automação futura via coleção Postman + Newman
* Evolução para BDD (Cucumber / Gherkin)

## 15. Riscos

* Dependência de consentimentos válidos
* Instabilidade de ambiente de homologação
* Ambiguidade entre erro funcional e erro de infraestrutura

## 16. Validação das Mudanças – GET /resources (v3.0.0)
Esta seção cobre explicitamente todas as alterações introduzidas na versão v3.0.0 do endpoint GET /resources, conforme o último link de changelog analisado.

## 16.1 Alterações em Query Parameters – page-size

  Mudança:
* Valor mínimo alterado de 1 para 25
* Caso a receptora informe valor menor que 25, a transmissora DEVE considerar 25
* Apenas a última página pode retornar menos de 25 registros
  Cenários de Teste:
* Enviar page-size=1 → API deve tratar como 25
* Enviar page-size=10 → API deve tratar como 25
* Enviar page-size=25 → API aceita normalmente
* Validar que páginas intermediárias nunca retornam menos de 25 registros

## 16.2 Alterações no Header x-fapi-interaction-id

 Mudanças aplicadas:
* Header passou a ser obrigatório
* Formato restrito a UUID RFC4122
* maxLength alterado de 100 para 36
* Pattern alterado para regex UUID
* Header deve ser espelhado na resposta
* Caso ausente ou inválido → HTTP 400
  Cenários de Teste:
* Header ausente → 400
* Header inválido (não UUID) → 400
* Header válido → resposta contém o mesmo valor
* Validar maxLength = 36

## 16.3 Inclusão do HTTP Status 202

  Mudança:
* Status 202 foi adicionado ao contrato
  Cenário de Teste:
* Validar que a API responde conforme schema definido para 202 (quando aplicável)

## 16.4 Alterações no Payload – Campos Regulatórios

  Mudanças:
* Campo x-regulatory-required adicionado em data.items
  Cenários de Teste:
* Validar presença do campo em todos os itens
* Validar que campos regulatórios nunca são omitidos

## 16.5 Alterações no resourceId

  Mudança:
* Inclusão explícita do tipo Exchange (Câmbio)
* resourceId deve corresponder ao identificador da API específica:
    * accountId
    * creditCardAccountId
    * contractId
    * investmentId
    * operationId (Exchange)
  Cenários de Teste:
* Validar mapeamento correto entre type e resourceId
* Validar inclusão do tipo EXCHANGE

## 16.6 Alterações no Enum type

  Mudança:
* Novo valor adicionado: EXCHANGE
  Cenário de Teste:
* Validar enum aceita EXCHANGE
* Validar rejeição de valores fora do enum

## 16.7 Alterações no Header de Resposta x-fapi-interaction-id

  Mudanças:
* Inclusão de format=uuid
* Inclusão de minLength
* Inclusão de example
* Pattern e maxLength alinhados ao UUID
  Cenários de Teste:
* Validar header de resposta segue exatamente o padrão UUID
* Validar espelhamento do valor recebido

## 16.8 Alterações nos Responses de Erro – Meta

  Mudança Crítica:
* Remoção de totalRecords e totalPages dos objetos meta em respostas de erro
  Impacto Regulatório:
* Em respostas de erro, o bloco meta não deve conter informações de paginação
  Cenários de Teste:
* Validar que erros 400, 401, 403, 404, 405, 406, 429, 500, 504, 529 NÃO retornam:
    * totalRecords
    * totalPages

## 17. Conclusão
- Este Test Plan garante cobertura funcional, regulatória e contratual completa da API Resources v3.0.0, incluindo todas as alterações recentes do endpoint GET /resources. O plano está pronto para execução manual, automação e derivação direta para cenários BDD.
