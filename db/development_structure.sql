--
-- PostgreSQL database dump
--

SET statement_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = off;
SET check_function_bodies = false;
SET client_min_messages = warning;
SET escape_string_warning = off;

--
-- Name: plpgsql; Type: PROCEDURAL LANGUAGE; Schema: -; Owner: -
--

CREATE OR REPLACE PROCEDURAL LANGUAGE plpgsql;


SET search_path = public, pg_catalog;

SET default_tablespace = '';

SET default_with_oids = false;

--
-- Name: alignments; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE alignments (
    id integer NOT NULL,
    source text NOT NULL,
    lemma text NOT NULL,
    definition text NOT NULL,
    synonyms text NOT NULL,
    key text NOT NULL,
    syn_set_id integer NOT NULL,
    relation_type_name text NOT NULL
);


--
-- Name: alignments_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE alignments_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: alignments_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE alignments_id_seq OWNED BY alignments.id;


--
-- Name: c_corpora; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE c_corpora (
    id integer NOT NULL,
    name text
);


--
-- Name: c_korpus2000_sentences; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE c_korpus2000_sentences (
    id integer NOT NULL,
    sentence_id integer NOT NULL,
    preom integer NOT NULL,
    bop integer NOT NULL,
    eop integer NOT NULL,
    genre integer NOT NULL,
    agerel integer NOT NULL,
    medium integer NOT NULL,
    prody integer NOT NULL,
    aspect integer NOT NULL
);


--
-- Name: c_korpus2000_sentences_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE c_korpus2000_sentences_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: c_korpus2000_sentences_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE c_korpus2000_sentences_id_seq OWNED BY c_korpus2000_sentences.id;


--
-- Name: c_lemma_unigrams; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE c_lemma_unigrams (
    pick_id integer NOT NULL,
    lemma_id integer NOT NULL,
    freq_p numeric NOT NULL
);


--
-- Name: c_lemmas; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE c_lemmas (
    chars text NOT NULL,
    id integer NOT NULL
);


--
-- Name: c_lemmas_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE c_lemmas_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: c_lemmas_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE c_lemmas_id_seq OWNED BY c_lemmas.id;


--
-- Name: c_picks; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE c_picks (
    id integer NOT NULL,
    name text NOT NULL,
    count integer NOT NULL
);


--
-- Name: c_picks_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE c_picks_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: c_picks_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE c_picks_id_seq OWNED BY c_picks.id;


--
-- Name: c_pos_tags; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE c_pos_tags (
    id integer NOT NULL,
    name text NOT NULL
);


--
-- Name: c_pos_tag_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE c_pos_tag_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: c_pos_tag_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE c_pos_tag_id_seq OWNED BY c_pos_tags.id;


--
-- Name: c_sentences; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE c_sentences (
    id integer NOT NULL,
    corpus_id integer NOT NULL
);


--
-- Name: c_tokens; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE c_tokens (
    sentence_id integer NOT NULL,
    "position" integer NOT NULL,
    pos_tags integer[] DEFAULT '{}'::integer[] NOT NULL,
    word_form_id integer NOT NULL,
    lemma_id integer
);


--
-- Name: c_word_forms_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE c_word_forms_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: c_word_forms; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE c_word_forms (
    id integer DEFAULT nextval('c_word_forms_id_seq'::regclass) NOT NULL,
    chars text NOT NULL,
    lemma_id integer
);


--
-- Name: corpora_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE corpora_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: corpora_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE corpora_id_seq OWNED BY c_corpora.id;


--
-- Name: ddo_mappings; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE ddo_mappings (
    id integer NOT NULL,
    ddo_id bigint NOT NULL,
    word_sense_id bigint NOT NULL
);


--
-- Name: dn_ddo_mappings_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE dn_ddo_mappings_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: dn_ddo_mappings_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE dn_ddo_mappings_id_seq OWNED BY ddo_mappings.id;


--
-- Name: feature_types; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE feature_types (
    id integer NOT NULL,
    name text NOT NULL
);


--
-- Name: dn_feature_types_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE dn_feature_types_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: dn_feature_types_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE dn_feature_types_id_seq OWNED BY feature_types.id;


--
-- Name: features; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE features (
    id integer NOT NULL,
    syn_set_id bigint NOT NULL,
    feature_type_id integer NOT NULL
);


--
-- Name: dn_features_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE dn_features_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: dn_features_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE dn_features_id_seq OWNED BY features.id;


--
-- Name: pos_tags; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE pos_tags (
    id integer NOT NULL,
    name text NOT NULL
);


--
-- Name: dn_pos_tags_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE dn_pos_tags_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: dn_pos_tags_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE dn_pos_tags_id_seq OWNED BY pos_tags.id;


--
-- Name: relation_types; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE relation_types (
    id integer NOT NULL,
    name text NOT NULL,
    word_net_name text NOT NULL,
    reverse_id integer
);


