--
-- PostgreSQL database dump
--

\restrict y7WHdiFKjbMZOweNGssUaR4Ht26xqtqHaFYOhlyIgTRQ4gqgRxKrAx6D3fa1pAc

-- Dumped from database version 18.3
-- Dumped by pg_dump version 18.3

-- Started on 2026-05-04 13:48:27

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

SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- TOC entry 227 (class 1259 OID 16429)
-- Name: categories; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.categories (
    id bigint NOT NULL,
    name character varying(50) NOT NULL
);


ALTER TABLE public.categories OWNER TO postgres;

--
-- TOC entry 228 (class 1259 OID 16438)
-- Name: product_categories; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.product_categories (
    product_id bigint NOT NULL,
    category_id bigint NOT NULL
);


ALTER TABLE public.product_categories OWNER TO postgres;

--
-- TOC entry 220 (class 1259 OID 16385)
-- Name: products; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.products (
    id bigint NOT NULL,
    name character varying(100) NOT NULL,
    category character varying(50),
    price numeric(10,2) NOT NULL,
    quantity integer DEFAULT 0,
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP
);


ALTER TABLE public.products OWNER TO postgres;

--
-- TOC entry 230 (class 1259 OID 16460)
-- Name: catalog_snapshot; Type: MATERIALIZED VIEW; Schema: public; Owner: postgres
--

CREATE MATERIALIZED VIEW public.catalog_snapshot AS
 SELECT p.name AS product,
    c.name AS category
   FROM ((public.products p
     JOIN public.product_categories pc ON ((p.id = pc.product_id)))
     JOIN public.categories c ON ((c.id = pc.category_id)))
  WITH NO DATA;


ALTER MATERIALIZED VIEW public.catalog_snapshot OWNER TO postgres;

--
-- TOC entry 226 (class 1259 OID 16428)
-- Name: categories_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

ALTER TABLE public.categories ALTER COLUMN id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME public.categories_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- TOC entry 222 (class 1259 OID 16396)
-- Name: employees; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.employees (
    id bigint NOT NULL,
    given_name character varying(100) CONSTRAINT employees_first_name_not_null NOT NULL,
    last_name character varying(50) NOT NULL,
    hire_date date DEFAULT CURRENT_DATE,
    is_active boolean DEFAULT true,
    salary numeric(10,2) DEFAULT 40000,
    email character varying(100) DEFAULT 'no-email@ozon.ru'::character varying
);


ALTER TABLE public.employees OWNER TO postgres;

--
-- TOC entry 221 (class 1259 OID 16395)
-- Name: employees_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.employees_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.employees_id_seq OWNER TO postgres;

--
-- TOC entry 5078 (class 0 OID 0)
-- Dependencies: 221
-- Name: employees_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.employees_id_seq OWNED BY public.employees.id;


--
-- TOC entry 229 (class 1259 OID 16455)
-- Name: full_catalog_view; Type: VIEW; Schema: public; Owner: postgres
--

CREATE VIEW public.full_catalog_view AS
 SELECT p.name AS product_name,
    c.name AS category_name,
    p.price,
    p.quantity
   FROM ((public.products p
     JOIN public.product_categories pc ON ((p.id = pc.product_id)))
     JOIN public.categories c ON ((c.id = pc.category_id)));


ALTER VIEW public.full_catalog_view OWNER TO postgres;

--
-- TOC entry 223 (class 1259 OID 16412)
-- Name: hr_employee_view; Type: VIEW; Schema: public; Owner: postgres
--

CREATE VIEW public.hr_employee_view AS
 SELECT id,
    (((given_name)::text || ' '::text) || (last_name)::text) AS full_name,
    email,
    salary,
    hire_date,
        CASE
            WHEN (salary > (100000)::numeric) THEN 'Senior'::text
            WHEN (salary > (50000)::numeric) THEN 'Middle'::text
            ELSE 'Junior'::text
        END AS level
   FROM public.employees
  WHERE (is_active = true);


ALTER VIEW public.hr_employee_view OWNER TO postgres;

--
-- TOC entry 225 (class 1259 OID 16417)
-- Name: products_2; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.products_2 (
    id bigint NOT NULL,
    name character varying(150) NOT NULL,
    brand character varying(50) DEFAULT 'NoName'::character varying,
    price numeric(10,2),
    quantity integer DEFAULT 0,
    added_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT products_2_price_check CHECK ((price >= (0)::numeric))
);


ALTER TABLE public.products_2 OWNER TO postgres;

--
-- TOC entry 224 (class 1259 OID 16416)
-- Name: products_2_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

ALTER TABLE public.products_2 ALTER COLUMN id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME public.products_2_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- TOC entry 219 (class 1259 OID 16384)
-- Name: products_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

