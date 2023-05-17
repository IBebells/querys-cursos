CREATE TABLE aluno (
    id SERIAL PRIMARY KEY,
	primeiro_nome VARCHAR(255) NOT NULL,
	ultimo_nome VARCHAR(255) NOT NULL,
	data_nascimento DATE NOT NULL
);

CREATE TABLE categoria (
    id SERIAL PRIMARY KEY,
	nome VARCHAR(255) NOT NULL UNIQUE
);

CREATE TABLE curso (
    id SERIAL PRIMARY KEY,
	nome VARCHAR(255) NOT NULL,
	categoria_id INTEGER NOT NULL REFERENCES categoria(id)
);

CREATE TABLE aluno_curso (
	aluno_id INTEGER NOT NULL REFERENCES aluno(id),
	curso_id INTEGER NOT NULL REFERENCES curso(id),
	PRIMARY KEY (aluno_id, curso_id)
);

INSERT INTO aluno (
	primeiro_nome,
	ultimo_nome,
	data_nascimento
) VALUES (
	'Clark',
	'Kent',
	'1982-03-05'
);

INSERT INTO aluno (
	primeiro_nome,
	ultimo_nome,
	data_nascimento
) VALUES (
	'Peter',
	'Parker',
	'1988-08-07'
);

INSERT INTO aluno (
	primeiro_nome,
	ultimo_nome,
	data_nascimento
) VALUES (
	'Diana',
	'Prince',
	'1985-12-09'
);

INSERT INTO aluno (
	primeiro_nome,
	ultimo_nome,
	data_nascimento
) VALUES (
	'Natalia',
	'Romanova',
	'1987-11-15'
);

INSERT INTO aluno (
	primeiro_nome,
	ultimo_nome,
	data_nascimento
) VALUES (
	'Bruce',
	'Wayne',
	'1986-01-29'
);

SELECT * FROM aluno;

INSERT INTO categoria(    
	nome
) VALUES(
	'Data Science'
);

INSERT INTO categoria(    
	nome
) VALUES(
	'Programação'
);

INSERT INTO categoria(    
	nome
) VALUES(
	'Mobile'
);

INSERT INTO curso (
	nome,
	categoria_id
) VALUES (
	'Machine Learning',
	1
);

INSERT INTO curso (
	nome,
	categoria_id
) VALUES (
	'SQL',
	1
);

INSERT INTO curso (
	nome,
	categoria_id
) VALUES (
	'Python',
	2
);

INSERT INTO curso (
	nome,
	categoria_id
) VALUES (
	'Flutter',
	3
);

SELECT * FROM curso;

INSERT INTO aluno_curso (aluno_id,curso_id) VALUES (5,1);
INSERT INTO aluno_curso (aluno_id,curso_id) VALUES (6,1);
INSERT INTO aluno_curso (aluno_id,curso_id) VALUES (6,2);
INSERT INTO aluno_curso (aluno_id,curso_id) VALUES (7,2);
INSERT INTO aluno_curso (aluno_id,curso_id) VALUES (8,4);
INSERT INTO aluno_curso (aluno_id,curso_id) VALUES (9,3);

SELECT * FROM aluno_curso;

SELECT aluno.primeiro_nome,
	   aluno.ultimo_nome,
	   COUNT(aluno_curso.curso_id) numero_cursos
FROM aluno
JOIN aluno_curso ON aluno_curso.aluno_id = aluno.id
GROUP BY 1, 2
ORDER BY numero_cursos DESC
LIMIT 1;

SELECT curso.nome,
	   COUNT(aluno_curso.aluno_id) numero_alunos
FROM curso
JOIN aluno_curso ON aluno_curso.curso_id = curso.id
GROUP BY 1
ORDER BY numero_alunos DESC;

SELECT categoria.id, 
       categoria.nome,
       count(categoria.id) categoria_mais_solicitada
FROM curso
JOIN aluno_curso ON curso.id = aluno_curso.curso_id
JOIN categoria ON curso.categoria_id = categoria.id
GROUP BY 1, 2
ORDER BY categoria_mais_solicitada DESC;

SELECT * FROM categoria WHERE id IN (1,2);

SELECT * FROM curso WHERE categoria_id IN (
    SELECT id FROM categoria WHERE nome NOT LIKE ('% %')
);


SELECT categoria.nome AS categoria,
        COUNT(curso.id) as numero_cursos
    FROM categoria
    JOIN curso ON curso.categoria_id = categoria.id
GROUP BY categoria;

SELECT categoria,
       numero_cursos
    FROM (SELECT categoria.nome AS categoria,
        	COUNT(curso.id) as numero_cursos
    	  FROM categoria
    	  JOIN curso ON curso.categoria_id = categoria.id
		  GROUP BY categoria) AS categoria_cursos
  WHERE numero_cursos > 1;
 
-- mesmo resultado usando HAVING

  SELECT curso.nome,
         COUNT(aluno_curso.aluno_id) numero_alunos
    FROM curso
    JOIN aluno_curso ON aluno_curso.curso_id = curso.id
GROUP BY 1
     HAVING COUNT(aluno_curso.aluno_id) > 2
ORDER BY numero_alunos DESC;

-------------------------------------------

SELECT (primeiro_nome || ultimo_nome) AS nome_completo FROM aluno;

SELECT CONCAT(primeiro_nome, ' ', ultimo_nome) AS nome_completo FROM aluno;

SELECT TRIM(UPPER(CONCAT('Vinicius', ' ', 'Dias')));

SELECT (primeiro_nome || ultimo_nome) AS nome_completo,
       EXTRACT (YEAR FROM AGE(data_nascimento)) AS idade
  FROM aluno;
  
CREATE VIEW vw_cursos_por_categoria AS 
    SELECT curso.nome,
	COUNT(aluno_curso.aluno_id) numero_alunos
    FROM curso
    JOIN aluno_curso ON aluno_curso.curso_id = curso.id
GROUP BY 1
    HAVING COUNT(aluno_curso.aluno_id) > 2
ORDER BY numero_alunos DESC;

SELECT * FROM vw_cursos_por_categoria;

CREATE VIEW vw_cursos_programacao AS SELECT nome FROM curso WHERE categoria_id = 2;

SELECT * FROM vw_cursos_programacao;