--
-- PostgreSQL database dump
--

\restrict a3UOdNcl2eAxrU84ehmOIv1DJwtPvkefoiazj3OrmMnfPuR31wgxwt1mMBbvH9D

-- Dumped from database version 17.11
-- Dumped by pg_dump version 17.11

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET transaction_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET xmloption = content;
SET client_min_messages = warning;
SET row_security = off;

ALTER TABLE IF EXISTS ONLY public.avaliacoes DROP CONSTRAINT IF EXISTS avaliacoes_usuario_id_fkey;
ALTER TABLE IF EXISTS ONLY public.avaliacoes DROP CONSTRAINT IF EXISTS avaliacoes_refeicao_id_fkey;
DROP INDEX IF EXISTS public.usuarios_email_unico_idx;
DROP INDEX IF EXISTS public.refeicoes_nome_idx;
DROP INDEX IF EXISTS public.refeicoes_data_idx;
DROP INDEX IF EXISTS public.avaliacoes_usuario_id_idx;
DROP INDEX IF EXISTS public.avaliacoes_servido_em_idx;
ALTER TABLE IF EXISTS ONLY public.usuarios DROP CONSTRAINT IF EXISTS usuarios_pkey;
ALTER TABLE IF EXISTS ONLY public.usuarios DROP CONSTRAINT IF EXISTS usuarios_email_key;
ALTER TABLE IF EXISTS ONLY public.usuarios DROP CONSTRAINT IF EXISTS usuarios_cpf_key;
ALTER TABLE IF EXISTS ONLY public.schema_migrations DROP CONSTRAINT IF EXISTS schema_migrations_pkey;
ALTER TABLE IF EXISTS ONLY public.refeicoes DROP CONSTRAINT IF EXISTS refeicoes_pkey;
ALTER TABLE IF EXISTS ONLY public.refeicoes DROP CONSTRAINT IF EXISTS refeicoes_data_periodo_key;
ALTER TABLE IF EXISTS ONLY public.avaliacoes DROP CONSTRAINT IF EXISTS avaliacoes_usuario_id_refeicao_id_servido_em_key;
ALTER TABLE IF EXISTS ONLY public.avaliacoes DROP CONSTRAINT IF EXISTS avaliacoes_pkey;
ALTER TABLE IF EXISTS public.refeicoes ALTER COLUMN id DROP DEFAULT;
DROP TABLE IF EXISTS public.usuarios;
DROP TABLE IF EXISTS public.schema_migrations;
DROP SEQUENCE IF EXISTS public.refeicoes_id_seq;
DROP TABLE IF EXISTS public.refeicoes;
DROP TABLE IF EXISTS public.avaliacoes;
DROP TYPE IF EXISTS public.tipo_usuario;
DROP TYPE IF EXISTS public.periodo_refeicao;
DROP EXTENSION IF EXISTS pgcrypto;
--
-- Name: pgcrypto; Type: EXTENSION; Schema: -; Owner: -
--

CREATE EXTENSION IF NOT EXISTS pgcrypto WITH SCHEMA public;


--
-- Name: EXTENSION pgcrypto; Type: COMMENT; Schema: -; Owner: 
--

COMMENT ON EXTENSION pgcrypto IS 'cryptographic functions';


--
-- Name: periodo_refeicao; Type: TYPE; Schema: public; Owner: cardapio
--

CREATE TYPE public.periodo_refeicao AS ENUM (
    'manha',
    'almoco',
    'tarde'
);


ALTER TYPE public.periodo_refeicao OWNER TO cardapio;

--
-- Name: tipo_usuario; Type: TYPE; Schema: public; Owner: cardapio
--

CREATE TYPE public.tipo_usuario AS ENUM (
    'administrador',
    'cozinha',
    'aluno'
);


ALTER TYPE public.tipo_usuario OWNER TO cardapio;

SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- Name: avaliacoes; Type: TABLE; Schema: public; Owner: cardapio
--

CREATE TABLE public.avaliacoes (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    usuario_id uuid NOT NULL,
    refeicao_id integer NOT NULL,
    servido_em date NOT NULL,
    nota smallint NOT NULL,
    comentario character varying(500),
    criado_em timestamp with time zone DEFAULT now() NOT NULL,
    CONSTRAINT avaliacoes_nota_check CHECK (((nota >= 1) AND (nota <= 5)))
);


ALTER TABLE public.avaliacoes OWNER TO cardapio;

--
-- Name: refeicoes; Type: TABLE; Schema: public; Owner: cardapio
--

