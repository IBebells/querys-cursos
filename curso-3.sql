CREATE TABLE acad.aluno (
    id SERIAL PRIMARY KEY,
	primeiro_nome VARCHAR(255) NOT NULL,
	ultimo_nome VARCHAR(255) NOT NULL,
	data_nascimento DATE NOT NULL
);

CREATE TABLE acad.categoria (
    id SERIAL PRIMARY KEY,
	nome VARCHAR(255) NOT NULL UNIQUE
);

CREATE TABLE acad.curso (
    id SERIAL PRIMARY KEY,
	nome VARCHAR(255) NOT NULL,
	categoria_id INTEGER NOT NULL REFERENCES acad.categoria(id)
);

CREATE TABLE acad.aluno_curso (
	aluno_id INTEGER NOT NULL REFERENCES acad.aluno(id),
	curso_id INTEGER NOT NULL REFERENCES acad.curso(id),
	PRIMARY KEY (aluno_id, curso_id)
);

INSERT INTO acad.aluno (
	primeiro_nome,
	ultimo_nome,
	data_nascimento
) VALUES (
	'Clark',
	'Kent',
	'1982-03-05'
);

INSERT INTO acad.aluno (
	primeiro_nome,
	ultimo_nome,
	data_nascimento
) VALUES (
	'Peter',
	'Parker',
	'1988-08-07'
);

INSERT INTO acad.aluno (
	primeiro_nome,
	ultimo_nome,
	data_nascimento
) VALUES (
	'Diana',
	'Prince',
	'1985-12-09'
);

INSERT INTO acad.aluno (
	primeiro_nome,
	ultimo_nome,
	data_nascimento
) VALUES (
	'Natalia',
	'Romanova',
	'1987-11-15'
);

INSERT INTO acad.aluno (
	primeiro_nome,
	ultimo_nome,
	data_nascimento
) VALUES (
	'Bruce',
	'Wayne',
	'1986-01-29'
);

SELECT * FROM acad.aluno;

INSERT INTO acad.categoria(nome) VALUES('Data Science');
INSERT INTO acad.categoria(nome) VALUES('Programação');
INSERT INTO acad.categoria(nome) VALUES('Mobile');

INSERT INTO acad.curso (nome,categoria_id) VALUES ('Machine Learning',1);
INSERT INTO acad.curso (nome,categoria_id) VALUES ('SQL',1);
INSERT INTO acad.curso (nome,categoria_id) VALUES ('Python',2);
INSERT INTO acad.curso (nome,categoria_id) VALUES ('Flutter',3);

SELECT * FROM acad.curso;

INSERT INTO acad.aluno_curso (aluno_id,curso_id) VALUES (1,1);
INSERT INTO acad.aluno_curso (aluno_id,curso_id) VALUES (2,1);
INSERT INTO acad.aluno_curso (aluno_id,curso_id) VALUES (2,2);
INSERT INTO acad.aluno_curso (aluno_id,curso_id) VALUES (3,2);
INSERT INTO acad.aluno_curso (aluno_id,curso_id) VALUES (4,4);
INSERT INTO acad.aluno_curso (aluno_id,curso_id) VALUES (5,3);

CREATE TEMPORARY TABLE cursos_prog (
	id_curso INTEGER PRIMARY KEY,
	nome_curso VARCHAR (255) NOT NULL
);

INSERT INTO cursos_prog
SELECT acad.curso.id,
	   acad.curso.nome
  FROM acad.curso
 WHERE categoria_id = 2;

SELECT * FROM cursos_prog;

BEGIN;
DELETE FROM cursos_prog;
SELECT * FROM cursos_prog;
ROLLBACK;

COMMIT;

CREATE SEQUENCE sequencia;

SELECT NEXTVAL('sequencia');

CREATE TEMPORARY TABLE test (
	id_curso INTEGER PRIMARY KEY DEFAULT NEXTVAL ('sequencia'),
	nome_curso VARCHAR (255) NOT NULL
);

INSERT INTO test (nome_curso) VALUES ('M');

SELECT * FROM test;

CREATE TYPE CLASSIFICACAO AS ENUM ('LIVRE', '12_ANOS', '14_ANOS', '16_ANOS', '18_ANOS');
DROP TABLE filmes;
CREATE TEMPORARY TABLE filmes (
	id SERIAL PRIMARY KEY,
	nome VARCHAR (255) NOT NULL,
	classificacao CLASSIFICACAO
);

INSERT INTO filmes (nome, classificacao) VALUES ('filminho', 'LIVRE');

SELECT * FROM filmes;