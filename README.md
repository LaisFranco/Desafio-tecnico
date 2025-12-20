
# RBAC MySQL Case – Taylor Permissions Fix

## 🇧🇷 Português

### 📌 Visão geral

Este repositório apresenta uma solução para um problema de permissão em um sistema que usa o Controle de Acesso Baseado em Função (RBAC).  
O caso se concentra na correção da modelagem de papéis para alinhar o comportamento do sistema com as regras de negócios, seguindo as melhores práticas de segurança e escalabilidade.

### 📌 Contexto

Este repositório apresenta a solução para um problema de permissões reportado por um cliente em um sistema que utiliza **RBAC (Role-Based Access Control)**.

Um funcionário chamado **Taylor** conseguia criar produtos, mas não conseguia modificá-los.  
De acordo com a regra de negócio, esse comportamento estava incorreto.

---

### 🐞 Descrição do Problema

**Comportamento atual**
- Taylor consegue **criar produtos**
- Taylor **não consegue modificar produtos**

**Comportamento esperado**
- Taylor **deve visualizar produtos**
- Taylor **deve modificar produtos**
- Taylor **não deve criar nem deletar produtos**
- Taylor **não deve alterar o inventário da empresa**

Esse cenário indica um **problema de modelagem de papéis (roles)**, e não apenas uma permissão ausente.

---

### 🧠 Estratégia e Decisão de Design

O problema foi resolvido revisando o modelo RBAC, evitando correções específicas por usuário.

A estratégia adotada foi:
- Adicionar a permissão **`modify products`** ao papel funcional **`analyze`**
- Remover o papel **`produce_consume`** do usuário Taylor

Essa abordagem mantém o modelo de autorização limpo, escalável e alinhado às regras de negócio.

---

### ❌ Por que NÃO atribuir o papel `manage`?

Apesar do papel `manage` já possuir a permissão de modificar produtos, atribuí-lo ao Taylor seria incorreto porque:
- Trata-se de um papel **administrativo**
- Pode receber permissões críticas no futuro
- Viola o **Princípio do Menor Privilégio**
- Aumenta riscos de segurança e manutenção

Papéis representam **responsabilidades**, não ações isoladas.

## 🗄️ Database 

### Credencias
- **User:** `root`
- **Password:** `1234`
  
<img width="553" height="547" alt="image" src="https://github.com/user-attachments/assets/9811c84f-0c2d-48bd-94fe-04e9ffab5edf" />

# Observação importante ⚠️

- No primeiro momento, não é possível definir o nome do banco de dados, pois ocorre erro na conexão.
- Por isso, siga este fluxo:

1-Crie a conexão sem informar o nome do banco (em branco)
2-Realize o teste de conexão
3-Após a conexão criada com sucesso:
  - Clique com o botão direito sobre a conexão
  - Selecione New → Query Console
  - Crie o banco de dados manualmente via script SQL
  <img width="610" height="86" alt="image" src="https://github.com/user-attachments/assets/0672de7f-2598-40f2-bc5c-781b24c72a60" />

### Criar o Banco de Dados

```sql
CREATE DATABASE Klavi;
USE Klavi;
```````````

### Nome do Banco de Dados
- Você pode colocar qualquer nome. 
- Nesse projeto, o nome do meu banco de dados é : **`Klavi`**

### IDE
- O **DATAGRIPE IDE** foi usado para gerenciar e executar os scripts SQL
- No entanto, qualquer IDE ou cliente compatível com MySQL pode ser usado sem afetar a solução.


----

# 🇺🇸 English

## 📌 Overview
This repository presents a solution for a permission issue in a system that uses Role-Based Access Control (RBAC).  
The case focuses on correcting role modeling to align system behavior with business rules, following security and scalability best practices.

### 📌 Context

This repository presents a solution for a permission issue reported by a customer in a system that uses **Role-Based Access Control (RBAC)**.

An employee named **Taylor** was able to create products but could not modify them.  
According to business rules, this behavior was incorrect.

---

### 🐞 Problem Description

**Current behavior**
- Taylor can **create products**
- Taylor cannot **modify products**

**Expected behavior**
- Taylor **should be able to view products**
- Taylor **should be able to modify products**
- Taylor **must not create or delete products**
- Taylor **must not change the company inventory**

This scenario indicates a **role modeling issue**, not a simple missing permission.

---

### 🧠 Strategy and Design Decision

The issue was resolved by reviewing the RBAC model instead of applying user-specific fixes.

The chosen strategy was:
- Add the **`modify products`** permission to the functional role **`analyze`**
- Remove the **`produce_consume`** role from Taylor

This keeps the authorization model clean, scalable, and aligned with business rules.

---

### ❌ Why NOT assign the `manage` role?

Although the `manage` role already includes the permission to modify products, assigning it to Taylor would be incorrect because:
- It is an **administrative role**
- It may receive additional critical permissions in the future
- It violates the **Principle of Least Privilege**
- It increases security and maintenance risks

Roles represent **responsibilities**, not isolated actions.

---

## 🗄️ Database Setup

### Credentials
- **User:** `root`
- **Password:** `1234`

<img width="553" height="547" alt="image" src="https://github.com/user-attachments/assets/9811c84f-0c2d-48bd-94fe-04e9ffab5edf" />

# Important note ⚠️

- At first, it is not possible to define the database name, as this will cause a connection error.
- Therefore, follow the steps below:

1- Create the connection without specifying a database name (leave it blank)
2- Run a connection test
3- After the connection is successfully created:
   - Right-click on the connection
   - Select New → Query Console
   - Create the database manually using an SQL script
  <img width="610" height="86" alt="image" src="https://github.com/user-attachments/assets/0672de7f-2598-40f2-bc5c-781b24c72a60" />


### Create Database

```sql
CREATE DATABASE Klavi;
USE Klavi;
``````

### Database Name
- Any database name can be used.  
- In this project, the database name used is: **`Klavi`**

### IDE
- The **DATAGRIPE IDE** was used to manage and execute the SQL scripts.  
- However, any MySQL-compatible IDE or client can be used without affecting the solution.



