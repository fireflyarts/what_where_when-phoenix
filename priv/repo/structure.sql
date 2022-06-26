--
-- PostgreSQL database dump
--

-- Dumped from database version 12.11 (Ubuntu 12.11-0ubuntu0.20.04.1)
-- Dumped by pg_dump version 13.7

-- Started on 2022-06-25 16:53:24 EDT

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET xmloption = content;
SET client_min_messages = warning;
SET row_security = off;

--
-- TOC entry 2 (class 3079 OID 5820623)
-- Name: citext; Type: EXTENSION; Schema: -; Owner: -
--

CREATE EXTENSION IF NOT EXISTS citext WITH SCHEMA public;


--
-- TOC entry 3109 (class 0 OID 0)
-- Dependencies: 2
-- Name: EXTENSION citext; Type: COMMENT; Schema: -; Owner: -
--

COMMENT ON EXTENSION citext IS 'data type for case-insensitive character strings';


SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- TOC entry 213 (class 1259 OID 5820790)
-- Name: camps; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.camps (
    id bigint NOT NULL,
    emoji character varying(255),
    name character varying(255) NOT NULL,
    primary_contact_id bigint NOT NULL,
    location_id bigint
);


--
-- TOC entry 212 (class 1259 OID 5820788)
-- Name: camps_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.camps_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- TOC entry 3110 (class 0 OID 0)
-- Dependencies: 212
-- Name: camps_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.camps_id_seq OWNED BY public.camps.id;


--
-- TOC entry 205 (class 1259 OID 5820736)
-- Name: event_categories; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.event_categories (
    id bigint NOT NULL,
    name character varying(255) NOT NULL,
    emoji character varying(255) NOT NULL,
    minimum_age integer DEFAULT 0
);


--
-- TOC entry 204 (class 1259 OID 5820734)
-- Name: event_categories_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.event_categories_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- TOC entry 3111 (class 0 OID 0)
-- Dependencies: 204
-- Name: event_categories_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.event_categories_id_seq OWNED BY public.event_categories.id;


--
-- TOC entry 215 (class 1259 OID 5820812)
-- Name: events; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.events (
    id bigint NOT NULL,
    name character varying(255) NOT NULL,
    description text NOT NULL,
    start_date date NOT NULL,
    start_time timestamp(0) without time zone,
    category_id bigint,
    minimum_age integer DEFAULT 0,
    owning_person_id bigint,
    owning_camp_id bigint,
    location_id bigint NOT NULL,
    sober_friendly integer NOT NULL,
    inserted_at timestamp(0) without time zone NOT NULL,
    updated_at timestamp(0) without time zone NOT NULL
);


--
-- TOC entry 214 (class 1259 OID 5820810)
-- Name: events_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.events_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- TOC entry 3112 (class 0 OID 0)
-- Dependencies: 214
-- Name: events_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.events_id_seq OWNED BY public.events.id;


--
-- TOC entry 211 (class 1259 OID 5820779)
-- Name: locations; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.locations (
    id bigint NOT NULL,
    type integer,
    lat numeric,
    lng numeric
);


--
-- TOC entry 210 (class 1259 OID 5820777)
-- Name: locations_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.locations_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- TOC entry 3113 (class 0 OID 0)
-- Dependencies: 210
-- Name: locations_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.locations_id_seq OWNED BY public.locations.id;


--
-- TOC entry 207 (class 1259 OID 5820749)
-- Name: people; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.people (
    id bigint NOT NULL,
    id_name character varying(255) NOT NULL,
    burn_name character varying(255),
    email character varying(255) NOT NULL,
    hashed_password character varying(255),
    confirmed_at timestamp(0) without time zone,
    inserted_at timestamp(0) without time zone NOT NULL,
    updated_at timestamp(0) without time zone NOT NULL,
    camp_id bigint
);


--
-- TOC entry 206 (class 1259 OID 5820747)
-- Name: people_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.people_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- TOC entry 3114 (class 0 OID 0)
-- Dependencies: 206
-- Name: people_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.people_id_seq OWNED BY public.people.id;


--
-- TOC entry 209 (class 1259 OID 5820761)
-- Name: people_tokens; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.people_tokens (
    id bigint NOT NULL,
    person_id bigint NOT NULL,
    token bytea NOT NULL,
    context character varying(255) NOT NULL,
    sent_to character varying(255),
    inserted_at timestamp(0) without time zone NOT NULL
);


--
-- TOC entry 208 (class 1259 OID 5820759)
-- Name: people_tokens_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.people_tokens_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- TOC entry 3115 (class 0 OID 0)
-- Dependencies: 208
-- Name: people_tokens_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.people_tokens_id_seq OWNED BY public.people_tokens.id;


--
-- TOC entry 203 (class 1259 OID 5820729)
-- Name: schema_migrations; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.schema_migrations (
    version bigint NOT NULL,
    inserted_at timestamp(0) without time zone
);


--
-- TOC entry 2932 (class 2604 OID 5820793)
-- Name: camps id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.camps ALTER COLUMN id SET DEFAULT nextval('public.camps_id_seq'::regclass);


--
-- TOC entry 2927 (class 2604 OID 5820739)
-- Name: event_categories id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.event_categories ALTER COLUMN id SET DEFAULT nextval('public.event_categories_id_seq'::regclass);


--
-- TOC entry 2933 (class 2604 OID 5820815)
-- Name: events id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.events ALTER COLUMN id SET DEFAULT nextval('public.events_id_seq'::regclass);


