CREATE TABLE funcionarios(
    id SERIAL PRIMARY KEY,
    matricula VARCHAR(10),
    nome VARCHAR(255),
    sobrenome VARCHAR(255)
);

INSERT INTO funcionarios (matricula, nome, sobrenome) VALUES ('M001', 'Diogo', 'Mascarenhas');
INSERT INTO funcionarios (matricula, nome, sobrenome) VALUES ('M002', 'Vinícius', 'Dias');
INSERT INTO funcionarios (matricula, nome, sobrenome) VALUES ('M003', 'Nico', 'Steppat');
INSERT INTO funcionarios (matricula, nome, sobrenome) VALUES ('M004', 'João', 'Roberto');
INSERT INTO funcionarios (matricula, nome, sobrenome) VALUES ('M005', 'Diogo', 'Mascarenhas');
INSERT INTO funcionarios (matricula, nome, sobrenome) VALUES ('M006', 'Alberto', 'Martins');

SELECT * 
    FROM funcionarios
    ORDER BY nome;
	
SELECT *
  FROM funcionarios
  ORDER BY id,
  LIMIT 2 
  OFFSET 1;

SELECT COUNT (id),
       SUM(id),
       MAX(id),
       MIN(id),
       ROUND(AVG(id),0)
  FROM funcionarios;
  
SELECT nome, sobrenome,
COUNT(*)
FROM funcionarios
GROUP BY nome, sobrenome
ORDER BY nome;

SELECT nome,COUNT(id)
FROM funcionarios
GROUP BY nome
HAVING COUNT(id) > 1;