CREATE TABLE public.refeicoes (
    id integer NOT NULL,
    periodo public.periodo_refeicao NOT NULL,
    descricao text NOT NULL,
    data date NOT NULL,
    nome character varying(120) NOT NULL
);


ALTER TABLE public.refeicoes OWNER TO cardapio;

--
-- Name: refeicoes_id_seq; Type: SEQUENCE; Schema: public; Owner: cardapio
--

CREATE SEQUENCE public.refeicoes_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.refeicoes_id_seq OWNER TO cardapio;

--
-- Name: refeicoes_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: cardapio
--

ALTER SEQUENCE public.refeicoes_id_seq OWNED BY public.refeicoes.id;


--
-- Name: schema_migrations; Type: TABLE; Schema: public; Owner: cardapio
--

CREATE TABLE public.schema_migrations (
    name text NOT NULL,
    applied_at timestamp with time zone DEFAULT now() NOT NULL
);


ALTER TABLE public.schema_migrations OWNER TO cardapio;

--
-- Name: usuarios; Type: TABLE; Schema: public; Owner: cardapio
--

CREATE TABLE public.usuarios (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    nome character varying(120) NOT NULL,
    cpf character(11) NOT NULL,
    telefone character varying(20) NOT NULL,
    email character varying(160) NOT NULL,
    senha_hash text NOT NULL,
    tipo public.tipo_usuario DEFAULT 'aluno'::public.tipo_usuario NOT NULL,
    criado_em timestamp with time zone DEFAULT now() NOT NULL,
    CONSTRAINT usuarios_cpf_check CHECK ((cpf ~ '^[0-9]{11}$'::text))
);


ALTER TABLE public.usuarios OWNER TO cardapio;

--
-- Name: refeicoes id; Type: DEFAULT; Schema: public; Owner: cardapio
--

ALTER TABLE ONLY public.refeicoes ALTER COLUMN id SET DEFAULT nextval('public.refeicoes_id_seq'::regclass);


--
-- Data for Name: avaliacoes; Type: TABLE DATA; Schema: public; Owner: cardapio
--

COPY public.avaliacoes (id, usuario_id, refeicao_id, servido_em, nota, comentario, criado_em) FROM stdin;
f31a3881-374d-4a0f-8d38-3ebaf735ea0f	fce07bd2-0abe-49a2-af26-7508b7b6aea0	4	2026-08-25	5	o cachorro tava bem temperado. ameiiiii	2026-08-25 11:09:31.748335-03
6384f5d7-3f2b-4cf7-ab2a-fea9f4c6dac6	47fc8838-00ed-4d8c-a348-e77877703503	4	2026-08-25	1	muito salgado	2026-08-25 12:52:58.048964-03
73c09796-156c-4896-9b36-cbdfa084c42b	da593bba-f6eb-4d54-b83a-e05554d9dff0	4	2026-08-25	3	Precisa de menos óleo, e de menos sal.	2026-08-25 13:00:15.577369-03
0a471826-6fbb-4144-83ef-e008d166ffe6	71800530-dbb1-4f13-ad9a-350c4c866ab6	4	2026-08-25	1	muito oleoso e tbm muito salgado, minha pressão aumentou muito!!!!!!!	2026-08-25 13:00:27.129844-03
\.


--
-- Data for Name: refeicoes; Type: TABLE DATA; Schema: public; Owner: cardapio
--