--
-- TOC entry 2931 (class 2604 OID 5820782)
-- Name: locations id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.locations ALTER COLUMN id SET DEFAULT nextval('public.locations_id_seq'::regclass);


--
-- TOC entry 2929 (class 2604 OID 5820752)
-- Name: people id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.people ALTER COLUMN id SET DEFAULT nextval('public.people_id_seq'::regclass);


--
-- TOC entry 2930 (class 2604 OID 5820764)
-- Name: people_tokens id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.people_tokens ALTER COLUMN id SET DEFAULT nextval('public.people_tokens_id_seq'::regclass);


--
-- TOC entry 3101 (class 0 OID 5820790)
-- Dependencies: 213
-- Data for Name: camps; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.camps (id, emoji, name, primary_contact_id, location_id) FROM stdin;
1	\N	Astral Chill	38	\N
2	\N	BONK	29	\N
3	\N	BSC	54	\N
4	\N	BUBBLE TROUBLE	17	\N
5	\N	Blue Screen of Death	61	\N
6	\N	Bring A Cup	70	\N
7	\N	Cabana Hammock	49	\N
8	\N	Camp Campy Camp	63	\N
9	\N	Camp Don't Fuck Up	26	\N
10	\N	Camp Fire Camp	21	\N
11	\N	Camp Here	72	\N
12	\N	Camp Kisszzo presents: Mutualade	45	\N
13	\N	Camp Kwitcherbitchen	15	\N
14	\N	Camp Love and Lions Den	3	\N
15	\N	Camp Murder Pony	5	\N
16	\N	Camp Stop Hitting Yourself (formerly fdc)	57	\N
17	\N	Diode	32	\N
18	\N	Dryer Camp	16	\N
19	\N	Electric Kool-Aid Revision Quest	62	\N
20	\N	F-Art ( Top Hat Poofer +Phoenix +Kaleidoscope)es	20	\N
21	\N	Fan Camp	4	\N
22	\N	Fern Gully	9	\N
23	\N	Fluffer Camp: Fluff your 20-tutu!	28	\N
24	\N	Ginnungagap	37	\N
25	\N	GraVT	59	\N
26	\N	Hall of Arkham	40	\N
27	\N	Homeless Shelter	8	\N
28	\N	Howl	68	\N
29	\N	Immediacy Camp	48	\N
30	\N	Kids Korner	35	\N
31	\N	LIttle Winter Hill	13	\N
32	\N	Library Camp	50	\N
33	\N	Live Free and Burn	36	\N
34	\N	Meat Camp	1	\N
35	\N	Milk & Cookies	43	\N
36	\N	Null	12	\N
37	\N	Office Depot	34	\N
38	\N	Old dude camp.	58	\N
39	\N	Potato Support People	64	\N
40	\N	Rainbow Dinos	27	\N
41	\N	Secret Goth Club	22	\N
42	\N	Sensual Sensory Experience	23	\N
43	\N	Suds & Spuds	25	\N
44	\N	The Universe	33	\N
45	\N	The Waiting Room (fka The Gojo)	24	\N
46	\N	The Weird Cookie	18	\N
47	\N	Wytch's Kitchyn	60	\N
48	\N	Zoo Camp	44	\N
\.


--
-- TOC entry 3094 (class 0 OID 5820736)
-- Dependencies: 205
-- Data for Name: event_categories; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.event_categories (id, name, emoji, minimum_age) FROM stdin;
1	Watch!	:performing_arts:	0
2	Learn!	:teacher:	0
3	Eat!	:stew:	0
4	Drink!	:teapot:	0
5	Play! (games)	:game_die:	0
6	Play! (sports)	:badminton:	0
7	Learn!	:shocked:	18
8	Play!	:flirty:	18
9	Drink!	:tropical_drink:	21
\.