ALTER TABLE public.products ALTER COLUMN id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME public.products_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- TOC entry 4889 (class 2604 OID 16399)
-- Name: employees id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.employees ALTER COLUMN id SET DEFAULT nextval('public.employees_id_seq'::regclass);


--
-- TOC entry 5070 (class 0 OID 16429)
-- Dependencies: 227
-- Data for Name: categories; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.categories (id, name) FROM stdin;
1	Смартфоны
2	Электроника
3	Подарки
4	Распродажа
\.


--
-- TOC entry 5066 (class 0 OID 16396)
-- Dependencies: 222
-- Data for Name: employees; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.employees (id, given_name, last_name, hire_date, is_active, salary, email) FROM stdin;
\.


--
-- TOC entry 5071 (class 0 OID 16438)
-- Dependencies: 228
-- Data for Name: product_categories; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.product_categories (product_id, category_id) FROM stdin;
1	1
1	2
\.


--
-- TOC entry 5064 (class 0 OID 16385)
-- Dependencies: 220
-- Data for Name: products; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.products (id, name, category, price, quantity, created_at) FROM stdin;
1	iPhone 15	Смартфоны	999.99	10	2026-05-03 12:01:10.705298
4	MacBook Air M2	Ноутбуки	1299.99	5	2026-05-03 12:03:15.095385
5	Samsung Galaxy S24	Смартфоны	849.99	15	2026-05-03 12:03:15.095385
6	Наушники Sony	Аксессуары	199.99	30	2026-05-03 12:03:15.095385
10	car	машины	1000000.00	30	2026-05-04 12:32:18.80632
\.


--
-- TOC entry 5068 (class 0 OID 16417)
-- Dependencies: 225
-- Data for Name: products_2; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.products_2 (id, name, brand, price, quantity, added_at) FROM stdin;
\.


--
-- TOC entry 5079 (class 0 OID 0)
-- Dependencies: 226
-- Name: categories_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.categories_id_seq', 4, true);


--
-- TOC entry 5080 (class 0 OID 0)
-- Dependencies: 221
-- Name: employees_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.employees_id_seq', 1, false);


--
-- TOC entry 5081 (class 0 OID 0)
-- Dependencies: 224
-- Name: products_2_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.products_2_id_seq', 1, false);


--
-- TOC entry 5082 (class 0 OID 0)
-- Dependencies: 219
-- Name: products_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.products_id_seq', 10, true);


--
-- TOC entry 4905 (class 2606 OID 16437)
-- Name: categories categories_name_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.categories
    ADD CONSTRAINT categories_name_key UNIQUE (name);


--
-- TOC entry 4907 (class 2606 OID 16435)
-- Name: categories categories_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.categories
    ADD CONSTRAINT categories_pkey PRIMARY KEY (id);


--
-- TOC entry 4901 (class 2606 OID 16404)
-- Name: employees employees_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.employees
    ADD CONSTRAINT employees_pkey PRIMARY KEY (id);


--
-- TOC entry 4910 (class 2606 OID 16444)
-- Name: product_categories product_categories_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.product_categories
    ADD CONSTRAINT product_categories_pkey PRIMARY KEY (product_id, category_id);


--
-- TOC entry 4903 (class 2606 OID 16427)
-- Name: products_2 products_2_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.products_2
    ADD CONSTRAINT products_2_pkey PRIMARY KEY (id);


--
-- TOC entry 4899 (class 2606 OID 16394)
-- Name: products products_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.products
    ADD CONSTRAINT products_pkey PRIMARY KEY (id);


--
-- TOC entry 4908 (class 1259 OID 16459)
-- Name: idx_pc_category_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_pc_category_id ON public.product_categories USING btree (category_id);


--
-- TOC entry 4911 (class 2606 OID 16450)
-- Name: product_categories product_categories_category_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.product_categories
    ADD CONSTRAINT product_categories_category_id_fkey FOREIGN KEY (category_id) REFERENCES public.categories(id) ON DELETE CASCADE;


--
-- TOC entry 4912 (class 2606 OID 16445)
-- Name: product_categories product_categories_product_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.product_categories
    ADD CONSTRAINT product_categories_product_id_fkey FOREIGN KEY (product_id) REFERENCES public.products(id) ON DELETE CASCADE;


--
-- TOC entry 5072 (class 0 OID 16460)
-- Dependencies: 230 5074
-- Name: catalog_snapshot; Type: MATERIALIZED VIEW DATA; Schema: public; Owner: postgres
--

REFRESH MATERIALIZED VIEW public.catalog_snapshot;


-- Completed on 2026-05-04 13:48:28

--
-- PostgreSQL database dump complete
--

\unrestrict y7WHdiFKjbMZOweNGssUaR4Ht26xqtqHaFYOhlyIgTRQ4gqgRxKrAx6D3fa1pAc

