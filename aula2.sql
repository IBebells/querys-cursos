DROP TABLE aluno_curso;
DROP TABLE aluno_1;
DROP TABLE curso_1;

CREATE TABLE aluno_1 (
	id SERIAL PRIMARY KEY,
	nome VARCHAR (255)
);

CREATE TABLE curso_1 (
	id SERIAL PRIMARY KEY,
	nome VARCHAR (255)
);


CREATE TABLE aluno_curso (
	
	aluno_id INTEGER,
	curso_id INTEGER,
	
	PRIMARY KEY (aluno_id, curso_id),

	FOREIGN KEY (aluno_id)
	REFERENCES aluno_1 (id),

	FOREIGN KEY (curso_id)
	REFERENCES curso_1 (id)

);

--primary key não permite valores repetidos
INSERT INTO aluno_1 (nome) VALUES ('Peter Park');
INSERT INTO aluno_1 (nome) VALUES ('Clark Kent');

INSERT INTO curso_1 (id, nome) VALUES (1, 'Python');
INSERT INTO curso_1 (id, nome) VALUES (2, 'Javascript');

INSERT INTO aluno_curso (aluno_id, curso_id) VALUES (1,1);
INSERT INTO aluno_curso (aluno_id, curso_id) VALUES (2,1);
INSERT INTO aluno_curso (aluno_id, curso_id) VALUES (3,1);

SELECT * FROM curso_1;
SELECT * FROM aluno_1;

SELECT * FROM aluno_1
JOIN aluno_curso ON aluno_curso.aluno_id = aluno_1.id
JOIN curso_1     ON curso_1.id           = aluno_curso.curso_id;

INSERT INTO aluno_curso (aluno_id, curso_id) VALUES (2,2);