--
-- Name: dn_relation_types_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE dn_relation_types_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: dn_relation_types_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE dn_relation_types_id_seq OWNED BY relation_types.id;


--
-- Name: relations; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE relations (
    id integer NOT NULL,
    relation_type_id integer NOT NULL,
    target_word_net_id text,
    syn_set_id bigint NOT NULL,
    taxonomic boolean,
    inheritance_comment text,
    target_syn_set_id bigint,
    CONSTRAINT word_net_or_syn_set CHECK ((((target_word_net_id IS NULL) OR (target_syn_set_id IS NULL)) AND (NOT ((target_word_net_id IS NULL) AND (target_syn_set_id IS NULL)))))
);


--
-- Name: dn_relations_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE dn_relations_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: dn_relations_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE dn_relations_id_seq OWNED BY relations.id;


--
-- Name: word_senses; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE word_senses (
    id integer NOT NULL,
    word_id bigint NOT NULL,
    syn_set_id bigint NOT NULL,
    register text NOT NULL,
    heading text,
    label_candidate boolean
);


--
-- Name: dn_word_senses_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE dn_word_senses_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: dn_word_senses_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE dn_word_senses_id_seq OWNED BY word_senses.id;


--
-- Name: parole_freqs; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE parole_freqs (
    id integer NOT NULL,
    pos character varying(255),
    lemma character varying(255),
    freq integer
);


--
-- Name: parole_freqs_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE parole_freqs_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: parole_freqs_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE parole_freqs_id_seq OWNED BY parole_freqs.id;


--
-- Name: schema_migrations; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE schema_migrations (
    version character varying(255) NOT NULL
);


--
-- Name: sentences_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE sentences_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: sentences_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE sentences_id_seq OWNED BY c_sentences.id;


--
-- Name: syn_sets; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE syn_sets (
    id bigint NOT NULL,
    label text NOT NULL,
    gloss text,
    usage text,
    hyponym_count integer
);


--
-- Name: word_parts; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE word_parts (
    word_id bigint NOT NULL,
    part_of_word_id bigint NOT NULL
);


