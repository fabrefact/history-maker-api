SET check_function_bodies = false;
CREATE EXTENSION IF NOT EXISTS pgcrypto WITH SCHEMA public;
COMMENT ON EXTENSION pgcrypto IS 'cryptographic functions';
CREATE TABLE public.event_tags (
    event_id uuid NOT NULL,
    tag_id uuid NOT NULL
);
COMMENT ON TABLE public.event_tags IS 'Tags for events';
CREATE TABLE public.events (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    name text NOT NULL,
    start_time timestamp with time zone NOT NULL,
    end_time timestamp with time zone NOT NULL,
    estimated_time boolean DEFAULT false NOT NULL,
    canonical boolean DEFAULT false NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    created_by text NOT NULL
);
COMMENT ON TABLE public.events IS 'Events in the history you''d like to track';
CREATE TABLE public.media (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    source_link text,
    media_link text NOT NULL,
    archive_link text,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    created_by text NOT NULL,
    thumbnail_link text,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    created_event uuid,
    published_event uuid,
    source uuid
);
COMMENT ON TABLE public.media IS 'Audiovisual media associated with events';
CREATE TABLE public.media_tags (
    media_id uuid NOT NULL,
    tag_id uuid NOT NULL
);
COMMENT ON TABLE public.media_tags IS 'Tags for media files';
CREATE TABLE public.sources (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    name text NOT NULL,
    description text,
    link text
);
COMMENT ON TABLE public.sources IS 'Sources of media and historical information';
CREATE TABLE public.tags (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    name text NOT NULL,
    canonical boolean DEFAULT true NOT NULL,
    language text DEFAULT 'en'::text NOT NULL
);
COMMENT ON TABLE public.tags IS 'Tags for events and media';
ALTER TABLE ONLY public.event_tags
    ADD CONSTRAINT event_tags_pkey PRIMARY KEY (event_id, tag_id);
ALTER TABLE ONLY public.events
    ADD CONSTRAINT events_pkey PRIMARY KEY (id);
ALTER TABLE ONLY public.media
    ADD CONSTRAINT media_pkey PRIMARY KEY (id);
ALTER TABLE ONLY public.media_tags
    ADD CONSTRAINT media_tags_pkey PRIMARY KEY (media_id, tag_id);
ALTER TABLE ONLY public.sources
    ADD CONSTRAINT sources_pkey PRIMARY KEY (id);
ALTER TABLE ONLY public.tags
    ADD CONSTRAINT tags_pkey PRIMARY KEY (id);
ALTER TABLE ONLY public.event_tags
    ADD CONSTRAINT event_tags_event_id_fkey FOREIGN KEY (event_id) REFERENCES public.events(id) ON UPDATE CASCADE ON DELETE CASCADE;
ALTER TABLE ONLY public.event_tags
    ADD CONSTRAINT event_tags_tag_id_fkey FOREIGN KEY (tag_id) REFERENCES public.tags(id) ON UPDATE CASCADE ON DELETE CASCADE;
ALTER TABLE ONLY public.media
    ADD CONSTRAINT media_created_event_fkey FOREIGN KEY (created_event) REFERENCES public.events(id) ON UPDATE SET NULL ON DELETE SET NULL;
ALTER TABLE ONLY public.media
    ADD CONSTRAINT media_published_event_fkey FOREIGN KEY (published_event) REFERENCES public.events(id) ON UPDATE SET NULL ON DELETE SET NULL;
ALTER TABLE ONLY public.media
    ADD CONSTRAINT media_source_fkey FOREIGN KEY (source) REFERENCES public.sources(id) ON UPDATE RESTRICT ON DELETE SET NULL;
ALTER TABLE ONLY public.media_tags
    ADD CONSTRAINT media_tags_media_id_fkey FOREIGN KEY (media_id) REFERENCES public.media(id) ON UPDATE CASCADE ON DELETE CASCADE;
ALTER TABLE ONLY public.media_tags
    ADD CONSTRAINT media_tags_tag_id_fkey FOREIGN KEY (tag_id) REFERENCES public.tags(id) ON UPDATE CASCADE ON DELETE CASCADE;
