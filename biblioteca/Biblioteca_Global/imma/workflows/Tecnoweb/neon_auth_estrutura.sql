CREATE EXTENSION IF NOT EXISTS vector;
CREATE SCHEMA IF NOT EXISTS neon_auth;
CREATE SCHEMA IF NOT EXISTS public;
CREATE FUNCTION public.show_db_tree() RETURNS TABLE(tree_structure text)
    LANGUAGE plpgsql
    AS $$
BEGIN
    -- First show all databases
    RETURN QUERY
    SELECT ':file_folder: ' || datname || ' (DATABASE)'
    FROM pg_database 
    WHERE datistemplate = false;
    -- Then show current database structure
    RETURN QUERY
    WITH RECURSIVE 
    -- Get schemas
    schemas AS (
        SELECT 
            n.nspname AS object_name,
            1 AS level,
            n.nspname AS path,
            'SCHEMA' AS object_type
        FROM pg_namespace n
        WHERE n.nspname NOT LIKE 'pg_%' 
        AND n.nspname != 'information_schema'
    ),
    -- Get all objects (tables, views, functions, etc.)
    objects AS (
        SELECT 
            c.relname AS object_name,
            2 AS level,
            s.path || ' → ' || c.relname AS path,
            CASE c.relkind
                WHEN 'r' THEN 'TABLE'
                WHEN 'v' THEN 'VIEW'
                WHEN 'm' THEN 'MATERIALIZED VIEW'
                WHEN 'i' THEN 'INDEX'
                WHEN 'S' THEN 'SEQUENCE'
                WHEN 'f' THEN 'FOREIGN TABLE'
            END AS object_type
        FROM pg_class c
        JOIN pg_namespace n ON n.oid = c.relnamespace
        JOIN schemas s ON n.nspname = s.object_name
        WHERE c.relkind IN ('r','v','m','i','S','f')
        UNION ALL
        SELECT 
            p.proname AS object_name,
            2 AS level,
            s.path || ' → ' || p.proname AS path,
            'FUNCTION' AS object_type
        FROM pg_proc p
        JOIN pg_namespace n ON n.oid = p.pronamespace
        JOIN schemas s ON n.nspname = s.object_name
    ),
    -- Combine schemas and objects
    combined AS (
        SELECT * FROM schemas
        UNION ALL
        SELECT * FROM objects
    )
    -- Final output with tree-like formatting
    SELECT 
        REPEAT('    ', level) || 
        CASE 
            WHEN level = 1 THEN '└── :open_file_folder: '
            ELSE '    └── ' || 
                CASE object_type
                    WHEN 'TABLE' THEN ':bar_chart: '
                    WHEN 'VIEW' THEN ':eye: '
                    WHEN 'MATERIALIZED VIEW' THEN ':newspaper: '
                    WHEN 'FUNCTION' THEN ':zap: '
                    WHEN 'INDEX' THEN ':mag: '
                    WHEN 'SEQUENCE' THEN ':1234: '
                    WHEN 'FOREIGN TABLE' THEN ':globe_with_meridians: '
                    ELSE ''
                END
        END || object_name || ' (' || object_type || ')'
    FROM combined
    ORDER BY path;
END;
$$;
CREATE FUNCTION public.update_updated_at_column() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
    NEW.updated_at = CURRENT_TIMESTAMP;
    RETURN NEW;