COPY public.refeicoes (id, periodo, descricao, data, nome) FROM stdin;
1	manha	Uma pausa leve para começar bem o turno.	2026-08-24	Lanche da manhã
4	manha	Uma pausa leve para começar bem o turno.	2026-08-25	Lanche da manhã
13	manha	Uma pausa leve para começar bem o turno.	2026-08-28	Lanche da manhã
14	almoco	Refeição completa preparada para o dia de aula.	2026-08-28	Almoço
15	tarde	Energia para finalizar as atividades.	2026-08-28	Lanche da tarde
31	manha	Pão com carne moída ao molho e suco de fruta.	2026-08-06	Cachorro-quente
32	almoco	Arroz, feijão, frango assado, salada e fruta.	2026-08-06	Arroz, feijão e frango
33	tarde	Bolo caseiro acompanhado de vitamina de banana.	2026-08-06	Bolo com vitamina
34	manha	Cuscuz de milho com ovos mexidos e café com leite.	2026-08-08	Cuscuz com ovos
35	almoco	Macarrão ao molho de tomate com carne moída e legumes.	2026-08-08	Macarronada com carne
36	tarde	Sanduíche de frango com salada e suco de acerola.	2026-08-08	Sanduíche natural
2	almoco	Refeição completa preparada para o dia de aula.	2026-08-24	Almoço
7	manha	Cuscuz com salsicha assada	2026-08-26	Cuscuz com salsicha
8	almoco	Arroz, feijão e galinha assada	2026-08-26	Galinha assada
9	tarde	Pão com ovo e vitamina	2026-08-26	Pão com ovo
10	manha	arroz com caldo de frango	2026-08-27	risoto
11	almoco	macarrão e galinha guisada	2026-08-27	galinha guisada
12	tarde	frutas cortadas e recheio de leite condensado em um copo de plástico	2026-08-27	salada de frutas
47	tarde	kkkkkkkkkkk	2026-08-25	Pizza de pernas de aranha seca ao molho.
53	manha	testando	2026-09-18	TESTE BKP OLHA A DATA
54	manha	Cuscuz quentinho com ovos mexidos e café com leite.	2026-09-21	Cuscuz com ovos
55	almoco	Arroz branco, feijão carioca, filé de frango grelhado e salada de alface com tomate.	2026-09-21	Frango grelhado com arroz e feijão
56	tarde	Bolo de cenoura caseiro acompanhado de suco de laranja natural.	2026-09-21	Bolo de cenoura e suco
57	manha	Pão francês com queijo branco derretido e maçã fresca.	2026-09-22	Pão com queijo e fruta
58	almoco	Arroz, feijão preto, carne moída refogada com cenoura e batata, acompanhada de farofa.	2026-09-22	Carne moída com legumes
59	tarde	Vitamina cremosa de banana com aveia e biscoito integral.	2026-09-22	Vitamina de banana e biscoito
60	manha	Iogurte natural batido com frutas e porção de granola crocante.	2026-09-23	Iogurte com granola
61	almoco	Macarrão espaguete ao molho de tomate caseiro com carne bovina e queijo ralado.	2026-09-23	Macarronada à bolonhesa
62	tarde	Mix de frutas da estação (mamão, melancia e banana) com suco de maracujá.	2026-09-23	Salada de frutas
63	manha	Tapioca tradicional com queijo e manteiga acompanhada de chá mate gelado.	2026-09-24	Tapioca recheada
64	almoco	Filé de peixe assado com ervas, purê de batatas cremoso, arroz e feijão.	2026-09-24	Peixe ao forno com purê
65	tarde	Pão integral com pasta de frango desfiado, cenoura ralada e suco de uva.	2026-09-24	Sanduíche natural de frango
66	manha	Pães de queijo artesanais assados na hora acompanhados de achocolatado.	2026-09-25	Pão de queijo quentinho
67	almoco	Feijoada leve tradicional com carnes magras, arroz branco, couve refogada e fatias de laranja.	2026-09-25	Feijoada escolar
68	tarde	Torta integral de banana com canela e suco de goiaba.	2026-09-25	Torta de banana com suco
69	manha	Cuscuz nordestino quentinho servido com carne bovina desfiada e café com leite.	2026-09-28	Cuscuz com carne desfiada
70	almoco	Strogonoff cremoso de frango, arroz branco soltinho, batata palha e salada de tomate.	2026-09-28	Strogonoff de frango com arroz
71	tarde	Pão francês levemente tostado com requeijão cremoso e uma maçã fresca.	2026-09-28	Pão com requeijão e maçã
72	manha	Mingau de aveia suave com um toque de canela e pedaços de banana.	2026-09-29	Mingau de aveia com canela
73	almoco	Carne bovina cozida ao molho com mandioca macia, arroz branco e feijão carioca.	2026-09-29	Carne de panela com mandioca
74	tarde	Fatia generosa de bolo de milho caseiro e suco integral de uva.	2026-09-29	Bolo de milho e suco de uva
75	manha	Pão francês fresquinho prensado com presunto magro e queijo prato, servido com suco de laranja.	2026-09-30	Pão com presunto e queijo
76	almoco	Escondidinho de purê de batata gratinado com recheio de carne moída bem temperada, arroz e salada.	2026-09-30	Escondidinho de carne moída
77	tarde	Biscoitos de polvilho crocantes acompanhados de iogurte de morango.	2026-09-30	Biscoito caseiro com iogurte
78	manha	Tapioca recheada com queijo coalho na chapa e café fresco.	2026-10-01	Tapioca de queijo coalho
79	almoco	Iscas de peito de frango aceboladas, feijão tropeiro leve, arroz branco e couve fatiada.	2026-10-01	Iscas de frango aceboladas
80	tarde	Frutas frescas picadas (abacaxi, melão e uva) salpicadas com granola e suco de goiaba.	2026-10-01	Salada de frutas com granola
81	manha	Pães de queijo mineiros assados na hora servidos com suco natural de maracujá.	2026-10-02	Pão de queijo e suco de maracujá
82	almoco	Lasanha com massa fresca, molho bolonhesa artesanal, queijo mussarela e salada verde.	2026-10-02	Lasanha à bolonhesa escolar
83	tarde	Vitamina cremosa de abacate batida com leite e torradas integrais crocantes.	2026-10-02	Vitamina de abacate e torrada
84	manha	Cuscuz de milho tradicional com queijo derretido por cima e café com leite adoçado.	2026-10-05	Cuscuz com queijo e café
85	almoco	Sobrecoxa de frango assada com batata e cenoura, arroz soltinho, feijão preto e salada de repolho.	2026-10-05	Frango assado com legumes
86	tarde	Bolo de cacau caseiro fofinho acompanhado de um copo de leite frio.	2026-10-05	Bolo de chocolate e leite
87	manha	Pão de forma integral com patê suave de atum com ricota e chá de camomila gelado.	2026-10-06	Pão com pasta de atum
88	almoco	Almôndegas bovinas suculentas ao molho de tomate fresco, purê de batatas e arroz integral.	2026-10-06	Almôndegas ao sugo com purê
89	tarde	Pedaços refrescantes de melancia, mamão e banana com suco de acerola.	2026-10-06	Mix de frutas da estação
90	manha	Tigela de iogurte natural batido com um toque de mel, sementes de chia e morangos picados.	2026-10-07	Iogurte natural com mel e chia
91	almoco	Baião de dois tradicional com queijo coalho e feijão verde, servido com carne de sol acebolada e vinagrete.	2026-10-07	Baião de dois com carne de sol
92	tarde	Pão francês quentinho recheado com queijo minas frescal e suco de caju.	2026-10-07	Sanduíche de queijo branco
93	manha	Crepioca leve recheada com frango desfiado temperado com ervas finas e café com leite.	2026-10-08	Crepioca de frango
94	almoco	Cubos de carne macia cozidos com vagem e cenoura, arroz branco, feijão carioca e farofa crocante.	2026-10-08	Picadinho bovino com legumes
95	tarde	Bolo artesanal de laranja com raspas e suco de abacaxi com hortelã.	2026-10-08	Bolo de laranja e suco
96	manha	Pão tostado na manteiga com ovos mexidos cremosos e achocolatado quente.	2026-10-09	Pão na chapa com ovos mexidos
97	almoco	Filé de tilápia grelhada servida com pirão de peixe saboroso, arroz branco e salada de alface e pepino.	2026-10-09	Filé de peixe grelhado com pirão
98	tarde	Fatia de torta integral de maçã com canela e vitamina refrescante de morango.	2026-10-09	Torta de maçã e vitamina
\.