--
-- Name: words; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE words (
    id bigint NOT NULL,
    lemma text NOT NULL,
    pos_tag_id integer NOT NULL
);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE alignments ALTER COLUMN id SET DEFAULT nextval('alignments_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE c_corpora ALTER COLUMN id SET DEFAULT nextval('corpora_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE c_korpus2000_sentences ALTER COLUMN id SET DEFAULT nextval('c_korpus2000_sentences_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE c_lemmas ALTER COLUMN id SET DEFAULT nextval('c_lemmas_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE c_picks ALTER COLUMN id SET DEFAULT nextval('c_picks_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE c_pos_tags ALTER COLUMN id SET DEFAULT nextval('c_pos_tag_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE c_sentences ALTER COLUMN id SET DEFAULT nextval('sentences_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ddo_mappings ALTER COLUMN id SET DEFAULT nextval('dn_ddo_mappings_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE feature_types ALTER COLUMN id SET DEFAULT nextval('dn_feature_types_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE features ALTER COLUMN id SET DEFAULT nextval('dn_features_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE parole_freqs ALTER COLUMN id SET DEFAULT nextval('parole_freqs_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE pos_tags ALTER COLUMN id SET DEFAULT nextval('dn_pos_tags_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE relation_types ALTER COLUMN id SET DEFAULT nextval('dn_relation_types_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE relations ALTER COLUMN id SET DEFAULT nextval('dn_relations_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE word_senses ALTER COLUMN id SET DEFAULT nextval('dn_word_senses_id_seq'::regclass);


--
-- Name: alignments_id; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY alignments
    ADD CONSTRAINT alignments_id PRIMARY KEY (id);


--
-- Name: alignments_source_and_key_and_syn_set_id_uniq; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY alignments
    ADD CONSTRAINT alignments_source_and_key_and_syn_set_id_uniq UNIQUE (source, key, syn_set_id);


--
-- Name: c_corpora_id; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY c_corpora
    ADD CONSTRAINT c_corpora_id PRIMARY KEY (id);


--
-- Name: c_korpus2000_sentences_id; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY c_korpus2000_sentences
    ADD CONSTRAINT c_korpus2000_sentences_id PRIMARY KEY (id);


--
-- Name: c_lemma_unigrams_pick_id_and_lemma_id; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY c_lemma_unigrams
    ADD CONSTRAINT c_lemma_unigrams_pick_id_and_lemma_id PRIMARY KEY (pick_id, lemma_id);


--
-- Name: c_lemmas_id; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY c_lemmas
    ADD CONSTRAINT c_lemmas_id PRIMARY KEY (id);


--
-- Name: c_picks_id; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY c_picks
    ADD CONSTRAINT c_picks_id PRIMARY KEY (id);


--
-- Name: c_pos_tag_id; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY c_pos_tags
    ADD CONSTRAINT c_pos_tag_id PRIMARY KEY (id);


--
-- Name: c_sentences_id; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY c_sentences
    ADD CONSTRAINT c_sentences_id PRIMARY KEY (id);


--
-- Name: c_tokens_sentence_id_and_position; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY c_tokens
    ADD CONSTRAINT c_tokens_sentence_id_and_position PRIMARY KEY (sentence_id, "position");


--
-- Name: c_word_forms_id; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY c_word_forms
    ADD CONSTRAINT c_word_forms_id PRIMARY KEY (id);


--
-- Name: dn_ddo_mappings_ddo_id_and_word_sense_id_uniq; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY ddo_mappings
    ADD CONSTRAINT dn_ddo_mappings_ddo_id_and_word_sense_id_uniq UNIQUE (ddo_id, word_sense_id);


--
-- Name: dn_ddo_mappings_id; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY ddo_mappings
    ADD CONSTRAINT dn_ddo_mappings_id PRIMARY KEY (id);


--
-- Name: dn_feature_types_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY feature_types
    ADD CONSTRAINT dn_feature_types_pkey PRIMARY KEY (id);


--
-- Name: dn_features_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY features
    ADD CONSTRAINT dn_features_pkey PRIMARY KEY (id);


--
-- Name: dn_relation_types_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY relation_types
    ADD CONSTRAINT dn_relation_types_pkey PRIMARY KEY (id);


--
-- Name: dn_relations_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY relations
    ADD CONSTRAINT dn_relations_pkey PRIMARY KEY (id);


--
-- Name: dn_synsets_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY syn_sets
    ADD CONSTRAINT dn_synsets_pkey PRIMARY KEY (id);


--
-- Name: dn_word_parts_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY word_parts
    ADD CONSTRAINT dn_word_parts_pkey PRIMARY KEY (word_id, part_of_word_id);


--
-- Name: dn_word_senses_heading_uniq; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY word_senses
    ADD CONSTRAINT dn_word_senses_heading_uniq UNIQUE (heading);


--
-- Name: dn_word_senses_id_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY word_senses
    ADD CONSTRAINT dn_word_senses_id_pkey PRIMARY KEY (id);


--
-- Name: dn_words_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY words
    ADD CONSTRAINT dn_words_pkey PRIMARY KEY (id);


--
-- Name: parole_freqs_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY parole_freqs
    ADD CONSTRAINT parole_freqs_pkey PRIMARY KEY (id);


--
-- Name: pos_tags_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY pos_tags
    ADD CONSTRAINT pos_tags_pkey PRIMARY KEY (id);


--
-- Name: c_lemmas_chars; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX c_lemmas_chars ON c_lemmas USING btree (chars);


--
-- Name: c_tokens_lemma_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX c_tokens_lemma_id ON c_tokens USING btree (lemma_id);


--
-- Name: c_tokens_sentence_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX c_tokens_sentence_id ON c_tokens USING btree (sentence_id);


--
-- Name: c_tokens_word_form_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX c_tokens_word_form_id ON c_tokens USING btree (word_form_id);


--
-- Name: c_word_forms_chars_and_lemma_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX c_word_forms_chars_and_lemma_id ON c_word_forms USING btree (chars, lemma_id);


--
-- Name: c_word_forms_lemma_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX c_word_forms_lemma_id ON c_word_forms USING btree (lemma_id);


--
-- Name: dn_feature_types_id_key; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX dn_feature_types_id_key ON feature_types USING btree (id);


--
-- Name: dn_features_syn_set_id_key; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX dn_features_syn_set_id_key ON features USING btree (syn_set_id);


--
-- Name: dn_pos_tags_id_key; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX dn_pos_tags_id_key ON pos_tags USING btree (id);


--
-- Name: dn_relation_types_id_key; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX dn_relation_types_id_key ON relation_types USING btree (id);


--
-- Name: dn_relation_types_reverse_id_key; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX dn_relation_types_reverse_id_key ON relation_types USING btree (reverse_id);


--
-- Name: dn_relations_syn_set_id_and_relation_type_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX dn_relations_syn_set_id_and_relation_type_id ON relations USING btree (syn_set_id, relation_type_id);


--
-- Name: dn_syn_sets_id_key; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX dn_syn_sets_id_key ON syn_sets USING btree (id);


--
-- Name: dn_word_senses_syn_set_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX dn_word_senses_syn_set_id ON word_senses USING btree (syn_set_id);


--
-- Name: dn_word_senses_word_id_key; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX dn_word_senses_word_id_key ON word_senses USING btree (word_id);


--
-- Name: dn_words_id_key; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX dn_words_id_key ON words USING btree (id);


--
-- Name: dn_words_lemma_key; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX dn_words_lemma_key ON words USING btree (lemma text_pattern_ops);


--
-- Name: unique_schema_migrations; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX unique_schema_migrations ON schema_migrations USING btree (version);


--
-- Name: aligments_synset_id; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY alignments
    ADD CONSTRAINT aligments_synset_id FOREIGN KEY (syn_set_id) REFERENCES syn_sets(id);


--
-- Name: c_korpus2000_sentences_sentence_id; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY c_korpus2000_sentences
    ADD CONSTRAINT c_korpus2000_sentences_sentence_id FOREIGN KEY (sentence_id) REFERENCES c_sentences(id);


--
-- Name: c_lemma_unigrams_lemma_id; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY c_lemma_unigrams
    ADD CONSTRAINT c_lemma_unigrams_lemma_id FOREIGN KEY (lemma_id) REFERENCES c_lemmas(id);


--
-- Name: c_lemma_unigrams_pick_id; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY c_lemma_unigrams
    ADD CONSTRAINT c_lemma_unigrams_pick_id FOREIGN KEY (pick_id) REFERENCES c_picks(id);


--
-- Name: c_sentences_corpus_id; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY c_sentences
    ADD CONSTRAINT c_sentences_corpus_id FOREIGN KEY (corpus_id) REFERENCES c_corpora(id);


--
-- Name: c_tokens_lemma_id; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY c_tokens
    ADD CONSTRAINT c_tokens_lemma_id FOREIGN KEY (lemma_id) REFERENCES c_lemmas(id);


--
-- Name: c_tokens_sentence_id; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY c_tokens
    ADD CONSTRAINT c_tokens_sentence_id FOREIGN KEY (sentence_id) REFERENCES c_sentences(id);


--
-- Name: c_tokens_word_form_id; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY c_tokens
    ADD CONSTRAINT c_tokens_word_form_id FOREIGN KEY (word_form_id) REFERENCES c_word_forms(id);


--
-- Name: c_word_forms_lemma_id; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY c_word_forms
    ADD CONSTRAINT c_word_forms_lemma_id FOREIGN KEY (lemma_id) REFERENCES c_lemmas(id);


--
-- Name: d_word_senses_syn_set_id; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY word_senses
    ADD CONSTRAINT d_word_senses_syn_set_id FOREIGN KEY (syn_set_id) REFERENCES syn_sets(id);


--
-- Name: dn_ddo_mappings_word_sense_id; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY ddo_mappings
    ADD CONSTRAINT dn_ddo_mappings_word_sense_id FOREIGN KEY (word_sense_id) REFERENCES word_senses(id);


--
-- Name: dn_features_feature_type_id; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY features
    ADD CONSTRAINT dn_features_feature_type_id FOREIGN KEY (feature_type_id) REFERENCES feature_types(id);


--
-- Name: dn_features_syn_set_id; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY features
    ADD CONSTRAINT dn_features_syn_set_id FOREIGN KEY (syn_set_id) REFERENCES syn_sets(id);


--
-- Name: dn_relation_types_reverse_id; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY relation_types
    ADD CONSTRAINT dn_relation_types_reverse_id FOREIGN KEY (reverse_id) REFERENCES relation_types(reverse_id);


--
-- Name: dn_relations_relation_type_id; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY relations
    ADD CONSTRAINT dn_relations_relation_type_id FOREIGN KEY (relation_type_id) REFERENCES relation_types(id);


--
-- Name: dn_relations_syn_set_id; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY relations
    ADD CONSTRAINT dn_relations_syn_set_id FOREIGN KEY (syn_set_id) REFERENCES syn_sets(id);


--
-- Name: dn_relations_target_syn_set_id; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY relations
    ADD CONSTRAINT dn_relations_target_syn_set_id FOREIGN KEY (target_syn_set_id) REFERENCES syn_sets(id);


--
-- Name: dn_word_parts_part_of_word_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY word_parts
    ADD CONSTRAINT dn_word_parts_part_of_word_id_fkey FOREIGN KEY (part_of_word_id) REFERENCES words(id);


--
-- Name: dn_word_parts_word_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY word_parts
    ADD CONSTRAINT dn_word_parts_word_id_fkey FOREIGN KEY (word_id) REFERENCES words(id);


--
-- Name: dn_word_senses_word_id; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY word_senses
    ADD CONSTRAINT dn_word_senses_word_id FOREIGN KEY (word_id) REFERENCES words(id);


--
-- Name: dn_words_pos_tag_id; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY words
    ADD CONSTRAINT dn_words_pos_tag_id FOREIGN KEY (pos_tag_id) REFERENCES pos_tags(id);


--
-- PostgreSQL database dump complete
--