END;
$$;
CREATE TABLE neon_auth.users_sync (
    raw_json jsonb NOT NULL,
    id text GENERATED ALWAYS AS ((raw_json ->> 'id'::text)) STORED NOT NULL,
    name text GENERATED ALWAYS AS ((raw_json ->> 'display_name'::text)) STORED,
    email text GENERATED ALWAYS AS ((raw_json ->> 'primary_email'::text)) STORED,
    created_at timestamp with time zone GENERATED ALWAYS AS (to_timestamp((trunc((((raw_json ->> 'signed_up_at_millis'::text))::bigint)::double precision) / (1000)::double precision))) STORED,
    updated_at timestamp with time zone,
    deleted_at timestamp with time zone
);
CREATE TABLE public.agendamentos (
    id integer NOT NULL,
    created_at timestamp with time zone DEFAULT (now() AT TIME ZONE 'America/Sao_Paulo'::text),
    evento_id text,
    titulo text,
    descricao text,
    data_inicio timestamp without time zone,
    data_fim timestamp without time zone,
    link text,
    lembrete_1dia boolean DEFAULT false,
    lembrete_2h boolean DEFAULT false,
    cliente_id integer,
    url_meet text,
    status character varying(20) DEFAULT 'confirmed'::character varying
);
CREATE SEQUENCE public.agendamentos_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
ALTER SEQUENCE public.agendamentos_id_seq OWNED BY public.agendamentos.id;
CREATE TABLE public.atendimentos_internos (
    id integer NOT NULL,
    session_id character varying(255) NOT NULL,
    telefone character varying(20) NOT NULL,
    context text NOT NULL,
    workflow_id character varying(255),
    execution_id character varying(50),
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    nome character varying(255)
);
CREATE SEQUENCE public.atendimentos_internos_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
ALTER SEQUENCE public.atendimentos_internos_id_seq OWNED BY public.atendimentos_internos.id;
CREATE TABLE public.backup_portainer_stacks (
    id integer NOT NULL,
    stack_name character varying(255) NOT NULL,
    stack_id integer NOT NULL,
    endpoint_id integer NOT NULL,
    path character varying(512) NOT NULL,
    message text,
    content text NOT NULL,
    backup_date timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    content_hash character varying(64),
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    updated_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP
);
CREATE SEQUENCE public.backup_portainer_stacks_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
ALTER SEQUENCE public.backup_portainer_stacks_id_seq OWNED BY public.backup_portainer_stacks.id;
CREATE TABLE public.clientes (
    id integer NOT NULL,
    nome character varying(255),
    telefone character varying(20),
    empresa text,
    id_conversa text,
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    "e-mail" character varying(255),
    id_conta integer
);
CREATE SEQUENCE public.clientes_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
ALTER SEQUENCE public.clientes_id_seq OWNED BY public.clientes.id;
CREATE TABLE public.empresa (
    id integer NOT NULL,
    nome character varying(255) NOT NULL,
    cnpj character varying(14) NOT NULL,
    horario_atendimento_inicio time without time zone,
    horario_atendimento_final time without time zone,
    domingo boolean DEFAULT false,
    segunda boolean DEFAULT false,
    terca boolean DEFAULT false,
    quarta boolean DEFAULT false,
    quinta boolean DEFAULT false,
    sexta boolean DEFAULT false,
    sabado boolean DEFAULT false,
    rua character varying(255),
    numero character varying(20),
    complemento character varying(255),
    bairro character varying(255),
    cidade character varying(255),
    estado character varying(2),
    pais character varying(100),
    cep character varying(10)
);
ALTER TABLE public.empresa ALTER COLUMN id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME public.clinica_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);
CREATE TABLE public.contato (
    id integer NOT NULL,
    nome text,
    empresa text,
    telefone character varying,
    email text,
    mensagem text,
    created_at timestamp with time zone
);
ALTER TABLE public.contato ALTER COLUMN id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME public.contato_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);
CREATE TABLE public.feriados (
    id integer NOT NULL,
    ano integer NOT NULL,
    data_feriado date NOT NULL,
    nome character varying(255) NOT NULL,
    tipo text,
    exportado_n8n boolean DEFAULT false,
    empresa_id integer
);
ALTER TABLE public.feriados ALTER COLUMN id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME public.feriados_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);
CREATE TABLE public.historico_conversas (
    id integer NOT NULL,
    msg_usuario text,
    msg_ia text,
    created_at timestamp with time zone DEFAULT (now() AT TIME ZONE 'America/Sao_Paulo'::text) NOT NULL,
    telefone character varying(20),
    embedding public.vector(1536)
);
CREATE SEQUENCE public.historico_conversas_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
ALTER SEQUENCE public.historico_conversas_id_seq OWNED BY public.historico_conversas.id;
CREATE TABLE public.rag_documents (
    id bigint NOT NULL,
    metadata jsonb DEFAULT '{}'::jsonb,
    text text NOT NULL,
    embedding public.vector(1536) NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL
);
CREATE SEQUENCE public.rag_documents_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
ALTER SEQUENCE public.rag_documents_id_seq OWNED BY public.rag_documents.id;
CREATE TABLE public.usages (
    id bigint NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    model character varying,
    input_tokens integer,
    output_tokens integer,
    total_tokens integer,
    workflow_id character varying,
    execution_id integer,
    customer_id character varying
);
ALTER TABLE public.usages ALTER COLUMN id ADD GENERATED BY DEFAULT AS IDENTITY (
    SEQUENCE NAME public.usages_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);
ALTER TABLE ONLY public.agendamentos ALTER COLUMN id SET DEFAULT nextval('public.agendamentos_id_seq'::regclass);
ALTER TABLE ONLY public.atendimentos_internos ALTER COLUMN id SET DEFAULT nextval('public.atendimentos_internos_id_seq'::regclass);
ALTER TABLE ONLY public.backup_portainer_stacks ALTER COLUMN id SET DEFAULT nextval('public.backup_portainer_stacks_id_seq'::regclass);
ALTER TABLE ONLY public.clientes ALTER COLUMN id SET DEFAULT nextval('public.clientes_id_seq'::regclass);
ALTER TABLE ONLY public.historico_conversas ALTER COLUMN id SET DEFAULT nextval('public.historico_conversas_id_seq'::regclass);
ALTER TABLE ONLY public.rag_documents ALTER COLUMN id SET DEFAULT nextval('public.rag_documents_id_seq'::regclass);
ALTER TABLE ONLY neon_auth.users_sync
    ADD CONSTRAINT users_sync_pkey PRIMARY KEY (id);
ALTER TABLE ONLY public.agendamentos
    ADD CONSTRAINT agendamentos_pkey PRIMARY KEY (id);