--
-- Data for Name: schema_migrations; Type: TABLE DATA; Schema: public; Owner: cardapio
--

COPY public.schema_migrations (name, applied_at) FROM stdin;
001_initial.sql	2026-08-24 11:36:08.24843-03
002_nomes_em_portugues.sql	2026-08-24 11:36:08.47987-03
003_usuarios_e_tipos.sql	2026-08-24 11:36:08.488373-03
004_garantir_cardapio_inicial.sql	2026-08-24 11:36:08.517383-03
005_remover_nome_e_itens_refeicoes.sql	2026-08-24 11:36:08.527276-03
006_horarios_fixos_refeicoes.sql	2026-08-24 11:36:08.535402-03
007_refeicoes_por_data.sql	2026-08-24 11:36:08.544774-03
008_massa_refeicoes_agosto_2026.sql	2026-08-24 11:36:08.562327-03
\.


--
-- Data for Name: usuarios; Type: TABLE DATA; Schema: public; Owner: cardapio
--

COPY public.usuarios (id, nome, cpf, telefone, email, senha_hash, tipo, criado_em) FROM stdin;
ada9e430-aec6-466b-a0e3-89444b0027cc	Administrador ETE	11111111111	(81) 99999-9999	administrador@ete.local	$2a$10$UXc09G15STwaj7vdVpqaN.jgeVTooECD5L7exgtxEVUchgHtUWZvm	administrador	2026-08-24 11:36:08.24843-03
aa083940-93cc-45f6-9f50-76c0f1e2cd3d	Claudiana Rakelly	17357348458	(22) 22222-2222	claudianarakellypimentel@gmail.com	$2b$10$Md1AWIT7fGeTz3xkSUamjewHEYDqnKEnUzZmxAsfH6Qbg0XU3zJae	administrador	2026-08-24 12:33:20.59531-03
c36f016a-fbc7-45cf-a547-ba989672d072	George	44444444444	(44) 44444-4444	george@gmail.com	$2b$10$kqd3g1YmtSO3doR3ZUILGOVDcTfXUDsgrSPVi9AnG2AkBeulapGcy	aluno	2026-08-24 13:01:17.980467-03
bedd76b2-e208-4e18-8a23-291bdfa635f5	Gustavo	55555555555	(55) 55555-5555	gustavo@gmail.com	$2b$10$sZYA1lSPtOkUooMMaQqnauSlxCgch66HkvSrTQWzyvDEC1zp6QH9u	cozinha	2026-08-24 13:01:41.565897-03
344f94c3-d875-4317-ac68-4a9a867db18e	Murilo	77777777777	(77) 77777-7777	murilo@gmail.com	$2b$10$vBiI2ZbS99j4aIHExproAe1IANGw1YeHmbaglRn6gXS/QbAZbFoJm	aluno	2026-08-24 13:02:32.05781-03
3ac65d3f-c52b-4adf-9dc5-3c3c9ca2eb4d	Vitor	88888888888	(88) 88888-8888	vitor@gmail.com	$2b$10$nOQ2xOzVFnIJ.sUMCyN/Au.ezyR0Y1ArAekIQCh0ewvhI6vNcPxIy	aluno	2026-08-24 13:03:18.908568-03
47fc8838-00ed-4d8c-a348-e77877703503	weslley	00000000009	(00) 00000-0009	weslley@gmail.com	$2b$10$K4/6s7hpzBwmeEBuAon1GubAoBlYKpNSWbhYLHgtxopSck24VebCe	aluno	2026-08-24 13:04:54.413341-03
6aadb67a-9af0-4b3f-b115-0e1a2b2e8c00	Bianca	15329389429	(33) 33333-3333	bianca@gmail.com	$2b$10$ibLpUR6DNrfui9/eBR7UFOaMOZqwGVAKH4NPLNpN6PbboyV9K6qn.	cozinha	2026-08-24 13:00:51.314782-03
fce07bd2-0abe-49a2-af26-7508b7b6aea0	Sandro Ricardo	12345678910	(00) 00000-0000	sandroricardo@gmail.com	$2b$10$O58vXiRz3OBpENFlCBGMA.wC6nuJYf9owYxrMEApdOD.vTMvFaN7.	aluno	2026-08-24 13:06:04.434013-03
da593bba-f6eb-4d54-b83a-e05554d9dff0	Alessandro	15988680470	(00) 00000-0000	alessandro@gmail.com	$2b$10$vMLWj5he/tz803Q43j5gQ.vIAmYrSivxl/LZhoE.YfyxMbE5Q8l0e	aluno	2026-08-24 13:00:21.030301-03
8799c70e-a004-4e8e-b655-55c5f95332a0	João Gabriel	15635901409	(33) 33333-3333	joao.gariel@gmail.com	$2b$10$lbNMH02mbgoq/9xqyqpjn.FVa1MX4hVnt8.wqCcQiu6UMLwt3q3O6	administrador	2026-08-24 12:35:09.213567-03
71800530-dbb1-4f13-ad9a-350c4c866ab6	Kauã	66666666666	(66) 66666-6666	kaua@gmail.com	$2b$10$5lYaVxNArsbaHhJFwT4M8eQEQmT7OLNOh8ns2UuZKcpRSThPOyJQO	aluno	2026-08-24 13:02:04.465791-03
335edd30-bd49-421b-9b2e-bec9512fa23f	José Arthur	99999999999	(99) 99999-9999	josearthur@gmail.com	$2b$10$3O9GEk/IcUaxdkX9U7Rc/umwWcP0bPvRfcweDWaTeklxoj9gstDB6	aluno	2026-08-24 13:03:50.726699-03
a638b2d9-b73d-4d0e-aa30-77654884290c	Ellen Vitória	00000000000	(11) 11111-1111	ellen.vitoria@gmail.com	$2b$10$MWu65QMjjT3GKaWObDVGGerDSZHWYVyEWZKRk0rI3WUoyY6E.hiAm	administrador	2026-08-24 12:32:25.489665-03
\.


