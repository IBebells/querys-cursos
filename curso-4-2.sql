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

--------------------------------------------------------

CREATE FUNCTION cria_curso (nome_curso VARCHAR, nome_categoria VARCHAR) RETURNS void AS $$
	DECLARE
		id_categoria INTEGER;
	BEGIN
		SELECT id INTO id_categoria FROM categoria WHERE nome = nome_categoria;
		
		IF NOT FOUND THEN
			INSERT INTO categoria (nome) VALUES (nome_categoria) RETURNING id INTO id_categoria;
		END IF;
		
		INSERT INTO curso (nome, categoria_id) VALUES (nome_curso, id_categoria);
		
	END
$$ LANGUAGE plpgsql;

SELECT cria_curso('Java', 'Programação');
SELECT * FROM curso;

-------------------------------------------------------
CREATE TABLE instrutor(
	id SERIAL PRIMARY KEY,
	nome VARCHAR(255),
	salario DECIMAL (10,2)
);

INSERT INTO instrutor (nome, salario) VALUES ('Fera', 500);
INSERT INTO instrutor (nome, salario) VALUES ('Bela', 600);
INSERT INTO instrutor (nome, salario) VALUES ('Aladin', 300);
INSERT INTO instrutor (nome, salario) VALUES ('Jasmin', 450);
INSERT INTO instrutor (nome, salario) VALUES ('Rapunzel', 200);
INSERT INTO instrutor (nome, salario) VALUES ('Cinderela', 700);

