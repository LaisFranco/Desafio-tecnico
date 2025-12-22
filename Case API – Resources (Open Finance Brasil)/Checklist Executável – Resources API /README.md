# Checklist Executável – Resources API (v3.0.0) #

### Headers e Correlação
- [ ] Gerar x-fapi-interaction-id no formato UUID RFC4122
- [ ] Enviar x-fapi-interaction-id no request
- [ ] Validar que x-fapi-interaction-id é retornado na response
- [ ] Validar que o valor retornado é o mesmo enviado
- [ ] Validar erro 400 quando x-fapi-interaction-id estiver ausente
- [ ] Validar erro 400 quando x-fapi-interaction-id estiver inválido

### Autorização
- [ ] Enviar Authorization header
- [ ] Validar erro 401 quando Authorization estiver ausente
- [ ] Validar erro 403 quando token não possuir RESOURCES_READ

### Sucesso (200 / 202)
- [ ] Validar status 200 para consentimento AUTHORISED
- [ ] Validar status 202 quando aplicável
- [ ] Validar Content-Type application/json

### Payload de Sucesso
- [ ] Validar presença de data, links e meta
- [ ] Validar meta.requestDateTime
- [ ] Validar meta.totalRecords apenas em resposta 200
- [ ] Validar meta.totalPages apenas em resposta 200

### Recursos
- [ ] Validar presença de resourceId, type e status
- [ ] Validar enum status:
      AVAILABLE, UNAVAILABLE, TEMPORARILY_UNAVAILABLE, PENDING_AUTHORISATION
- [ ] Validar enum type inclui EXCHANGE
- [ ] Validar resourceId de acordo com o tipo do recurso

### Paginação
- [ ] Validar page default = 1
- [ ] Validar page-size default = 25
- [ ] Validar page-size < 25 tratado como 25
- [ ] Validar que páginas intermediárias nunca retornam < 25 registros

### Erros
- [ ] Validar estrutura padrão de erro (errors[], meta.requestDateTime)
- [ ] Validar que erros NÃO retornam totalRecords
- [ ] Validar que erros NÃO retornam totalPages

```text
Collection no Postman  Resources API v3 – Open Finance
│
├── GET /resources – Happy Path (200)
├── GET /resources – Missing x-fapi-interaction-id (400)
├── GET /resources – Invalid x-fapi-interaction-id (400)
├── GET /resources – Page-size < 25
└── GET /resources – Unauthorized (401)
```

## Mapeamento Checklist → Requests ##

**GET /resources – Happy Path (200)**<br>
Cobre:
* Headers obrigatórios
* Espelhamento do x-fapi-interaction-id
* Status 200
* Estrutura do payload
* Enums (status + type + EXCHANGE)
* Paginação default
* meta.totalRecords / totalPages

 **GET /resources – Missing x-fapi-interaction-id (400)**<br>
Cobre:
* Obrigatoriedade do header
* Retorno 400
* Estrutura de erro
* Ausência de totalRecords / totalPages

 **GET /resources – Invalid x-fapi-interaction-id (400)**<br>
Cobre:
* Validação de formato UUID
* Retorno 400
* Estrutura de erro

 **GET /resources – Page-size < 25**<br>
Cobre:
* Regra regulatória do page-size mínimo
* Consistência de paginação
* Links de navegação

 **GET /resources – Unauthorized (401)**<br>
Cobre:
* Authorization ausente
* Retorno 401
* Estrutura de erro

## 4. Scripts Padrão (para você não esquecer nada)##

**Pre-request Script (usado em todos)**

**Gerar um novo ID de correlação para cada solicitação, conforme exigido pelo Open Finance.**

```javascript
// Generate x-fapi-interaction-id (UUID v4 - RFC4122)
const interactionId = pm.variables.replaceIn("{{$guid}}");

pm.environment.set("x-fapi-interaction-id", interactionId);


```
**Validar o Status Code**  

```javascript
pm.test("Status code is valid", () => {
  pm.expect([200, 202, 400, 401, 403]).to.include(pm.response.code);
});
```

  **Validar os Headers**

```javascript  
  pm.test("x-fapi-interaction-id is returned", () => {
  pm.response.headers.has("x-fapi-interaction-id");
});

pm.test("x-fapi-interaction-id is a valid UUID", () => {
  const id = pm.response.headers.get("x-fapi-interaction-id");
  pm.expect(id).to.match(
    /^[0-9a-fA-F]{8}-[0-9a-fA-F]{4}-[0-9a-fA-F]{4}-[0-9a-fA-F]{4}-[0-9a-fA-F]{12}$/
  );
});

```
**Validar o retorno do response Body com successo**  

```javascript
if (pm.response.code === 200) {
  const body = pm.response.json();

  pm.test("Response has data, links and meta", () => {
    pm.expect(body).to.have.property("data");
    pm.expect(body).to.have.property("links");
    pm.expect(body).to.have.property("meta");
  });
}

```

**Validar o retorno do response Body com erro**  

```javascript
if (pm.response.code !== 200) {
  const body = pm.response.json();

  pm.test("Error response does not contain pagination fields", () => {
    if (body.meta) {
      pm.expect(body.meta).to.not.have.property("totalRecords");
      pm.expect(body.meta).to.not.have.property("totalPages");
    }
  });
}

```

**Este checklist foi derivado diretamente do Test Plan da API Resources v3.0.0.
Cada item da lista de verificação é coberto por pelo menos uma requisição do Postman,
utilizando scripts de pré-request e testes reutilizáveis.
Essa abordagem garante:**

- Conformidade regulatória com o Open Finance Brasil
- Rastreabilidade entre requisitos, cenários e validações
- Facilidade de execução manual
- Prontidão para automação via Newman e integração em CI/CD

**Não foi criada uma collection executável completa devido à ausência de um ambiente
real de homologação. O foco foi garantir clareza, cobertura e estrutura para futura
execução automatizada.**