--
-- Name: refeicoes_id_seq; Type: SEQUENCE SET; Schema: public; Owner: cardapio
--

SELECT pg_catalog.setval('public.refeicoes_id_seq', 98, true);


--
-- Name: avaliacoes avaliacoes_pkey; Type: CONSTRAINT; Schema: public; Owner: cardapio
--

ALTER TABLE ONLY public.avaliacoes
    ADD CONSTRAINT avaliacoes_pkey PRIMARY KEY (id);


--
-- Name: avaliacoes avaliacoes_usuario_id_refeicao_id_servido_em_key; Type: CONSTRAINT; Schema: public; Owner: cardapio
--

ALTER TABLE ONLY public.avaliacoes
    ADD CONSTRAINT avaliacoes_usuario_id_refeicao_id_servido_em_key UNIQUE (usuario_id, refeicao_id, servido_em);


--
-- Name: refeicoes refeicoes_data_periodo_key; Type: CONSTRAINT; Schema: public; Owner: cardapio
--

ALTER TABLE ONLY public.refeicoes
    ADD CONSTRAINT refeicoes_data_periodo_key UNIQUE (data, periodo);


--
-- Name: refeicoes refeicoes_pkey; Type: CONSTRAINT; Schema: public; Owner: cardapio
--

ALTER TABLE ONLY public.refeicoes
    ADD CONSTRAINT refeicoes_pkey PRIMARY KEY (id);


