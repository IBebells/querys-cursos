SELECT * FROM aluno;

SELECT nome as nome_do_aluno,
	   cpf as "CPF"
FROM aluno;

INSERT INTO aluno (nome) VALUES ('Ronan Lynch');
INSERT INTO aluno (nome) VALUES ('Richard Gansey');
INSERT INTO aluno (nome) VALUES ('Blue Sargent');
INSERT INTO aluno (nome) VALUES ('Calla Rips');
INSERT INTO aluno (nome) VALUES ('Adam Wayne');
INSERT INTO aluno (nome) VALUES ('Clark Kent');

SELECT * FROM aluno
WHERE nome <> 'Fulano';

SELECT * FROM aluno
WHERE nome LIKE '%l%t';

SELECT * FROM aluno
WHERE cpf  IS NULL;

SELECT * FROM aluno
WHERE idade BETWEEN 10 AND 40;