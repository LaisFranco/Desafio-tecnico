--Criação das tabelas já existentes

CREATE TABLE user_define (
    id INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(100) NOT NULL
);


CREATE TABLE role_define (
    id INT PRIMARY KEY AUTO_INCREMENT,
    label VARCHAR(50) NOT NULL UNIQUE
);


CREATE TABLE action_define (
    id INT PRIMARY KEY AUTO_INCREMENT,
    description VARCHAR(100) NOT NULL UNIQUE
);


CREATE TABLE user_role_rela (
    id INT PRIMARY KEY AUTO_INCREMENT,
    user_id INT NOT NULL,
    role_id INT NOT NULL,

    CONSTRAINT fk_user_role_user
        FOREIGN KEY (user_id) REFERENCES user_define(id)
        ON DELETE CASCADE,

    CONSTRAINT fk_user_role_role
        FOREIGN KEY (role_id) REFERENCES role_define(id)
        ON DELETE CASCADE,

    CONSTRAINT uq_user_role UNIQUE (user_id, role_id)
);


CREATE TABLE role_action_rela (
    id INT PRIMARY KEY AUTO_INCREMENT,
    role_id INT NOT NULL,
    action_id INT NOT NULL,

    CONSTRAINT fk_role_action_role
        FOREIGN KEY (role_id) REFERENCES role_define(id)
        ON DELETE CASCADE,

    CONSTRAINT fk_role_action_action
        FOREIGN KEY (action_id) REFERENCES action_define(id)
        ON DELETE CASCADE,

    CONSTRAINT uq_role_action UNIQUE (role_id, action_id)
);


-- Inserindo informações já existentes nas tabelas

INSERT INTO user_define (name) VALUES
('Ariel'),
('Taylor'),
('Luka');


INSERT INTO role_define (label) VALUES
('charge'),
('analyze'),
('produce_consume'),
('manage');


INSERT INTO action_define (description) VALUES
('create bills'),
('create products'),
('view bills'),
('view products'),
('modify products'),
('delete products');


INSERT INTO user_role_rela (user_id, role_id) VALUES
(1, 1), -- Ariel -> charge
(2, 2), -- Taylor -> analyze
(2, 3), -- Taylor -> produce_consume
(3, 2), -- Luka -> analyze
(3, 3), -- Luka -> produce_consume
(3, 4); -- Luka -> manage


INSERT INTO role_action_rela (role_id, action_id) VALUES
(1, 1), -- charge -> create bills
(1, 3), -- charge -> view bills
(2, 4), -- analyze -> view products
(3, 2), -- produce_consume -> create products
(3, 6), -- produce_consume -> delete products
(4, 5); -- manage -> modify products

-- Primeiramente fiz um select para confirmar quais roles, estava vinculadas com o taylor
SELECT
    u.name        AS user_name,
    r.label       AS role_name,
    a.description AS permission
FROM user_define u
JOIN user_role_rela ur
    ON ur.user_id = u.id
JOIN role_define r
    ON r.id = ur.role_id
JOIN role_action_rela ra
    ON ra.role_id = r.id
JOIN action_define a
    ON a.id = ra.action_id
WHERE u.name = 'Taylor'
ORDER BY r.label, a.description;

-- Depois deletei as roles de produce_consume que estava vinculadas com o taylor
DELETE FROM user_role_rela
WHERE user_id = (
    SELECT id FROM user_define WHERE name = 'Taylor'
)
AND role_id = (
    SELECT id FROM role_define WHERE label = 'produce_consume'
);

-- Inserir na Analyze uma nova ação que é modify products

INSERT INTO role_action_rela (role_id, action_id)
SELECT r.id, a.id
FROM role_define r
JOIN action_define a
WHERE r.label = 'analyze'
  AND a.description = 'modify products';

-- E inserir o role_define analyze para o Taylor

INSERT IGNORE INTO user_role_rela (user_id, role_id)
SELECT u.id, r.id
FROM user_define u
JOIN role_define r
WHERE u.name = 'Taylor'
  AND r.label = 'analyze';


-- Teste para validar as permissões do Taylor

SELECT DISTINCT
    a.description AS permission
FROM user_define u
JOIN user_role_rela ur ON ur.user_id = u.id
JOIN role_action_rela ra ON ra.role_id = ur.role_id
JOIN action_define a ON a.id = ra.action_id
WHERE u.name = 'Taylor'
ORDER BY permission;