--
-- Name: schema_migrations schema_migrations_pkey; Type: CONSTRAINT; Schema: public; Owner: cardapio
--

ALTER TABLE ONLY public.schema_migrations
    ADD CONSTRAINT schema_migrations_pkey PRIMARY KEY (name);


--
-- Name: usuarios usuarios_cpf_key; Type: CONSTRAINT; Schema: public; Owner: cardapio
--

ALTER TABLE ONLY public.usuarios
    ADD CONSTRAINT usuarios_cpf_key UNIQUE (cpf);


--
-- Name: usuarios usuarios_email_key; Type: CONSTRAINT; Schema: public; Owner: cardapio
--

ALTER TABLE ONLY public.usuarios
    ADD CONSTRAINT usuarios_email_key UNIQUE (email);


--
-- Name: usuarios usuarios_pkey; Type: CONSTRAINT; Schema: public; Owner: cardapio
--

ALTER TABLE ONLY public.usuarios
    ADD CONSTRAINT usuarios_pkey PRIMARY KEY (id);


--
-- Name: avaliacoes_servido_em_idx; Type: INDEX; Schema: public; Owner: cardapio
--

CREATE INDEX avaliacoes_servido_em_idx ON public.avaliacoes USING btree (servido_em);


--
-- Name: avaliacoes_usuario_id_idx; Type: INDEX; Schema: public; Owner: cardapio
--

CREATE INDEX avaliacoes_usuario_id_idx ON public.avaliacoes USING btree (usuario_id);


--
-- Name: refeicoes_data_idx; Type: INDEX; Schema: public; Owner: cardapio
--

CREATE INDEX refeicoes_data_idx ON public.refeicoes USING btree (data);


--
-- Name: refeicoes_nome_idx; Type: INDEX; Schema: public; Owner: cardapio
--

CREATE INDEX refeicoes_nome_idx ON public.refeicoes USING btree (nome);


--
-- Name: usuarios_email_unico_idx; Type: INDEX; Schema: public; Owner: cardapio
--

CREATE UNIQUE INDEX usuarios_email_unico_idx ON public.usuarios USING btree (email);


--
-- Name: avaliacoes avaliacoes_refeicao_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: cardapio
--

ALTER TABLE ONLY public.avaliacoes
    ADD CONSTRAINT avaliacoes_refeicao_id_fkey FOREIGN KEY (refeicao_id) REFERENCES public.refeicoes(id) ON DELETE RESTRICT;


--
-- Name: avaliacoes avaliacoes_usuario_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: cardapio
--

ALTER TABLE ONLY public.avaliacoes
    ADD CONSTRAINT avaliacoes_usuario_id_fkey FOREIGN KEY (usuario_id) REFERENCES public.usuarios(id) ON DELETE CASCADE;


--
-- PostgreSQL database dump complete
--

\unrestrict a3UOdNcl2eAxrU84ehmOIv1DJwtPvkefoiazj3OrmMnfPuR31wgxwt1mMBbvH9D