ALTER TABLE ONLY public.atendimentos_internos
    ADD CONSTRAINT atendimentos_internos_pkey PRIMARY KEY (id);
ALTER TABLE ONLY public.backup_portainer_stacks
    ADD CONSTRAINT backup_portainer_stacks_pkey PRIMARY KEY (id);
ALTER TABLE ONLY public.backup_portainer_stacks
    ADD CONSTRAINT backup_portainer_stacks_stack_endpoint_uk UNIQUE (stack_id, endpoint_id);
ALTER TABLE ONLY public.clientes
    ADD CONSTRAINT clientes_id_conversa_key UNIQUE (id_conversa);
ALTER TABLE ONLY public.clientes
    ADD CONSTRAINT clientes_pkey PRIMARY KEY (id);
ALTER TABLE ONLY public.clientes
    ADD CONSTRAINT clientes_telefone_key UNIQUE (telefone);
ALTER TABLE ONLY public.empresa
    ADD CONSTRAINT clinica_cnpj_key UNIQUE (cnpj);
ALTER TABLE ONLY public.empresa
    ADD CONSTRAINT clinica_pkey PRIMARY KEY (id);
ALTER TABLE ONLY public.contato
    ADD CONSTRAINT contato_pkey PRIMARY KEY (id);
ALTER TABLE ONLY public.feriados
    ADD CONSTRAINT feriados_pkey PRIMARY KEY (id, ano);
ALTER TABLE ONLY public.historico_conversas
    ADD CONSTRAINT historico_conversas_pkey PRIMARY KEY (id);
ALTER TABLE ONLY public.rag_documents
    ADD CONSTRAINT rag_documents_pkey PRIMARY KEY (id);
ALTER TABLE ONLY public.feriados
    ADD CONSTRAINT unq_feriado_empresa UNIQUE (data_feriado, empresa_id);
ALTER TABLE ONLY public.usages
    ADD CONSTRAINT usages_pkey PRIMARY KEY (id);
CREATE INDEX users_sync_deleted_at_idx ON neon_auth.users_sync USING btree (deleted_at);
CREATE INDEX historico_conversas_embedding_idx ON public.historico_conversas USING hnsw (embedding public.vector_cosine_ops);
CREATE INDEX idx_agendamentos_cliente_id ON public.agendamentos USING btree (cliente_id);
CREATE UNIQUE INDEX idx_agendamentos_created_at ON public.agendamentos USING btree (created_at);
CREATE INDEX idx_agendamentos_data_inicio ON public.agendamentos USING btree (data_inicio);
CREATE INDEX idx_agendamentos_evento_id ON public.agendamentos USING btree (evento_id);
CREATE INDEX idx_atendimentos_created_at ON public.atendimentos_internos USING btree (created_at DESC);
CREATE INDEX idx_atendimentos_session_id ON public.atendimentos_internos USING btree (session_id);
CREATE INDEX idx_atendimentos_telefone ON public.atendimentos_internos USING btree (telefone);
CREATE INDEX idx_atendimentos_workflow ON public.atendimentos_internos USING btree (workflow_id, execution_id);
CREATE INDEX idx_backup_stacks_id ON public.backup_portainer_stacks USING btree (stack_id);
CREATE INDEX idx_backup_stacks_name_date ON public.backup_portainer_stacks USING btree (stack_name, backup_date DESC);
CREATE INDEX idx_clientes_telefone ON public.clientes USING btree (telefone);
CREATE UNIQUE INDEX idx_feriados_unicos ON public.feriados USING btree (data_feriado, empresa_id);
CREATE INDEX idx_rag_documents_embedding_cos ON public.rag_documents USING ivfflat (embedding public.vector_cosine_ops) WITH (lists='100');
CREATE TRIGGER update_backup_stacks_updated_at BEFORE UPDATE ON public.backup_portainer_stacks FOR EACH ROW EXECUTE FUNCTION public.update_updated_at_column();
ALTER TABLE ONLY public.agendamentos
    ADD CONSTRAINT agendamentos_cliente_id_fkey FOREIGN KEY (cliente_id) REFERENCES public.clientes(id) ON DELETE CASCADE;
ALTER TABLE ONLY public.historico_conversas
    ADD CONSTRAINT historico_conversas_telefone_fkey FOREIGN KEY (telefone) REFERENCES public.clientes(telefone) ON DELETE CASCADE;
ALTER TABLE public.agendamentos ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.atendimentos_internos ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.backup_portainer_stacks ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.clientes ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.contato ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.empresa ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.feriados ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.historico_conversas ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.rag_documents ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.usages ENABLE ROW LEVEL SECURITY;
ALTER DEFAULT PRIVILEGES FOR ROLE cloud_admin IN SCHEMA public GRANT ALL ON SEQUENCES TO neon_superuser WITH GRANT OPTION;
ALTER DEFAULT PRIVILEGES FOR ROLE cloud_admin IN SCHEMA public GRANT ALL ON TABLES TO neon_superuser WITH GRANT OPTION;