--
-- TOC entry 3103 (class 0 OID 5820812)
-- Dependencies: 215
-- Data for Name: events; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.events (id, name, description, start_date, start_time, category_id, minimum_age, owning_person_id, owning_camp_id, location_id, sober_friendly, inserted_at, updated_at) FROM stdin;
1	Reverse Proxies 101	Ever wonder how to re-route traffic on the internet?  No?  Well, then don't come to this.	2022-06-30	2022-06-30 14:00:00	2	0	74	\N	2	1	2022-06-24 19:52:59	2022-06-24 19:52:59
2	The Miracle Berry Experience	Get ready to take your taste buds for a ride! Try familiar foods and drinks in a new way: Miracle Berries temporarily turn sour into sweet! Consumer beware: citrus and other potential allergens will be present at this event.\r\n\r\nPro tip: Brush your tongue well before arriving for the best experience.	2022-06-30	2022-06-30 17:00:00	3	0	79	\N	3	2	2022-06-24 21:35:06	2022-06-24 21:35:06
3	Safety Volunteer Thank You Ceremony 	A ceremony to honor safety volunteers; next to Sanctuary	2022-07-03	2022-07-03 12:00:00	2	0	34	\N	4	2	2022-06-25 01:23:00	2022-06-25 01:26:28
4	Get wicked awesome at Rope Dahht  at Camp Lamp	Come to Camp Lamp to learn basics of rope dart. If you're more advanced I can teach  you how to link techniques together to build combos to make you look wicked awesome to your friends !!  Some extra rope darts will be available.	2022-07-02	2022-07-02 14:00:00	2	0	93	\N	5	2	2022-06-25 02:32:49	2022-06-25 02:32:49
5	FZP Insectarium Open Hours	Stop by Zoo Camp any time from 10pm-2am to see what's currently visiting our Insectarium! Don't forget your headlamp, a sense of curiosity, and an open mind: we don't know what, if anything, will be lured by the UV lights! Fact sheets will be present to get your learn on. (For a more guided visit, join Zookeeper Bug on Thursday at the Big Bug at 10pm!)	2022-06-29	2022-06-29 22:00:00	2	0	96	\N	6	2	2022-06-25 03:14:54	2022-06-25 03:14:54
6	FZP Insectarium Open Hours	Stop by Zoo Camp to see what's currently visiting our Insectarium from 10pm to 2am! Don't forget your headlamp, a sense of curiosity, and an open mind: we don't know what, if anything, will be lured by the UV lights! Fact sheets will be present to get your learn on. 	2022-07-01	2022-07-01 10:00:00	2	0	96	\N	7	2	2022-06-25 03:16:31	2022-06-25 03:16:31
7	FZP Creature Feature: They Love Lamps	Join Zookeeper Bug to examine what's been lured by our UV lights. They'll talk about what kind of moths and other night-flying insects you can find at Firefly, and what's out during the day too. Bring a headlamp to best peep the fuzz! If no one is visiting, we can sit around and geek out about arthropods anyway.	2022-06-30	2022-06-30 22:00:00	2	0	96	\N	8	2	2022-06-25 03:18:11	2022-06-25 03:18:11
8	Reptile House Party 	Immerse yourself in the humid, low-lit world of the reptile house, and join the lizards, snakes, and turtles as they groove to the slithering beats of DJ Huxley's house mix. Hosted by our friends at Howl!	2022-07-01	2022-07-01 20:00:00	1	21	96	\N	9	1	2022-06-25 03:35:48	2022-06-25 03:35:48
9	Firefly Zoological Park Face Painting and Happy Hour!	It's time for you to bring your crew for a paint tattoo of a blue baboon while you sip on a brew and then chew human food in the soft petting pool here at Firefly Zoo. Free admission on Thursdays.	2022-06-30	2022-06-30 17:00:00	4	0	96	\N	10	1	2022-06-25 03:45:33	2022-06-25 03:45:33
10	Happy Hour @ Bite Bar	At Bite Bar, our experienced Bite Tenders are delighted to bring you our thoughtful selection of al dente experiences from little nibbles to a hardy chomp. Come get a bite!	2022-06-30	2022-06-30 17:00:00	4	18	99	\N	11	2	2022-06-25 04:10:53	2022-06-25 04:10:53
11	Happy Hour @ Bite Bar	At Bite Bar, our experienced Bite Tenders are delighted to bring you our thoughtful selection of al dente experiences from little nibbles to a hardy chomp. Come get a bite!\r\n\r\nBite Bar will be a Howl (old Totenkitten spot) 	2022-07-03	2022-07-03 18:00:00	1	18	99	\N	12	2	2022-06-25 04:17:16	2022-06-25 04:17:16
12	Fantastic Fans and How to Spin Them	Want to learn how to do more with your fans than just snake arms?  Come to Camp Lamp to learn the basic foundation of tech fan spinning.  Moves we’ll likely to highlight include weaves, reels, windmills, buzzsaws, stacking, folds, reverse grip, extensions, barrel rolls and more.	2022-07-02	2022-07-02 13:00:00	2	14	105	\N	13	2	2022-06-25 16:14:49	2022-06-25 16:14:49
13	Punch Drunk	Your camp is looking in good shape! Come by and drink Sangria at Camp Lamp!	2022-06-29	2022-06-29 21:00:00	9	21	105	\N	14	0	2022-06-25 16:16:24	2022-06-25 16:16:24
14	Minty Fresh Thursday	Minty fresh alcoholic beverages to keep you cool at Camp Lamp.  Come by, drink and enjoy Powerpoint Club!	2022-06-30	2022-06-30 21:00:00	9	21	105	\N	15	0	2022-06-25 16:20:20	2022-06-25 16:20:20
15	Ginful Fridays	Feeling Sinful?  Thirsty for a pleasure filled experience?  Come taste what Lamp has to offer.	2022-07-01	2022-07-01 21:00:00	4	21	105	\N	16	0	2022-06-25 16:21:51	2022-06-25 16:21:51
16	Bourbon Burn Night	Come drink whiskey and watch the fire performers! BURN ALL THE THINGS!	2022-07-02	2022-07-02 23:00:00	9	21	105	\N	17	0	2022-06-25 16:23:05	2022-06-25 16:23:05
17	Slunchy Sunday	What is Slunch? Come find out with CAMP LAMP! (hint: it's tasty)	2022-07-03	2022-07-03 22:00:00	9	21	105	\N	18	0	2022-06-25 16:24:00	2022-06-25 16:24:00
18	Disability Happy Hour	For all fireflies! This a chance for folks who feel comfortable sharing talk about their disability and how it impacts their day to day and share how we can make firefly a better experience for them, if they want any help at all. From there an open forum to help remove some of the stigma and help folks be heard as individuals but also for folks who don't have the same experiences get a chance to better understand how that person experiences the world. 	2022-06-30	2022-06-30 15:00:00	2	0	107	\N	19	2	2022-06-25 16:34:17	2022-06-25 16:34:17
19	Fire Spinning Throwdown	From 11 PM until Sunrise Camp Lamp will be hosting it's annual Fire Spinning and Ravey Bass Music throwdown.  Bring all your props! Show off all your skills! Get down to the sickest Bass Music you will hear all week!\r\n	2022-07-02	2022-07-02 23:00:00	8	18	105	\N	20	1	2022-06-25 17:56:11	2022-06-25 17:56:11
20	Glitch Night	How can one building impact so many people in this community?  How can one space foster such long lasting friendships?\r\nFriday night at Camp Lamp  we will be celebrating all things Glitch loft at Firefly Arts Collective.\r\nFeaturing music from: Encanti, Gently Brother (Jeff Mission and Swhilly B), Vinyl Blight, Dontnormally, Nora Jean, K Complex and more.\r\nVJing: Lumendrop and more glitch guests.\r\nI'd like to dedicate this night to Matty who passed away this weekend and touched many of our lives.  This will be the first time many of us will be at the same space for years (even before the pandemic) and I would like to set aside this night to celebrate this community together in the woods.	2022-07-01	2022-07-01 21:00:00	8	18	105	\N	21	1	2022-06-25 17:58:43	2022-06-25 17:58:43
21	The Radical Audio Visual Experience  	You don't need a map point.  You'll hear the sound of our Untz throughout the forest.  The real question is will you be there?  Tonight, Lamp goes full RAVE mode.  Join us for the infamous Fire spinning throwdown, enjoy bourbon cocktails and get down to some amazing tunes.  Enjoy Encanti and K Komplex 2 hour divorcee tag set.  Also features Oleg, Dip, Mx Blair, Omega Protocol, and a two-hour sunrise set by Psylander. 	2022-07-02	2022-07-02 23:00:00	8	18	105	\N	22	0	2022-06-25 18:05:29	2022-06-25 18:05:29
22	Release (A Post Temple Burn Celebration)	It is time to set free and let go. It’s been a hell of a fucking three years. We’ve all experienced forms of loss or grief.  It’s been a long time since we’ve felt the joy that we use to.  Let us remember what brought us here.  Community.  Friendship.  Creative Expression.  We welcome you to Camp Lamp as we celebrate a year reunited again.  Let us rejoice one last time before we say our goodbyes.\r\nMusic by: Earth Hariss, Keith Mattar, Gary Carlow (Sunrise set), Dave Sainai, Left Cat and more.	2022-07-03	2022-07-03 22:00:00	8	18	105	\N	23	1	2022-06-25 18:31:02	2022-06-25 18:31:02
\.


--
-- TOC entry 3099 (class 0 OID 5820779)
-- Dependencies: 211
-- Data for Name: locations; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.locations (id, type, lat, lng) FROM stdin;
1	3	1028.5330622016834	972.9789309126893
2	2	2642.100117724646	1394.4145724998716
3	2	3002.0348663540067	1543.8624597854582
4	2	1688.4676293510927	1124.6868717884688
5	2	2954.8925201392954	1512.6973525272313
6	2	3479.981082047201	1766.3527394039959
7	2	3540.285473185547	1774.4440794641207
8	2	1121.7440921387606	981.464212286928
9	2	3243.5432135173755	1049.3464632808366
10	2	3479.9622160853905	1782.4063732836735
11	2	1000.0518273238088	984.2926394116743
12	2	3065.2189569038455	1018.2337649086285
13	2	2963.722560860733	1535.8359287371813
14	2	2935.5425264739984	1456.639969244288
15	2	2997.706607417987	1535.8359287371813
16	2	2941.374130754711	1541.4927829866738
17	2	2975.1006509501667	1552.8064914856584
18	2	2963.9432977422734	1547.1496372361662
19	2	2682.2068264593913	916.8817641663081
20	2	2992.0650821186014	1564.1201999846432
21	2	2975.011743039546	1569.7770542341357
22	2	2997.651423197601	1541.4927829866738
23	2	2929.9101985446773	1569.7770542341357
\.


--
-- TOC entry 3096 (class 0 OID 5820749)
-- Dependencies: 207
-- Data for Name: people; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.people (id, id_name, burn_name, email, hashed_password, confirmed_at, inserted_at, updated_at, camp_id) FROM stdin;
1	Aaron Kaufman	\N	aaronkaufman@nyu.edu	\N	\N	2022-06-24 04:37:26	2022-06-24 04:37:26	\N
2	Abby Howell	\N	abby.g.howell@gmail.com	\N	\N	2022-06-24 04:37:26	2022-06-24 04:37:26	\N
3	Adam Blake	\N	thelionscollective@gmail.com	\N	\N	2022-06-24 04:37:26	2022-06-24 04:37:26	\N
4	Adam Kraft	\N	adam@robot.army	\N	\N	2022-06-24 04:37:26	2022-06-24 04:37:26	\N
5	Ange Sarno	\N	ange.sarno@gmail.com	\N	\N	2022-06-24 04:37:26	2022-06-24 04:37:26	\N
6	Bethany Walker	\N	bethany.walker@gmail.com	\N	\N	2022-06-24 04:37:26	2022-06-24 04:37:26	\N
7	Brian Neltner	\N	brian@brianneltner.com	\N	\N	2022-06-24 04:37:26	2022-06-24 04:37:26	\N
8	Bruce Knowlton	\N	bknowlton@piperledge.com	\N	\N	2022-06-24 04:37:26	2022-06-24 04:37:26	\N
9	Carl Gruesz	\N	starphire66@gmail.com	\N	\N	2022-06-24 04:37:26	2022-06-24 04:37:26	\N
10	Carly Nix	\N	nix.carly@gmail.com	\N	\N	2022-06-24 04:37:26	2022-06-24 04:37:26	\N
12	Clinton Burgos	\N	clinton.burgos@gmail.com	\N	\N	2022-06-24 04:37:26	2022-06-24 04:37:26	\N
13	Dan Snyder	\N	dan@fireflyartscollective.org	\N	\N	2022-06-24 04:37:26	2022-06-24 04:37:26	\N
14	Danner Claflin	\N	dannerclaflin@gmail.com	\N	\N	2022-06-24 04:37:26	2022-06-24 04:37:26	\N
15	David Wilson	\N	loganprime@gmail.com	\N	\N	2022-06-24 04:37:26	2022-06-24 04:37:26	\N
16	Dryer Camp	\N	dnnhgn@gmail.com	\N	\N	2022-06-24 04:37:26	2022-06-24 04:37:26	\N
17	Elizabeth Viatkin	\N	elizabeth.viatkin@gmail.com	\N	\N	2022-06-24 04:37:26	2022-06-24 04:37:26	\N
18	Emma O'Brien	\N	emmaobrien@gmail.com	\N	\N	2022-06-24 04:37:26	2022-06-24 04:37:26	\N
19	Eugene Zeleny	\N	eugenezeleny@gmail.com	\N	\N	2022-06-24 04:37:26	2022-06-24 04:37:26	\N
20	Gesa Lehnert	\N	gesa.lehnert@gmail.com	\N	\N	2022-06-24 04:37:26	2022-06-24 04:37:26	\N
21	Holland Graham	\N	holland.k.graham@gmail.com	\N	\N	2022-06-24 04:37:26	2022-06-24 04:37:26	\N
22	Ian McMullen	\N	imcm617@gmail.com	\N	\N	2022-06-24 04:37:26	2022-06-24 04:37:26	\N
23	Ivy Friedman	\N	glitterbug814@gmail.com	\N	\N	2022-06-24 04:37:26	2022-06-24 04:37:26	\N
24	Jackson Okuhn	\N	jpokuhn@gmail.com	\N	\N	2022-06-24 04:37:26	2022-06-24 04:37:26	\N
25	Jacqueline Gallagher	\N	jacqgallagher@gmail.com	\N	\N	2022-06-24 04:37:26	2022-06-24 04:37:26	\N
26	Jade Dahmer	\N	avidwanderlust@gmail.com	\N	\N	2022-06-24 04:37:26	2022-06-24 04:37:26	\N
27	Jeffrey Radcliffe	\N	tinctoris@mac.com	\N	\N	2022-06-24 04:37:26	2022-06-24 04:37:26	\N
28	Jenn Zawadzkas	\N	pensivepixi@gmail.com	\N	\N	2022-06-24 04:37:26	2022-06-24 04:37:26	\N
29	Jess Plassmann	\N	bloodybrook@gmail.com	\N	\N	2022-06-24 04:37:26	2022-06-24 04:37:26	\N
30	Jessica Polka	\N	jessica.polka@gmail.com	\N	\N	2022-06-24 04:37:26	2022-06-24 04:37:26	\N
31	Joe Scherrer	\N	joebob@mit.edu	\N	\N	2022-06-24 04:37:26	2022-06-24 04:37:26	\N
32	Johnatha West	\N	johnathan.west@gmail.com	\N	\N	2022-06-24 04:37:26	2022-06-24 04:37:26	\N
33	Jon Evans	\N	jon@craftyjon.com	\N	\N	2022-06-24 04:37:26	2022-06-24 04:37:26	\N
35	Kat Dobbins	\N	kat.dobbins@gmail.com	\N	\N	2022-06-24 04:37:26	2022-06-24 04:37:26	\N
36	Ken Mitchell	\N	ken.mitchell@burningman.org	\N	\N	2022-06-24 04:37:26	2022-06-24 04:37:26	\N
37	Kevin McKayven	\N	glyphgryph@gmail.com	\N	\N	2022-06-24 04:37:26	2022-06-24 04:37:26	\N
38	Kris Thompson	\N	oztofer@yahoo.com	\N	\N	2022-06-24 04:37:26	2022-06-24 04:37:26	\N
40	Loki Lumerian	\N	lokilumerian@gmail.com	\N	\N	2022-06-24 04:37:26	2022-06-24 04:37:26	\N
41	Lynn Knowlton	\N	lknowlton@piperledge.com	\N	\N	2022-06-24 04:37:26	2022-06-24 04:37:26	\N
42	Mali Wilson	\N	mals13@hotmail.com	\N	\N	2022-06-24 04:37:26	2022-06-24 04:37:26	\N
43	Matthew Cashman	\N	milkandcookies@mcashman.org	\N	\N	2022-06-24 04:37:26	2022-06-24 04:37:26	\N
44	Meg Weireter	\N	megweireter@gmail.com	\N	\N	2022-06-24 04:37:26	2022-06-24 04:37:26	\N
45	Mike Kissinger	\N	mis4mike@gmail.com	\N	\N	2022-06-24 04:37:26	2022-06-24 04:37:26	\N
46	Missy Farmer	\N	missy@fireflyartscollective.org	\N	\N	2022-06-24 04:37:26	2022-06-24 04:37:26	\N
47	Morgane Ciot	\N	morganeciot@gmail.com	\N	\N	2022-06-24 04:37:26	2022-06-24 04:37:26	\N
48	Neil L McMullen	\N	nlmcmullen@gmail.com	\N	\N	2022-06-24 04:37:26	2022-06-24 04:37:26	\N
49	Nick Colangelo	\N	nickcolangelo@gmail.com	\N	\N	2022-06-24 04:37:26	2022-06-24 04:37:26	\N
50	Ollie Donaldson	\N	olliums@gmail.com	\N	\N	2022-06-24 04:37:26	2022-06-24 04:37:26	\N
51	Owen Williams	\N	ywwg00@gmail.com	\N	\N	2022-06-24 04:37:26	2022-06-24 04:37:26	\N
52	Paul Raccuglia	\N	praccu@gmail.com	\N	\N	2022-06-24 04:37:26	2022-06-24 04:37:26	\N
53	Paula Countouris	\N	polyxeni@mit.edu	\N	\N	2022-06-24 04:37:26	2022-06-24 04:37:26	\N
54	Pete Salmone	\N	bullhead242@gmail.com	\N	\N	2022-06-24 04:37:26	2022-06-24 04:37:26	\N
55	Pipi Ann	\N	pipiannonfire@gmail.com	\N	\N	2022-06-24 04:37:26	2022-06-24 04:37:26	\N
56	Randal Meraki	\N	randal.d.gardner@gmail.com	\N	\N	2022-06-24 04:37:26	2022-06-24 04:37:26	\N
57	Reign Fure	\N	mistressreign@gmail.com	\N	\N	2022-06-24 04:37:26	2022-06-24 04:37:26	\N
58	Rick Pareles	\N	rpareles@gmail.com	\N	\N	2022-06-24 04:37:26	2022-06-24 04:37:26	\N
59	Rob Ticho	\N	rob.ticho@gmail.com	\N	\N	2022-06-24 04:37:26	2022-06-24 04:37:26	\N
60	Sam Auciello	\N	olleicua@gmail.com	\N	\N	2022-06-24 04:37:26	2022-06-24 04:37:26	\N
61	Scott Docherty	\N	scott.m.docherty@gmail.com	\N	\N	2022-06-24 04:37:26	2022-06-24 04:37:26	\N
62	Scott Longely	\N	skiggety@gmail.com	\N	\N	2022-06-24 04:37:26	2022-06-24 04:37:26	\N
63	Scout O'Beirne	\N	scoutobeirne@gmail.com	\N	\N	2022-06-24 04:37:26	2022-06-24 04:37:26	\N
64	Jason Brocksmith	\N	emailskittlez@gmail.com	\N	\N	2022-06-24 04:37:26	2022-06-24 04:37:26	\N
65	Sonia Domkarova	\N	soniax22@gmail.com	\N	\N	2022-06-24 04:37:26	2022-06-24 04:37:26	\N
66	Sophia Bozok	\N	info@wellesleyschoolofmusic.com	\N	\N	2022-06-24 04:37:26	2022-06-24 04:37:26	\N
67	Sophia Diggs-Galligan	\N	sediggsgalligan@gmail.com	\N	\N	2022-06-24 04:37:26	2022-06-24 04:37:26	\N
68	Steve Pomeroy	\N	steve@staticfree.info	\N	\N	2022-06-24 04:37:26	2022-06-24 04:37:26	\N
70	Talena Gandy	\N	thetalena@gmail.com	\N	\N	2022-06-24 04:37:26	2022-06-24 04:37:26	\N
71	Val Burke	\N	valkburke@gmail.com	\N	\N	2022-06-24 04:37:26	2022-06-24 04:37:26	\N
72	Will Martin	\N	williamwmartin@gmail.com	\N	\N	2022-06-24 04:37:26	2022-06-24 04:37:26	\N
73	Yelena Synkova	\N	ysynkova@gmail.com	\N	\N	2022-06-24 04:37:26	2022-06-24 04:37:26	\N
74	Jered Floyd	\N	jered@convivian.com	\N	\N	2022-06-24 19:50:50	2022-06-24 19:50:50	\N
75	Donald Guy	Dawn	donaldguy@hey.com	\N	\N	2022-06-24 19:52:58	2022-06-24 19:52:58	37
76	Daniel Pogue	Dan	shadowfelldown@gmail.com	\N	\N	2022-06-24 21:07:41	2022-06-24 21:07:41	\N
77	Willow Tuthill Burke	Willow	lillowillow@gmail.com	\N	\N	2022-06-24 21:10:04	2022-06-24 21:10:04	\N
78	David Trittschuh	Dio	laughing.goat@gmail.com	\N	\N	2022-06-24 21:16:28	2022-06-24 21:16:28	\N
79	Danielle Blair	Hugs	electronicdanielle@gmail.com	\N	\N	2022-06-24 21:28:29	2022-06-24 21:28:29	\N
80	Ballard Blaire	\N	glenn.blair92@gmail.com	\N	\N	2022-06-24 21:32:33	2022-06-24 21:32:33	\N
81	Andrew Greenspon	Andy	andy.greenspon@gmail.com	\N	\N	2022-06-24 21:44:13	2022-06-24 21:44:13	48
34	Karen Sittig	Oryx	oryx@fireflyartscollective.org	\N	\N	2022-06-24 04:37:26	2022-06-25 04:02:52	\N
11	Christina Hawkes	Riv	christina.hawkes@gmail.com	\N	\N	2022-06-24 04:37:26	2022-06-25 06:01:43	\N
82	Louis Nemzer	Lex	lex@alum.mit.edu	\N	\N	2022-06-24 22:01:19	2022-06-24 22:01:19	34
84	Donald Gerasimchik	\N	dgerasimchik92@gmail.com	\N	\N	2022-06-24 22:18:14	2022-06-24 22:18:14	40
87	paula countouris	Lazarus	papagenabird@gmail.com	\N	\N	2022-06-25 00:08:57	2022-06-25 00:08:57	\N
88	Courtenay Cotton	\N	cvcotton@gmail.com	\N	\N	2022-06-25 00:45:06	2022-06-25 00:45:06	\N
89	Jeff Matson	Jeff Mission	beatfixstudios@gmail.com	\N	\N	2022-06-25 00:47:26	2022-06-25 00:47:26	\N
90	clara	clara	clara.lafrance@gmail.com	\N	\N	2022-06-25 00:54:33	2022-06-25 00:54:33	\N
94	Amanda Leigh Berberich	Aurora (Whiskeytits)	amandaleigh32@gmail.com	\N	\N	2022-06-25 02:28:13	2022-06-25 02:28:13	17
95	Joel Thibault	Art Puncher	j9sq4r7du5@snkmail.com	\N	\N	2022-06-25 03:06:40	2022-06-25 03:06:40	48
96	Kate Estrop	Popple	thewriterkate@gmail.com	\N	\N	2022-06-25 03:09:03	2022-06-25 03:09:03	\N
97	Owen Williams	\N	owen-firefly@ywwg.com	\N	\N	2022-06-25 03:11:21	2022-06-25 03:11:21	32
98	Bob Cohen	\N	bobjcohen@gmail.com	\N	\N	2022-06-25 03:34:25	2022-06-25 03:34:25	\N
99	Galya Traub	galia	galiat@gmail.com	\N	\N	2022-06-25 04:08:05	2022-06-25 04:08:05	\N
69	Stephen Robbins	Scooter	sr@steverrobbins.com	\N	\N	2022-06-24 04:37:26	2022-06-25 04:50:27	\N
106	Jessica Saler	Jesse	JessicaSaler@gmail.com	\N	\N	2022-06-25 16:09:34	2022-06-25 16:09:34	\N
107	Joshua Boon	Clyde	fireflyartscollectiveorg@joshboon.com	\N	\N	2022-06-25 16:14:29	2022-06-25 16:14:29	\N
39	Kristen Williams	Nyx Sten	bomdiamundo@gmail.com	\N	\N	2022-06-24 04:37:26	2022-06-24 22:06:35	\N
83	Richard Short	Rickery	rickery2@gmail.com	\N	\N	2022-06-24 22:09:41	2022-06-24 22:09:41	\N
85	Kristin Holland Bohr	Holland	holland.K.graham@gmail.com	\N	\N	2022-06-24 22:48:38	2022-06-24 22:48:38	10
86	Amanda Kozicki	Mandalina	theamandakozicki@gmail.com	\N	\N	2022-06-24 23:55:00	2022-06-24 23:55:00	\N
91	Rebecca Cohn	Becca	becbec38@gmail.com	\N	\N	2022-06-25 01:27:10	2022-06-25 01:27:10	\N
92	Gabrielle Blonder	Gabby	gmblonder@gmail.com	\N	\N	2022-06-25 02:19:45	2022-06-25 02:19:45	\N
93	Danny Coombes	Koombubba	bassnut7684@gmail.com	\N	\N	2022-06-25 02:24:39	2022-06-25 02:24:39	\N
100	Anna Gollub	Hiplomat	anna.gollub@gmail.com	\N	\N	2022-06-25 04:26:35	2022-06-25 04:26:35	\N
101	Matthew McCorkindale	\N	matthewmccorkindale@gmail.com	\N	\N	2022-06-25 05:11:38	2022-06-25 05:11:38	\N
102	Kenneth Ide	Kenny	kenide55@gmail.com	\N	\N	2022-06-25 05:58:54	2022-06-25 05:58:54	\N
103	Danny Brzozowski	Thermite	dianeb3@gmail.com	\N	\N	2022-06-25 14:09:02	2022-06-25 14:09:02	\N
104	Diana Picariello	Di	dichotomydiana@gmail.com	\N	\N	2022-06-25 15:41:02	2022-06-25 15:41:02	7
105	Katie Morrissey	Katherine	katmorris.sey@gmail.com	\N	\N	2022-06-25 16:08:57	2022-06-25 16:08:57	\N
108	Dennis Zografos	\N	dz@dzog.us	\N	\N	2022-06-25 16:32:26	2022-06-25 16:32:26	\N
109	Katherine Elizabeth Van Rees	K8	K8vanrees@gmail.com	\N	\N	2022-06-25 18:21:15	2022-06-25 18:21:15	\N
\.


--
-- TOC entry 3092 (class 0 OID 5820729)
-- Dependencies: 203
-- Data for Name: schema_migrations; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.schema_migrations (version, inserted_at) FROM stdin;
20220619160431	2022-06-24 04:08:12
20220621153819	2022-06-24 04:08:12
20220623012616	2022-06-24 04:08:12
20220623223823	2022-06-24 04:08:12
20220623232010	2022-06-24 04:08:12
20220623232039	2022-06-24 04:08:12
\.


--
-- TOC entry 3116 (class 0 OID 0)
-- Dependencies: 212
-- Name: camps_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.camps_id_seq', 48, true);


--
-- TOC entry 3117 (class 0 OID 0)
-- Dependencies: 204
-- Name: event_categories_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.event_categories_id_seq', 9, true);


--
-- TOC entry 3118 (class 0 OID 0)
-- Dependencies: 214
-- Name: events_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.events_id_seq', 22, true);


--
-- TOC entry 3119 (class 0 OID 0)
-- Dependencies: 210
-- Name: locations_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.locations_id_seq', 23, true);


--
-- TOC entry 3120 (class 0 OID 0)
-- Dependencies: 206
-- Name: people_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.people_id_seq', 109, true);


--
-- TOC entry 3121 (class 0 OID 0)
-- Dependencies: 208
-- Name: people_tokens_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.people_tokens_id_seq', 61, true);


--
-- TOC entry 2951 (class 2606 OID 5820798)
-- Name: camps camps_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.camps
    ADD CONSTRAINT camps_pkey PRIMARY KEY (id);


--
-- TOC entry 2939 (class 2606 OID 5820745)
-- Name: event_categories event_categories_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.event_categories
    ADD CONSTRAINT event_categories_pkey PRIMARY KEY (id);


--
-- TOC entry 2955 (class 2606 OID 5820821)
-- Name: events events_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.events
    ADD CONSTRAINT events_pkey PRIMARY KEY (id);


--
-- TOC entry 2949 (class 2606 OID 5820787)
-- Name: locations locations_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.locations
    ADD CONSTRAINT locations_pkey PRIMARY KEY (id);


--
-- TOC entry 2943 (class 2606 OID 5820757)
-- Name: people people_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.people
    ADD CONSTRAINT people_pkey PRIMARY KEY (id);


--
-- TOC entry 2947 (class 2606 OID 5820769)
-- Name: people_tokens people_tokens_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.people_tokens
    ADD CONSTRAINT people_tokens_pkey PRIMARY KEY (id);


--
-- TOC entry 2936 (class 2606 OID 5820733)
-- Name: schema_migrations schema_migrations_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.schema_migrations
    ADD CONSTRAINT schema_migrations_pkey PRIMARY KEY (version);


--
-- TOC entry 2952 (class 1259 OID 5820809)
-- Name: camps_primary_contact_id_index; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX camps_primary_contact_id_index ON public.camps USING btree (primary_contact_id);


--
-- TOC entry 2937 (class 1259 OID 5820746)
-- Name: event_categories_name_minimum_age_index; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX event_categories_name_minimum_age_index ON public.event_categories USING btree (name, minimum_age);


--
-- TOC entry 2953 (class 1259 OID 5820844)
-- Name: events_category_id_index; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX events_category_id_index ON public.events USING btree (category_id);


--
-- TOC entry 2956 (class 1259 OID 5820842)
-- Name: events_start_date_index; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX events_start_date_index ON public.events USING btree (start_date);


--
-- TOC entry 2957 (class 1259 OID 5820843)
-- Name: events_start_time_index; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX events_start_time_index ON public.events USING btree (start_time);


--
-- TOC entry 2940 (class 1259 OID 5820850)
-- Name: people_camp_id_index; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX people_camp_id_index ON public.people USING btree (camp_id);


--
-- TOC entry 2941 (class 1259 OID 5820758)
-- Name: people_email_index; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX people_email_index ON public.people USING btree (email);


--
-- TOC entry 2944 (class 1259 OID 5820776)
-- Name: people_tokens_context_token_index; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX people_tokens_context_token_index ON public.people_tokens USING btree (context, token);


--
-- TOC entry 2945 (class 1259 OID 5820775)
-- Name: people_tokens_person_id_index; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX people_tokens_person_id_index ON public.people_tokens USING btree (person_id);


--
-- TOC entry 2961 (class 2606 OID 5820804)
-- Name: camps camps_location_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.camps
    ADD CONSTRAINT camps_location_id_fkey FOREIGN KEY (location_id) REFERENCES public.locations(id) ON DELETE CASCADE;


--
-- TOC entry 2960 (class 2606 OID 5820799)
-- Name: camps camps_primary_contact_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.camps
    ADD CONSTRAINT camps_primary_contact_id_fkey FOREIGN KEY (primary_contact_id) REFERENCES public.people(id);


--
-- TOC entry 2962 (class 2606 OID 5820822)
-- Name: events events_category_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.events
    ADD CONSTRAINT events_category_id_fkey FOREIGN KEY (category_id) REFERENCES public.event_categories(id);


--
-- TOC entry 2965 (class 2606 OID 5820837)
-- Name: events events_location_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.events
    ADD CONSTRAINT events_location_id_fkey FOREIGN KEY (location_id) REFERENCES public.locations(id);


--
-- TOC entry 2964 (class 2606 OID 5820832)
-- Name: events events_owning_camp_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.events
    ADD CONSTRAINT events_owning_camp_id_fkey FOREIGN KEY (owning_camp_id) REFERENCES public.camps(id);


--
-- TOC entry 2963 (class 2606 OID 5820827)
-- Name: events events_owning_person_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.events
    ADD CONSTRAINT events_owning_person_id_fkey FOREIGN KEY (owning_person_id) REFERENCES public.people(id);


--
-- TOC entry 2958 (class 2606 OID 5820845)
-- Name: people people_camp_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.people
    ADD CONSTRAINT people_camp_id_fkey FOREIGN KEY (camp_id) REFERENCES public.camps(id);


--
-- TOC entry 2959 (class 2606 OID 5820770)
-- Name: people_tokens people_tokens_person_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.people_tokens
    ADD CONSTRAINT people_tokens_person_id_fkey FOREIGN KEY (person_id) REFERENCES public.people(id) ON DELETE CASCADE;


-- Completed on 2022-06-25 16:53:35 EDT

--
-- PostgreSQL database dump complete
--