CREATE TABLE log_instrutores(
	id SERIAL PRIMARY KEY,
	informacao VARCHAR (255),
	momento_criacao TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

/*CREATE OR REPLACE FUNCTION cria_instrutor (nome_instrutor VARCHAR, salario_instrutor DECIMAL) RETURNS void AS $$ 
	DECLARE
		id_instrutor_inserido INTEGER;
		media_salarial DECIMAL;
		instrutores_recebem_menos INTEGER DEFAULT 0;
		total_instrutores INTEGER DEFAULT 0;
		salario DECIMAL;
		percentual DECIMAL (5,2);
	BEGIN
		INSERT INTO instrutor(nome, salario) VALUES (nome_instrutor, salario_instrutor) RETURNING id INTO id_instrutor_inserido;
		
		SELECT AVG (instrutor.salario) INTO media_salarial FROM instrutor WHERE id <> id_instrutor_inserido;
		
		IF salario_instrutor > media_salarial THEN
			INSERT INTO log_instrutores (informacao) VALUES (nome_instrutor || ' recebe acima da média');
		END IF;
			
		FOR salario IN SELECT instrutor.salario FROM instrutor WHERE id <> id_instrutor_inserido LOOP
			total_instrutores := total_instrutores + 1;
			
			IF salario_instrutor > salario THEN
				instrutores_recebem_menos := instrutores_recebem_menos + 1;
			END IF;
			
		END LOOP;

		percentual =  (instrutores_recebem_menos ::DECIMAL / total_instrutores::DECIMAL) * 100;
		
		INSERT INTO log_instrutores (informacao) 
			VALUES (nome_instrutor || ' recebe mas do que ' || percentual || '% da grade de instrutores');
	END;
	
$$ LANGUAGE plpgsql;*/
DROP TABLE log_instrutores;
SELECT * FROM instrutor;
SELECT cria_instrutor ('Branca', 800);
SELECT * FROM log_instrutores;

DROP TABLE instrutor;


-----------------------------------------------------------------

DROP FUNCTION cria_instrutor;
/*CREATE OR REPLACE FUNCTION cria_instrutor () RETURNS TRIGGER AS $$ 
	DECLARE
		media_salarial DECIMAL;
		instrutores_recebem_menos INTEGER DEFAULT 0;
		total_instrutores INTEGER DEFAULT 0;
		salario DECIMAL;
		percentual DECIMAL (5,2);
		cont INTEGER DEFAULT 0;
		salario_maior DECIMAL DEFAULT 0;
	BEGIN
		
		SELECT AVG (instrutor.salario) INTO media_salarial FROM instrutor WHERE id <> NEW.id;
		
		IF NEW.salario > media_salarial THEN
		
			--RETURN NULL;
		--ELSE
		
			INSERT INTO log_instrutores (informacao) VALUES (NEW.nome || ' recebe acima da média');
		END IF;
			
		FOR salario IN SELECT instrutor.salario FROM instrutor WHERE id <> NEW.id LOOP
			total_instrutores := total_instrutores + 1;
			
			RAISE NOTICE 'Total de instrutores: %, salario: %', salario, total_instrutores;
			/*IF cont = 0 THEN
				salario_maior := salario;
				
			ELSEIF salario > salario_maior THEN
				salario_maior := salario;
				
			END IF;*/
			
			IF NEW.salario > salario THEN
				instrutores_recebem_menos := instrutores_recebem_menos + 1;
			END IF;
			
			--cont := cont + 1;
		END LOOP;
		
		SELECT MAX (instrutor.salario) INTO salario_maior FROM instrutor WHERE id <> NEW.id;
		
		/*IF NEW.salario > salario_maior THEN
			NEW.salario := salario_maior;
			RETURN NEW;
		END IF;*/
			
		percentual =  (instrutores_recebem_menos ::DECIMAL / total_instrutores::DECIMAL) * 100;
		
		ASSERT percentual < 100::DECIMAL;
		
		INSERT INTO log_instrutores (informacao) 
			VALUES (NEW.nome || ' recebe mais do que ' || percentual || '% da grade de instrutores');
		RETURN NEW;
		
	/*EXCEPTION
		WHEN undefined_column THEN
			RAISE NOTICE 'Mano, ta errado isso ae!';
			RAISE EXCEPTION 'Não dá pra resolver';*/
	END;
	
$$ LANGUAGE plpgsql;*/
DROP TRIGGER cria_log_instrutores ON instrutor;

CREATE TRIGGER cria_log_instrutores BEFORE INSERT ON instrutor
	FOR EACH ROW EXECUTE FUNCTION cria_instrutor();
	
INSERT INTO instrutor(nome, salario) VALUES ('Sininho', 3000);


SELECT * FROM instrutor;

SELECT * FROM log_instrutores;

--------------------------------------------------------------------------------
CREATE OR REPLACE FUNCTION cria_instrutor () RETURNS TRIGGER AS $$ 
	DECLARE
		media_salarial DECIMAL;
		instrutores_recebem_menos INTEGER DEFAULT 0;
		total_instrutores INTEGER DEFAULT 0;
		salario DECIMAL;
		percentual DECIMAL (5,2);
		cursor_salarios refcursor;
	BEGIN
		
		SELECT AVG (instrutor.salario) INTO media_salarial FROM instrutor WHERE id <> NEW.id;
		
		IF NEW.salario > media_salarial THEN
		
			INSERT INTO log_instrutores (informacao) VALUES (NEW.nome || ' recebe acima da média');
		END IF;
		
		SELECT intrutores_internos (NEW.id) INTO cursor_salarios;
		LOOP
			FETCH cursor_salarios INTO salario;
			EXIT WHEN NOT FOUND;
			total_instrutores := total_instrutores + 1;
			
			RAISE NOTICE 'Total de instrutores: %, salario: %', salario, total_instrutores
			
			IF NEW.salario > salario THEN
				instrutores_recebem_menos := instrutores_recebem_menos + 1;
			END IF;
			
		END LOOP;
		
		SELECT MAX (instrutor.salario) INTO salario_maior FROM instrutor WHERE id <> NEW.id;
			
		percentual =  (instrutores_recebem_menos ::DECIMAL / total_instrutores::DECIMAL) * 100;
		
		ASSERT percentual < 100::DECIMAL;
		
		INSERT INTO log_instrutores (informacao) 
			VALUES (NEW.nome || ' recebe mais do que ' || percentual || '% da grade de instrutores');
		RETURN NEW;
		
	END;
	
$$ LANGUAGE plpgsql;