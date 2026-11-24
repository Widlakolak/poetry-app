-- PoetryStream checked-in demo catalog (V2), NOT an import of its mutable live database.
-- Imported authors/work titles are real seed rows. The old demo actor biographies and
-- placeholder stock images are intentionally not copied.
-- External audio is referenced via the original URLs; no media binaries are copied.
-- Legacy ordered lyrics lack line timestamps; transcript status stays DRAFT.
-- Poem 6 is imported as a work only: its demo YouTube embed uses an invalid ID.

INSERT INTO creator (id, display_name, biography, created_at)
SELECT CAST('77771000-0000-4000-8000-000000000001' AS UUID), 'Julian Tuwim', NULL, CURRENT_TIMESTAMP
WHERE NOT EXISTS (SELECT 1 FROM creator WHERE lower(replace(display_name, ' ', '')) = lower(replace('Julian Tuwim', ' ', '')));
INSERT INTO creator (id, display_name, biography, created_at)
SELECT CAST('77771000-0000-4000-8000-000000000002' AS UUID), 'Maria Konopnicka', NULL, CURRENT_TIMESTAMP
WHERE NOT EXISTS (SELECT 1 FROM creator WHERE lower(replace(display_name, ' ', '')) = lower(replace('Maria Konopnicka', ' ', '')));
INSERT INTO creator (id, display_name, biography, created_at)
SELECT CAST('77771000-0000-4000-8000-000000000003' AS UUID), 'Bolesław Leśmian', NULL, CURRENT_TIMESTAMP
WHERE NOT EXISTS (SELECT 1 FROM creator WHERE lower(replace(display_name, ' ', '')) = lower(replace('Bolesław Leśmian', ' ', '')));
INSERT INTO creator (id, display_name, biography, created_at)
SELECT CAST('77771000-0000-4000-8000-000000000004' AS UUID), 'Adam Mickiewicz', NULL, CURRENT_TIMESTAMP
WHERE NOT EXISTS (SELECT 1 FROM creator WHERE lower(replace(display_name, ' ', '')) = lower(replace('Adam Mickiewicz', ' ', '')));
INSERT INTO creator (id, display_name, biography, created_at)
SELECT CAST('77771000-0000-4000-8000-000000000005' AS UUID), 'Maria Pawlikowska-Jasnorzewska', NULL, CURRENT_TIMESTAMP
WHERE NOT EXISTS (SELECT 1 FROM creator WHERE lower(replace(display_name, ' ', '')) = lower(replace('Maria Pawlikowska-Jasnorzewska', ' ', '')));
INSERT INTO creator (id, display_name, biography, created_at)
SELECT CAST('77771000-0000-4000-8000-000000000006' AS UUID), 'T.S. Eliot', NULL, CURRENT_TIMESTAMP
WHERE NOT EXISTS (SELECT 1 FROM creator WHERE lower(replace(display_name, ' ', '')) = lower(replace('T.S. Eliot', ' ', '')));
INSERT INTO creator (id, display_name, biography, created_at)
SELECT CAST('77771000-0000-4000-8000-000000000007' AS UUID), 'Jerzy Binkowski', NULL, CURRENT_TIMESTAMP
WHERE NOT EXISTS (SELECT 1 FROM creator WHERE lower(replace(display_name, ' ', '')) = lower(replace('Jerzy Binkowski', ' ', '')));
INSERT INTO creator (id, display_name, biography, created_at)
SELECT CAST('77771000-0000-4000-8000-000000000008' AS UUID), 'Piotr Nater', NULL, CURRENT_TIMESTAMP
WHERE NOT EXISTS (SELECT 1 FROM creator WHERE lower(replace(display_name, ' ', '')) = lower(replace('Piotr Nater', ' ', '')));
INSERT INTO creator (id, display_name, biography, created_at)
SELECT CAST('77771000-0000-4000-8000-000000000009' AS UUID), 'Nina Brown', NULL, CURRENT_TIMESTAMP
WHERE NOT EXISTS (SELECT 1 FROM creator WHERE lower(replace(display_name, ' ', '')) = lower(replace('Nina Brown', ' ', '')));

INSERT INTO literary_work (id, slug, title, author_id, summary, is_published, created_at)
SELECT CAST('77772000-0000-4000-8000-000000000001' AS UUID), 'okulary-tuwim', 'Okulary', (SELECT id FROM creator WHERE lower(replace(display_name, ' ', '')) = lower(replace('Julian Tuwim', ' ', '')) ORDER BY created_at, id LIMIT 1), NULL, TRUE, CURRENT_TIMESTAMP
WHERE NOT EXISTS (SELECT 1 FROM literary_work WHERE slug = 'okulary-tuwim');
INSERT INTO literary_work (id, slug, title, author_id, summary, is_published, created_at)
SELECT CAST('77772000-0000-4000-8000-000000000002' AS UUID), 'przygrywka-konopnicka', 'Przygrywka', (SELECT id FROM creator WHERE lower(replace(display_name, ' ', '')) = lower(replace('Maria Konopnicka', ' ', '')) ORDER BY created_at, id LIMIT 1), NULL, TRUE, CURRENT_TIMESTAMP
WHERE NOT EXISTS (SELECT 1 FROM literary_work WHERE slug = 'przygrywka-konopnicka');
INSERT INTO literary_work (id, slug, title, author_id, summary, is_published, created_at)
SELECT CAST('77772000-0000-4000-8000-000000000003' AS UUID), 'zamyslenie-lesmian', 'Zamyślenie', (SELECT id FROM creator WHERE lower(replace(display_name, ' ', '')) = lower(replace('Bolesław Leśmian', ' ', '')) ORDER BY created_at, id LIMIT 1), NULL, TRUE, CURRENT_TIMESTAMP
WHERE NOT EXISTS (SELECT 1 FROM literary_work WHERE slug = 'zamyslenie-lesmian');
INSERT INTO literary_work (id, slug, title, author_id, summary, is_published, created_at)
SELECT CAST('77772000-0000-4000-8000-000000000004' AS UUID), 'pani-twardowska', 'Pani Twardowska', (SELECT id FROM creator WHERE lower(replace(display_name, ' ', '')) = lower(replace('Adam Mickiewicz', ' ', '')) ORDER BY created_at, id LIMIT 1), NULL, TRUE, CURRENT_TIMESTAMP
WHERE NOT EXISTS (SELECT 1 FROM literary_work WHERE slug = 'pani-twardowska');
INSERT INTO literary_work (id, slug, title, author_id, summary, is_published, created_at)
SELECT CAST('77772000-0000-4000-8000-000000000005' AS UUID), 'dom-na-modrzewiu', 'Dom na modrzewiu', (SELECT id FROM creator WHERE lower(replace(display_name, ' ', '')) = lower(replace('Maria Pawlikowska-Jasnorzewska', ' ', '')) ORDER BY created_at, id LIMIT 1), NULL, TRUE, CURRENT_TIMESTAMP
WHERE NOT EXISTS (SELECT 1 FROM literary_work WHERE slug = 'dom-na-modrzewiu');
INSERT INTO literary_work (id, slug, title, author_id, summary, is_published, created_at)
SELECT CAST('77772000-0000-4000-8000-000000000006' AS UUID), 'the-love-song-of-j-alfred-prufrock', 'The Love Song of J. Alfred Prufrock', (SELECT id FROM creator WHERE lower(replace(display_name, ' ', '')) = lower(replace('T.S. Eliot', ' ', '')) ORDER BY created_at, id LIMIT 1), NULL, TRUE, CURRENT_TIMESTAMP
WHERE NOT EXISTS (SELECT 1 FROM literary_work WHERE slug = 'the-love-song-of-j-alfred-prufrock');

-- Okulary: 18 ordered lines, 15s initial offset, no exact cue timings.
INSERT INTO media_item (id, title, media_type, source_type, source_url, original_filename, storage_key, mime_type, file_size_bytes, sha256, duration_ms, publication_status, transcript_status, created_at, published_at)
VALUES (CAST('77773000-0000-4000-8000-000000000001' AS UUID), 'Okulary', 'AUDIO', 'EXTERNAL_AUDIO', 'https://dn720708.ca.archive.org/0/items/lokomotywa-tuwim/Tuwim-Okulary.mp3', NULL, NULL, 'audio/mpeg', NULL, NULL, NULL, 'PUBLISHED', 'DRAFT', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP);
INSERT INTO work_recording (work_id, media_item_id) VALUES (CAST('77772000-0000-4000-8000-000000000001' AS UUID), CAST('77773000-0000-4000-8000-000000000001' AS UUID));
INSERT INTO media_credit (id, media_item_id, creator_id, credit_role) VALUES (CAST('77776000-0000-4000-8000-000000000001' AS UUID), CAST('77773000-0000-4000-8000-000000000001' AS UUID), (SELECT id FROM creator WHERE lower(replace(display_name, ' ', '')) = lower(replace('Julian Tuwim', ' ', '')) ORDER BY created_at, id LIMIT 1), 'POET');
INSERT INTO media_credit (id, media_item_id, creator_id, credit_role) VALUES (CAST('77776000-0000-4000-8000-000000000002' AS UUID), CAST('77773000-0000-4000-8000-000000000001' AS UUID), (SELECT id FROM creator WHERE lower(replace(display_name, ' ', '')) = lower(replace('Jerzy Binkowski', ' ', '')) ORDER BY created_at, id LIMIT 1), 'ARTIST');
INSERT INTO transcript (id, media_item_id, language_code, full_text, created_at, updated_at, start_offset_ms)
VALUES (CAST('77774000-0000-4000-8000-000000000001' AS UUID), CAST('77773000-0000-4000-8000-000000000001' AS UUID), 'pl', 'Biega, krzyczy pan Hilary:
„Gdzie są moje okulary?”
Szuka w spodniach i w surducie,
W prawym bucie, w lewym bucie.
Wszystko w szafach poprzewracał,
Maca szlafrok, palto maca.
„Skandal! – krzyczy - nie do wiary!
Ktoś mi ukradł okulary!”
Pod kanapą, na kanapie,
Wszędzie szuka, parska, sapie!
Szpera w piecu i w kominie,
W mysiej dziurze i w pianinie.
Już podłogę chce odrywać,
Już policję zaczął wzywać.
Nagle - zerknął do lusterka…
Nie chce wierzyć… Znowu zerka.
Znalazł! Są! Okazało się,
Że je ma na własnym nosie.', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP, 15000);
INSERT INTO transcript_segment (id, transcript_id, sequence_number, segment_text, start_ms, end_ms)
VALUES (CAST('77775000-0000-4000-8000-000000000001' AS UUID), CAST('77774000-0000-4000-8000-000000000001' AS UUID), 0, 'Biega, krzyczy pan Hilary:', NULL, NULL);
INSERT INTO transcript_segment (id, transcript_id, sequence_number, segment_text, start_ms, end_ms)
VALUES (CAST('77775000-0000-4000-8000-000000000002' AS UUID), CAST('77774000-0000-4000-8000-000000000001' AS UUID), 1, '„Gdzie są moje okulary?”', NULL, NULL);
INSERT INTO transcript_segment (id, transcript_id, sequence_number, segment_text, start_ms, end_ms)
VALUES (CAST('77775000-0000-4000-8000-000000000003' AS UUID), CAST('77774000-0000-4000-8000-000000000001' AS UUID), 2, 'Szuka w spodniach i w surducie,', NULL, NULL);
INSERT INTO transcript_segment (id, transcript_id, sequence_number, segment_text, start_ms, end_ms)
VALUES (CAST('77775000-0000-4000-8000-000000000004' AS UUID), CAST('77774000-0000-4000-8000-000000000001' AS UUID), 3, 'W prawym bucie, w lewym bucie.', NULL, NULL);
INSERT INTO transcript_segment (id, transcript_id, sequence_number, segment_text, start_ms, end_ms)
VALUES (CAST('77775000-0000-4000-8000-000000000005' AS UUID), CAST('77774000-0000-4000-8000-000000000001' AS UUID), 4, 'Wszystko w szafach poprzewracał,', NULL, NULL);
INSERT INTO transcript_segment (id, transcript_id, sequence_number, segment_text, start_ms, end_ms)
VALUES (CAST('77775000-0000-4000-8000-000000000006' AS UUID), CAST('77774000-0000-4000-8000-000000000001' AS UUID), 5, 'Maca szlafrok, palto maca.', NULL, NULL);
INSERT INTO transcript_segment (id, transcript_id, sequence_number, segment_text, start_ms, end_ms)
VALUES (CAST('77775000-0000-4000-8000-000000000007' AS UUID), CAST('77774000-0000-4000-8000-000000000001' AS UUID), 6, '„Skandal! – krzyczy - nie do wiary!', NULL, NULL);
INSERT INTO transcript_segment (id, transcript_id, sequence_number, segment_text, start_ms, end_ms)
VALUES (CAST('77775000-0000-4000-8000-000000000008' AS UUID), CAST('77774000-0000-4000-8000-000000000001' AS UUID), 7, 'Ktoś mi ukradł okulary!”', NULL, NULL);
INSERT INTO transcript_segment (id, transcript_id, sequence_number, segment_text, start_ms, end_ms)
VALUES (CAST('77775000-0000-4000-8000-000000000009' AS UUID), CAST('77774000-0000-4000-8000-000000000001' AS UUID), 8, 'Pod kanapą, na kanapie,', NULL, NULL);
INSERT INTO transcript_segment (id, transcript_id, sequence_number, segment_text, start_ms, end_ms)
VALUES (CAST('77775000-0000-4000-8000-000000000010' AS UUID), CAST('77774000-0000-4000-8000-000000000001' AS UUID), 9, 'Wszędzie szuka, parska, sapie!', NULL, NULL);
INSERT INTO transcript_segment (id, transcript_id, sequence_number, segment_text, start_ms, end_ms)
VALUES (CAST('77775000-0000-4000-8000-000000000011' AS UUID), CAST('77774000-0000-4000-8000-000000000001' AS UUID), 10, 'Szpera w piecu i w kominie,', NULL, NULL);
INSERT INTO transcript_segment (id, transcript_id, sequence_number, segment_text, start_ms, end_ms)
VALUES (CAST('77775000-0000-4000-8000-000000000012' AS UUID), CAST('77774000-0000-4000-8000-000000000001' AS UUID), 11, 'W mysiej dziurze i w pianinie.', NULL, NULL);
INSERT INTO transcript_segment (id, transcript_id, sequence_number, segment_text, start_ms, end_ms)
VALUES (CAST('77775000-0000-4000-8000-000000000013' AS UUID), CAST('77774000-0000-4000-8000-000000000001' AS UUID), 12, 'Już podłogę chce odrywać,', NULL, NULL);
INSERT INTO transcript_segment (id, transcript_id, sequence_number, segment_text, start_ms, end_ms)
VALUES (CAST('77775000-0000-4000-8000-000000000014' AS UUID), CAST('77774000-0000-4000-8000-000000000001' AS UUID), 13, 'Już policję zaczął wzywać.', NULL, NULL);
INSERT INTO transcript_segment (id, transcript_id, sequence_number, segment_text, start_ms, end_ms)
VALUES (CAST('77775000-0000-4000-8000-000000000015' AS UUID), CAST('77774000-0000-4000-8000-000000000001' AS UUID), 14, 'Nagle - zerknął do lusterka…', NULL, NULL);
INSERT INTO transcript_segment (id, transcript_id, sequence_number, segment_text, start_ms, end_ms)
VALUES (CAST('77775000-0000-4000-8000-000000000016' AS UUID), CAST('77774000-0000-4000-8000-000000000001' AS UUID), 15, 'Nie chce wierzyć… Znowu zerka.', NULL, NULL);
INSERT INTO transcript_segment (id, transcript_id, sequence_number, segment_text, start_ms, end_ms)
VALUES (CAST('77775000-0000-4000-8000-000000000017' AS UUID), CAST('77774000-0000-4000-8000-000000000001' AS UUID), 16, 'Znalazł! Są! Okazało się,', NULL, NULL);
INSERT INTO transcript_segment (id, transcript_id, sequence_number, segment_text, start_ms, end_ms)
VALUES (CAST('77775000-0000-4000-8000-000000000018' AS UUID), CAST('77774000-0000-4000-8000-000000000001' AS UUID), 17, 'Że je ma na własnym nosie.', NULL, NULL);

-- Przygrywka: 60 ordered lines, 17s initial offset, no exact cue timings.
INSERT INTO media_item (id, title, media_type, source_type, source_url, original_filename, storage_key, mime_type, file_size_bytes, sha256, duration_ms, publication_status, transcript_status, created_at, published_at)
VALUES (CAST('77773000-0000-4000-8000-000000000002' AS UUID), 'Przygrywka', 'AUDIO', 'EXTERNAL_AUDIO', 'https://www.archive.org/download/msw031_2203_librivox/msw031_11_przygrywka_konopnicka_pn81_128kb.mp3', NULL, NULL, 'audio/mpeg', NULL, NULL, NULL, 'PUBLISHED', 'DRAFT', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP);
INSERT INTO work_recording (work_id, media_item_id) VALUES (CAST('77772000-0000-4000-8000-000000000002' AS UUID), CAST('77773000-0000-4000-8000-000000000002' AS UUID));
INSERT INTO media_credit (id, media_item_id, creator_id, credit_role) VALUES (CAST('77776000-0000-4000-8000-000000000003' AS UUID), CAST('77773000-0000-4000-8000-000000000002' AS UUID), (SELECT id FROM creator WHERE lower(replace(display_name, ' ', '')) = lower(replace('Maria Konopnicka', ' ', '')) ORDER BY created_at, id LIMIT 1), 'POET');
INSERT INTO media_credit (id, media_item_id, creator_id, credit_role) VALUES (CAST('77776000-0000-4000-8000-000000000004' AS UUID), CAST('77773000-0000-4000-8000-000000000002' AS UUID), (SELECT id FROM creator WHERE lower(replace(display_name, ' ', '')) = lower(replace('Piotr Nater', ' ', '')) ORDER BY created_at, id LIMIT 1), 'ARTIST');
INSERT INTO transcript (id, media_item_id, language_code, full_text, created_at, updated_at, start_offset_ms)
VALUES (CAST('77774000-0000-4000-8000-000000000002' AS UUID), CAST('77773000-0000-4000-8000-000000000002' AS UUID), 'pl', 'Wkoło mnie otoczyły moje równie senne,
Pasmem jednakiem...
Ale ja sobie lecę w krainy odmienne —
Umiem być ptakiem!
Błękitna przestrzeń mruga, zaprasza do siebie,
Skrzydeł nie nuży...
Pędzim sobie we trójkę: ja, obłok na niebie,
I listek róży.
Listek najpierwszy upadł na wioskowym kopcu
Cudzej granicy,
Jak rzucone słóweczko drogiemu mi chłopcu
Mdłej obietnicy...
A obłok powiał dalej... Pod słonko się stroi
W biel i we złoto,
Aż u chaty ostatniej, co w kraju mym stoi,
Zadrżał tęsknotą...
Wiatr szarpnął go za szatę, rozrzucił mu włosy;
Toż łzami leci
Na łączkę, gdzie pod gruszą siedzi dziaduś bosy
I kupka dzieci...
Nie chce odlecieć dalej! Z tej mgły urodzony,
Z oparów rzeki:
Gdzież mu zwiedzać świat obcy, inne jakieś strony
I kraj daleki?
Więc sama lecę... sama, choć serce mnie boli
I smutno wróży...
Czemuż nie chciał obłoczek podzielić mej doli,
Ni listek róży?
Z obłoczka jabym sobie wieczorem pod głowę
Zwiła posłanie;
A z listka zasię róży — toć czary gotowe
Na zakochanie.
Lecz sina dal pociąga i wabi i nęci,
Jak cud nieznany...
Ej! ujrzę raz na oczy insze sianożęci,
Insze kurhany!
Ej! posłyszę ja przecież, jakto ludzie gwarzą
Obcym mi gwarem...
I wypatrzę miesiączek, z jaką wstaje twarzą
Nad cudzym jarem...
I dowiem się raz wreszcie, gdzie tęcza podziewa
Wstążek swych końce
I jakie tam piosenki o zmroku rozbrzmiewa
Echo mdlejące.
U nas w wiosce znam wszystko... wszystkiegom już syta,
Aż do znudzenia...
Codzień z za tego wzgórza słońce rankiem świta,
Nic się nie zmienia.
Wiem, gdzie rosną dziewanny, a gdzie niezabudki
W przydrożnym rowie;
Wiem, gdzie szary słowiczek zwił domek malutki
W naszej dąbrowie;
Wiem, gdzie ojciec łan orze, gdzie matka wybiela
Cieniutkie płótna;
Wiem, jak w święto wieczorem grzmi wiejska kapela,
Jak fletnia smutna...
Lasek, cmentarz, kościółek, starego plebana,
Znam już z pamięci...
Tęskno mi! — Hej, pociąga dal sina, nieznana,
Wabi i nęci!', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP, 17000);
INSERT INTO transcript_segment (id, transcript_id, sequence_number, segment_text, start_ms, end_ms)
VALUES (CAST('77775000-0000-4000-8000-000000000019' AS UUID), CAST('77774000-0000-4000-8000-000000000002' AS UUID), 0, 'Wkoło mnie otoczyły moje równie senne,', NULL, NULL);
INSERT INTO transcript_segment (id, transcript_id, sequence_number, segment_text, start_ms, end_ms)
VALUES (CAST('77775000-0000-4000-8000-000000000020' AS UUID), CAST('77774000-0000-4000-8000-000000000002' AS UUID), 1, 'Pasmem jednakiem...', NULL, NULL);
INSERT INTO transcript_segment (id, transcript_id, sequence_number, segment_text, start_ms, end_ms)
VALUES (CAST('77775000-0000-4000-8000-000000000021' AS UUID), CAST('77774000-0000-4000-8000-000000000002' AS UUID), 2, 'Ale ja sobie lecę w krainy odmienne —', NULL, NULL);
INSERT INTO transcript_segment (id, transcript_id, sequence_number, segment_text, start_ms, end_ms)
VALUES (CAST('77775000-0000-4000-8000-000000000022' AS UUID), CAST('77774000-0000-4000-8000-000000000002' AS UUID), 3, 'Umiem być ptakiem!', NULL, NULL);
INSERT INTO transcript_segment (id, transcript_id, sequence_number, segment_text, start_ms, end_ms)
VALUES (CAST('77775000-0000-4000-8000-000000000023' AS UUID), CAST('77774000-0000-4000-8000-000000000002' AS UUID), 4, 'Błękitna przestrzeń mruga, zaprasza do siebie,', NULL, NULL);
INSERT INTO transcript_segment (id, transcript_id, sequence_number, segment_text, start_ms, end_ms)
VALUES (CAST('77775000-0000-4000-8000-000000000024' AS UUID), CAST('77774000-0000-4000-8000-000000000002' AS UUID), 5, 'Skrzydeł nie nuży...', NULL, NULL);
INSERT INTO transcript_segment (id, transcript_id, sequence_number, segment_text, start_ms, end_ms)
VALUES (CAST('77775000-0000-4000-8000-000000000025' AS UUID), CAST('77774000-0000-4000-8000-000000000002' AS UUID), 6, 'Pędzim sobie we trójkę: ja, obłok na niebie,', NULL, NULL);
INSERT INTO transcript_segment (id, transcript_id, sequence_number, segment_text, start_ms, end_ms)
VALUES (CAST('77775000-0000-4000-8000-000000000026' AS UUID), CAST('77774000-0000-4000-8000-000000000002' AS UUID), 7, 'I listek róży.', NULL, NULL);
INSERT INTO transcript_segment (id, transcript_id, sequence_number, segment_text, start_ms, end_ms)
VALUES (CAST('77775000-0000-4000-8000-000000000027' AS UUID), CAST('77774000-0000-4000-8000-000000000002' AS UUID), 8, 'Listek najpierwszy upadł na wioskowym kopcu', NULL, NULL);
INSERT INTO transcript_segment (id, transcript_id, sequence_number, segment_text, start_ms, end_ms)
VALUES (CAST('77775000-0000-4000-8000-000000000028' AS UUID), CAST('77774000-0000-4000-8000-000000000002' AS UUID), 9, 'Cudzej granicy,', NULL, NULL);
INSERT INTO transcript_segment (id, transcript_id, sequence_number, segment_text, start_ms, end_ms)
VALUES (CAST('77775000-0000-4000-8000-000000000029' AS UUID), CAST('77774000-0000-4000-8000-000000000002' AS UUID), 10, 'Jak rzucone słóweczko drogiemu mi chłopcu', NULL, NULL);
INSERT INTO transcript_segment (id, transcript_id, sequence_number, segment_text, start_ms, end_ms)
VALUES (CAST('77775000-0000-4000-8000-000000000030' AS UUID), CAST('77774000-0000-4000-8000-000000000002' AS UUID), 11, 'Mdłej obietnicy...', NULL, NULL);
INSERT INTO transcript_segment (id, transcript_id, sequence_number, segment_text, start_ms, end_ms)
VALUES (CAST('77775000-0000-4000-8000-000000000031' AS UUID), CAST('77774000-0000-4000-8000-000000000002' AS UUID), 12, 'A obłok powiał dalej... Pod słonko się stroi', NULL, NULL);
INSERT INTO transcript_segment (id, transcript_id, sequence_number, segment_text, start_ms, end_ms)
VALUES (CAST('77775000-0000-4000-8000-000000000032' AS UUID), CAST('77774000-0000-4000-8000-000000000002' AS UUID), 13, 'W biel i we złoto,', NULL, NULL);
INSERT INTO transcript_segment (id, transcript_id, sequence_number, segment_text, start_ms, end_ms)
VALUES (CAST('77775000-0000-4000-8000-000000000033' AS UUID), CAST('77774000-0000-4000-8000-000000000002' AS UUID), 14, 'Aż u chaty ostatniej, co w kraju mym stoi,', NULL, NULL);
INSERT INTO transcript_segment (id, transcript_id, sequence_number, segment_text, start_ms, end_ms)
VALUES (CAST('77775000-0000-4000-8000-000000000034' AS UUID), CAST('77774000-0000-4000-8000-000000000002' AS UUID), 15, 'Zadrżał tęsknotą...', NULL, NULL);
INSERT INTO transcript_segment (id, transcript_id, sequence_number, segment_text, start_ms, end_ms)
VALUES (CAST('77775000-0000-4000-8000-000000000035' AS UUID), CAST('77774000-0000-4000-8000-000000000002' AS UUID), 16, 'Wiatr szarpnął go za szatę, rozrzucił mu włosy;', NULL, NULL);
INSERT INTO transcript_segment (id, transcript_id, sequence_number, segment_text, start_ms, end_ms)
VALUES (CAST('77775000-0000-4000-8000-000000000036' AS UUID), CAST('77774000-0000-4000-8000-000000000002' AS UUID), 17, 'Toż łzami leci', NULL, NULL);
INSERT INTO transcript_segment (id, transcript_id, sequence_number, segment_text, start_ms, end_ms)
VALUES (CAST('77775000-0000-4000-8000-000000000037' AS UUID), CAST('77774000-0000-4000-8000-000000000002' AS UUID), 18, 'Na łączkę, gdzie pod gruszą siedzi dziaduś bosy', NULL, NULL);
INSERT INTO transcript_segment (id, transcript_id, sequence_number, segment_text, start_ms, end_ms)
VALUES (CAST('77775000-0000-4000-8000-000000000038' AS UUID), CAST('77774000-0000-4000-8000-000000000002' AS UUID), 19, 'I kupka dzieci...', NULL, NULL);
INSERT INTO transcript_segment (id, transcript_id, sequence_number, segment_text, start_ms, end_ms)
VALUES (CAST('77775000-0000-4000-8000-000000000039' AS UUID), CAST('77774000-0000-4000-8000-000000000002' AS UUID), 20, 'Nie chce odlecieć dalej! Z tej mgły urodzony,', NULL, NULL);
INSERT INTO transcript_segment (id, transcript_id, sequence_number, segment_text, start_ms, end_ms)
VALUES (CAST('77775000-0000-4000-8000-000000000040' AS UUID), CAST('77774000-0000-4000-8000-000000000002' AS UUID), 21, 'Z oparów rzeki:', NULL, NULL);
INSERT INTO transcript_segment (id, transcript_id, sequence_number, segment_text, start_ms, end_ms)
VALUES (CAST('77775000-0000-4000-8000-000000000041' AS UUID), CAST('77774000-0000-4000-8000-000000000002' AS UUID), 22, 'Gdzież mu zwiedzać świat obcy, inne jakieś strony', NULL, NULL);
INSERT INTO transcript_segment (id, transcript_id, sequence_number, segment_text, start_ms, end_ms)
VALUES (CAST('77775000-0000-4000-8000-000000000042' AS UUID), CAST('77774000-0000-4000-8000-000000000002' AS UUID), 23, 'I kraj daleki?', NULL, NULL);
INSERT INTO transcript_segment (id, transcript_id, sequence_number, segment_text, start_ms, end_ms)
VALUES (CAST('77775000-0000-4000-8000-000000000043' AS UUID), CAST('77774000-0000-4000-8000-000000000002' AS UUID), 24, 'Więc sama lecę... sama, choć serce mnie boli', NULL, NULL);
INSERT INTO transcript_segment (id, transcript_id, sequence_number, segment_text, start_ms, end_ms)
VALUES (CAST('77775000-0000-4000-8000-000000000044' AS UUID), CAST('77774000-0000-4000-8000-000000000002' AS UUID), 25, 'I smutno wróży...', NULL, NULL);
INSERT INTO transcript_segment (id, transcript_id, sequence_number, segment_text, start_ms, end_ms)
VALUES (CAST('77775000-0000-4000-8000-000000000045' AS UUID), CAST('77774000-0000-4000-8000-000000000002' AS UUID), 26, 'Czemuż nie chciał obłoczek podzielić mej doli,', NULL, NULL);
INSERT INTO transcript_segment (id, transcript_id, sequence_number, segment_text, start_ms, end_ms)
VALUES (CAST('77775000-0000-4000-8000-000000000046' AS UUID), CAST('77774000-0000-4000-8000-000000000002' AS UUID), 27, 'Ni listek róży?', NULL, NULL);
INSERT INTO transcript_segment (id, transcript_id, sequence_number, segment_text, start_ms, end_ms)
VALUES (CAST('77775000-0000-4000-8000-000000000047' AS UUID), CAST('77774000-0000-4000-8000-000000000002' AS UUID), 28, 'Z obłoczka jabym sobie wieczorem pod głowę', NULL, NULL);
INSERT INTO transcript_segment (id, transcript_id, sequence_number, segment_text, start_ms, end_ms)
VALUES (CAST('77775000-0000-4000-8000-000000000048' AS UUID), CAST('77774000-0000-4000-8000-000000000002' AS UUID), 29, 'Zwiła posłanie;', NULL, NULL);
INSERT INTO transcript_segment (id, transcript_id, sequence_number, segment_text, start_ms, end_ms)
VALUES (CAST('77775000-0000-4000-8000-000000000049' AS UUID), CAST('77774000-0000-4000-8000-000000000002' AS UUID), 30, 'A z listka zasię róży — toć czary gotowe', NULL, NULL);
INSERT INTO transcript_segment (id, transcript_id, sequence_number, segment_text, start_ms, end_ms)
VALUES (CAST('77775000-0000-4000-8000-000000000050' AS UUID), CAST('77774000-0000-4000-8000-000000000002' AS UUID), 31, 'Na zakochanie.', NULL, NULL);
INSERT INTO transcript_segment (id, transcript_id, sequence_number, segment_text, start_ms, end_ms)
VALUES (CAST('77775000-0000-4000-8000-000000000051' AS UUID), CAST('77774000-0000-4000-8000-000000000002' AS UUID), 32, 'Lecz sina dal pociąga i wabi i nęci,', NULL, NULL);
INSERT INTO transcript_segment (id, transcript_id, sequence_number, segment_text, start_ms, end_ms)
VALUES (CAST('77775000-0000-4000-8000-000000000052' AS UUID), CAST('77774000-0000-4000-8000-000000000002' AS UUID), 33, 'Jak cud nieznany...', NULL, NULL);
INSERT INTO transcript_segment (id, transcript_id, sequence_number, segment_text, start_ms, end_ms)
VALUES (CAST('77775000-0000-4000-8000-000000000053' AS UUID), CAST('77774000-0000-4000-8000-000000000002' AS UUID), 34, 'Ej! ujrzę raz na oczy insze sianożęci,', NULL, NULL);
INSERT INTO transcript_segment (id, transcript_id, sequence_number, segment_text, start_ms, end_ms)
VALUES (CAST('77775000-0000-4000-8000-000000000054' AS UUID), CAST('77774000-0000-4000-8000-000000000002' AS UUID), 35, 'Insze kurhany!', NULL, NULL);
INSERT INTO transcript_segment (id, transcript_id, sequence_number, segment_text, start_ms, end_ms)
VALUES (CAST('77775000-0000-4000-8000-000000000055' AS UUID), CAST('77774000-0000-4000-8000-000000000002' AS UUID), 36, 'Ej! posłyszę ja przecież, jakto ludzie gwarzą', NULL, NULL);
INSERT INTO transcript_segment (id, transcript_id, sequence_number, segment_text, start_ms, end_ms)
VALUES (CAST('77775000-0000-4000-8000-000000000056' AS UUID), CAST('77774000-0000-4000-8000-000000000002' AS UUID), 37, 'Obcym mi gwarem...', NULL, NULL);
INSERT INTO transcript_segment (id, transcript_id, sequence_number, segment_text, start_ms, end_ms)
VALUES (CAST('77775000-0000-4000-8000-000000000057' AS UUID), CAST('77774000-0000-4000-8000-000000000002' AS UUID), 38, 'I wypatrzę miesiączek, z jaką wstaje twarzą', NULL, NULL);
INSERT INTO transcript_segment (id, transcript_id, sequence_number, segment_text, start_ms, end_ms)
VALUES (CAST('77775000-0000-4000-8000-000000000058' AS UUID), CAST('77774000-0000-4000-8000-000000000002' AS UUID), 39, 'Nad cudzym jarem...', NULL, NULL);
INSERT INTO transcript_segment (id, transcript_id, sequence_number, segment_text, start_ms, end_ms)
VALUES (CAST('77775000-0000-4000-8000-000000000059' AS UUID), CAST('77774000-0000-4000-8000-000000000002' AS UUID), 40, 'I dowiem się raz wreszcie, gdzie tęcza podziewa', NULL, NULL);
INSERT INTO transcript_segment (id, transcript_id, sequence_number, segment_text, start_ms, end_ms)
VALUES (CAST('77775000-0000-4000-8000-000000000060' AS UUID), CAST('77774000-0000-4000-8000-000000000002' AS UUID), 41, 'Wstążek swych końce', NULL, NULL);
INSERT INTO transcript_segment (id, transcript_id, sequence_number, segment_text, start_ms, end_ms)
VALUES (CAST('77775000-0000-4000-8000-000000000061' AS UUID), CAST('77774000-0000-4000-8000-000000000002' AS UUID), 42, 'I jakie tam piosenki o zmroku rozbrzmiewa', NULL, NULL);
INSERT INTO transcript_segment (id, transcript_id, sequence_number, segment_text, start_ms, end_ms)
VALUES (CAST('77775000-0000-4000-8000-000000000062' AS UUID), CAST('77774000-0000-4000-8000-000000000002' AS UUID), 43, 'Echo mdlejące.', NULL, NULL);
INSERT INTO transcript_segment (id, transcript_id, sequence_number, segment_text, start_ms, end_ms)
VALUES (CAST('77775000-0000-4000-8000-000000000063' AS UUID), CAST('77774000-0000-4000-8000-000000000002' AS UUID), 44, 'U nas w wiosce znam wszystko... wszystkiegom już syta,', NULL, NULL);
INSERT INTO transcript_segment (id, transcript_id, sequence_number, segment_text, start_ms, end_ms)
VALUES (CAST('77775000-0000-4000-8000-000000000064' AS UUID), CAST('77774000-0000-4000-8000-000000000002' AS UUID), 45, 'Aż do znudzenia...', NULL, NULL);
INSERT INTO transcript_segment (id, transcript_id, sequence_number, segment_text, start_ms, end_ms)
VALUES (CAST('77775000-0000-4000-8000-000000000065' AS UUID), CAST('77774000-0000-4000-8000-000000000002' AS UUID), 46, 'Codzień z za tego wzgórza słońce rankiem świta,', NULL, NULL);
INSERT INTO transcript_segment (id, transcript_id, sequence_number, segment_text, start_ms, end_ms)
VALUES (CAST('77775000-0000-4000-8000-000000000066' AS UUID), CAST('77774000-0000-4000-8000-000000000002' AS UUID), 47, 'Nic się nie zmienia.', NULL, NULL);
INSERT INTO transcript_segment (id, transcript_id, sequence_number, segment_text, start_ms, end_ms)
VALUES (CAST('77775000-0000-4000-8000-000000000067' AS UUID), CAST('77774000-0000-4000-8000-000000000002' AS UUID), 48, 'Wiem, gdzie rosną dziewanny, a gdzie niezabudki', NULL, NULL);
INSERT INTO transcript_segment (id, transcript_id, sequence_number, segment_text, start_ms, end_ms)
VALUES (CAST('77775000-0000-4000-8000-000000000068' AS UUID), CAST('77774000-0000-4000-8000-000000000002' AS UUID), 49, 'W przydrożnym rowie;', NULL, NULL);
INSERT INTO transcript_segment (id, transcript_id, sequence_number, segment_text, start_ms, end_ms)
VALUES (CAST('77775000-0000-4000-8000-000000000069' AS UUID), CAST('77774000-0000-4000-8000-000000000002' AS UUID), 50, 'Wiem, gdzie szary słowiczek zwił domek malutki', NULL, NULL);
INSERT INTO transcript_segment (id, transcript_id, sequence_number, segment_text, start_ms, end_ms)
VALUES (CAST('77775000-0000-4000-8000-000000000070' AS UUID), CAST('77774000-0000-4000-8000-000000000002' AS UUID), 51, 'W naszej dąbrowie;', NULL, NULL);
INSERT INTO transcript_segment (id, transcript_id, sequence_number, segment_text, start_ms, end_ms)
VALUES (CAST('77775000-0000-4000-8000-000000000071' AS UUID), CAST('77774000-0000-4000-8000-000000000002' AS UUID), 52, 'Wiem, gdzie ojciec łan orze, gdzie matka wybiela', NULL, NULL);
INSERT INTO transcript_segment (id, transcript_id, sequence_number, segment_text, start_ms, end_ms)
VALUES (CAST('77775000-0000-4000-8000-000000000072' AS UUID), CAST('77774000-0000-4000-8000-000000000002' AS UUID), 53, 'Cieniutkie płótna;', NULL, NULL);
INSERT INTO transcript_segment (id, transcript_id, sequence_number, segment_text, start_ms, end_ms)
VALUES (CAST('77775000-0000-4000-8000-000000000073' AS UUID), CAST('77774000-0000-4000-8000-000000000002' AS UUID), 54, 'Wiem, jak w święto wieczorem grzmi wiejska kapela,', NULL, NULL);
INSERT INTO transcript_segment (id, transcript_id, sequence_number, segment_text, start_ms, end_ms)
VALUES (CAST('77775000-0000-4000-8000-000000000074' AS UUID), CAST('77774000-0000-4000-8000-000000000002' AS UUID), 55, 'Jak fletnia smutna...', NULL, NULL);
INSERT INTO transcript_segment (id, transcript_id, sequence_number, segment_text, start_ms, end_ms)
VALUES (CAST('77775000-0000-4000-8000-000000000075' AS UUID), CAST('77774000-0000-4000-8000-000000000002' AS UUID), 56, 'Lasek, cmentarz, kościółek, starego plebana,', NULL, NULL);
INSERT INTO transcript_segment (id, transcript_id, sequence_number, segment_text, start_ms, end_ms)
VALUES (CAST('77775000-0000-4000-8000-000000000076' AS UUID), CAST('77774000-0000-4000-8000-000000000002' AS UUID), 57, 'Znam już z pamięci...', NULL, NULL);
INSERT INTO transcript_segment (id, transcript_id, sequence_number, segment_text, start_ms, end_ms)
VALUES (CAST('77775000-0000-4000-8000-000000000077' AS UUID), CAST('77774000-0000-4000-8000-000000000002' AS UUID), 58, 'Tęskno mi! — Hej, pociąga dal sina, nieznana,', NULL, NULL);
INSERT INTO transcript_segment (id, transcript_id, sequence_number, segment_text, start_ms, end_ms)
VALUES (CAST('77775000-0000-4000-8000-000000000078' AS UUID), CAST('77774000-0000-4000-8000-000000000002' AS UUID), 59, 'Wabi i nęci!', NULL, NULL);

-- Zamyślenie: 20 ordered lines, 8s initial offset, no exact cue timings.
INSERT INTO media_item (id, title, media_type, source_type, source_url, original_filename, storage_key, mime_type, file_size_bytes, sha256, duration_ms, publication_status, transcript_status, created_at, published_at)
VALUES (CAST('77773000-0000-4000-8000-000000000003' AS UUID), 'Zamyślenie', 'AUDIO', 'EXTERNAL_AUDIO', 'https://www.archive.org/download/multilingual_1204_librivox/polish_zamyslenie_lesmian_nib.mp3', NULL, NULL, 'audio/mpeg', NULL, NULL, NULL, 'PUBLISHED', 'DRAFT', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP);
INSERT INTO work_recording (work_id, media_item_id) VALUES (CAST('77772000-0000-4000-8000-000000000003' AS UUID), CAST('77773000-0000-4000-8000-000000000003' AS UUID));
INSERT INTO media_credit (id, media_item_id, creator_id, credit_role) VALUES (CAST('77776000-0000-4000-8000-000000000005' AS UUID), CAST('77773000-0000-4000-8000-000000000003' AS UUID), (SELECT id FROM creator WHERE lower(replace(display_name, ' ', '')) = lower(replace('Bolesław Leśmian', ' ', '')) ORDER BY created_at, id LIMIT 1), 'POET');
INSERT INTO media_credit (id, media_item_id, creator_id, credit_role) VALUES (CAST('77776000-0000-4000-8000-000000000006' AS UUID), CAST('77773000-0000-4000-8000-000000000003' AS UUID), (SELECT id FROM creator WHERE lower(replace(display_name, ' ', '')) = lower(replace('Nina Brown', ' ', '')) ORDER BY created_at, id LIMIT 1), 'ARTIST');
INSERT INTO transcript (id, media_item_id, language_code, full_text, created_at, updated_at, start_offset_ms)
VALUES (CAST('77774000-0000-4000-8000-000000000003' AS UUID), CAST('77773000-0000-4000-8000-000000000003' AS UUID), 'pl', 'Kto wybaczy mi moją do wróżby niezdolność?
Nie wiem, co dziś pokocham — co jutro wyśpiewam?
I dłonią, jak sierść zwierza, głaszczę mimowolność
Pieśni, których warczenia w sobie się spodziewam.
Po warczeniu poznaję, że przybyły z lasów,
I oswajam je zwolna i uczę swej mowy,
Aż zamęt ich podziemnych szmerów i hałasów
Wyprzejrzyści się nagle w okrzyk lazurowy.
Gdzie jar ciemny, gdzie rozstaj — tam powiew mej duszy,
Gdzie szepty pocałunków — tam są usta moje,
Gdzie chata mrze od progu — tam mój kij pastuszy,
Gdzie plusk wioseł — tam serca wędrowne napoje.
Lubię szaty swe liche, gdy nawskroś przemokną
Deszczem, jak łzami pieśni, co, szumiąc, zamiera,
A nie śpiewam, lecz jeno słowami przez okno
W świat wyglądam, choć nie wiem, kto okno otwiera.
Niech się pieśni me same ze siebie wygwarzą,
Obym ich nie dobywał, ale w sobie dożył!
A nie chcę im górować, ni barwić się twarzą,
Jeno być niewidzialnym, jak ten, co mnie stworzył.', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP, 8000);
INSERT INTO transcript_segment (id, transcript_id, sequence_number, segment_text, start_ms, end_ms)
VALUES (CAST('77775000-0000-4000-8000-000000000079' AS UUID), CAST('77774000-0000-4000-8000-000000000003' AS UUID), 0, 'Kto wybaczy mi moją do wróżby niezdolność?', NULL, NULL);
INSERT INTO transcript_segment (id, transcript_id, sequence_number, segment_text, start_ms, end_ms)
VALUES (CAST('77775000-0000-4000-8000-000000000080' AS UUID), CAST('77774000-0000-4000-8000-000000000003' AS UUID), 1, 'Nie wiem, co dziś pokocham — co jutro wyśpiewam?', NULL, NULL);
INSERT INTO transcript_segment (id, transcript_id, sequence_number, segment_text, start_ms, end_ms)
VALUES (CAST('77775000-0000-4000-8000-000000000081' AS UUID), CAST('77774000-0000-4000-8000-000000000003' AS UUID), 2, 'I dłonią, jak sierść zwierza, głaszczę mimowolność', NULL, NULL);
INSERT INTO transcript_segment (id, transcript_id, sequence_number, segment_text, start_ms, end_ms)
VALUES (CAST('77775000-0000-4000-8000-000000000082' AS UUID), CAST('77774000-0000-4000-8000-000000000003' AS UUID), 3, 'Pieśni, których warczenia w sobie się spodziewam.', NULL, NULL);
INSERT INTO transcript_segment (id, transcript_id, sequence_number, segment_text, start_ms, end_ms)
VALUES (CAST('77775000-0000-4000-8000-000000000083' AS UUID), CAST('77774000-0000-4000-8000-000000000003' AS UUID), 4, 'Po warczeniu poznaję, że przybyły z lasów,', NULL, NULL);
INSERT INTO transcript_segment (id, transcript_id, sequence_number, segment_text, start_ms, end_ms)
VALUES (CAST('77775000-0000-4000-8000-000000000084' AS UUID), CAST('77774000-0000-4000-8000-000000000003' AS UUID), 5, 'I oswajam je zwolna i uczę swej mowy,', NULL, NULL);
INSERT INTO transcript_segment (id, transcript_id, sequence_number, segment_text, start_ms, end_ms)
VALUES (CAST('77775000-0000-4000-8000-000000000085' AS UUID), CAST('77774000-0000-4000-8000-000000000003' AS UUID), 6, 'Aż zamęt ich podziemnych szmerów i hałasów', NULL, NULL);
INSERT INTO transcript_segment (id, transcript_id, sequence_number, segment_text, start_ms, end_ms)
VALUES (CAST('77775000-0000-4000-8000-000000000086' AS UUID), CAST('77774000-0000-4000-8000-000000000003' AS UUID), 7, 'Wyprzejrzyści się nagle w okrzyk lazurowy.', NULL, NULL);
INSERT INTO transcript_segment (id, transcript_id, sequence_number, segment_text, start_ms, end_ms)
VALUES (CAST('77775000-0000-4000-8000-000000000087' AS UUID), CAST('77774000-0000-4000-8000-000000000003' AS UUID), 8, 'Gdzie jar ciemny, gdzie rozstaj — tam powiew mej duszy,', NULL, NULL);
INSERT INTO transcript_segment (id, transcript_id, sequence_number, segment_text, start_ms, end_ms)
VALUES (CAST('77775000-0000-4000-8000-000000000088' AS UUID), CAST('77774000-0000-4000-8000-000000000003' AS UUID), 9, 'Gdzie szepty pocałunków — tam są usta moje,', NULL, NULL);
INSERT INTO transcript_segment (id, transcript_id, sequence_number, segment_text, start_ms, end_ms)
VALUES (CAST('77775000-0000-4000-8000-000000000089' AS UUID), CAST('77774000-0000-4000-8000-000000000003' AS UUID), 10, 'Gdzie chata mrze od progu — tam mój kij pastuszy,', NULL, NULL);
INSERT INTO transcript_segment (id, transcript_id, sequence_number, segment_text, start_ms, end_ms)
VALUES (CAST('77775000-0000-4000-8000-000000000090' AS UUID), CAST('77774000-0000-4000-8000-000000000003' AS UUID), 11, 'Gdzie plusk wioseł — tam serca wędrowne napoje.', NULL, NULL);
INSERT INTO transcript_segment (id, transcript_id, sequence_number, segment_text, start_ms, end_ms)
VALUES (CAST('77775000-0000-4000-8000-000000000091' AS UUID), CAST('77774000-0000-4000-8000-000000000003' AS UUID), 12, 'Lubię szaty swe liche, gdy nawskroś przemokną', NULL, NULL);
INSERT INTO transcript_segment (id, transcript_id, sequence_number, segment_text, start_ms, end_ms)
VALUES (CAST('77775000-0000-4000-8000-000000000092' AS UUID), CAST('77774000-0000-4000-8000-000000000003' AS UUID), 13, 'Deszczem, jak łzami pieśni, co, szumiąc, zamiera,', NULL, NULL);
INSERT INTO transcript_segment (id, transcript_id, sequence_number, segment_text, start_ms, end_ms)
VALUES (CAST('77775000-0000-4000-8000-000000000093' AS UUID), CAST('77774000-0000-4000-8000-000000000003' AS UUID), 14, 'A nie śpiewam, lecz jeno słowami przez okno', NULL, NULL);
INSERT INTO transcript_segment (id, transcript_id, sequence_number, segment_text, start_ms, end_ms)
VALUES (CAST('77775000-0000-4000-8000-000000000094' AS UUID), CAST('77774000-0000-4000-8000-000000000003' AS UUID), 15, 'W świat wyglądam, choć nie wiem, kto okno otwiera.', NULL, NULL);
INSERT INTO transcript_segment (id, transcript_id, sequence_number, segment_text, start_ms, end_ms)
VALUES (CAST('77775000-0000-4000-8000-000000000095' AS UUID), CAST('77774000-0000-4000-8000-000000000003' AS UUID), 16, 'Niech się pieśni me same ze siebie wygwarzą,', NULL, NULL);
INSERT INTO transcript_segment (id, transcript_id, sequence_number, segment_text, start_ms, end_ms)
VALUES (CAST('77775000-0000-4000-8000-000000000096' AS UUID), CAST('77774000-0000-4000-8000-000000000003' AS UUID), 17, 'Obym ich nie dobywał, ale w sobie dożył!', NULL, NULL);
INSERT INTO transcript_segment (id, transcript_id, sequence_number, segment_text, start_ms, end_ms)
VALUES (CAST('77775000-0000-4000-8000-000000000097' AS UUID), CAST('77774000-0000-4000-8000-000000000003' AS UUID), 18, 'A nie chcę im górować, ni barwić się twarzą,', NULL, NULL);
INSERT INTO transcript_segment (id, transcript_id, sequence_number, segment_text, start_ms, end_ms)
VALUES (CAST('77775000-0000-4000-8000-000000000098' AS UUID), CAST('77774000-0000-4000-8000-000000000003' AS UUID), 19, 'Jeno być niewidzialnym, jak ten, co mnie stworzył.', NULL, NULL);

-- Pani Twardowska: 124 ordered lines, 8s initial offset, no exact cue timings.
INSERT INTO media_item (id, title, media_type, source_type, source_url, original_filename, storage_key, mime_type, file_size_bytes, sha256, duration_ms, publication_status, transcript_status, created_at, published_at)
VALUES (CAST('77773000-0000-4000-8000-000000000004' AS UUID), 'Pani Twardowska', 'AUDIO', 'EXTERNAL_AUDIO', 'https://www.archive.org/download/multilingual_1204_librivox/polish_panitwardowska_mickiewicz_pn.mp3', NULL, NULL, 'audio/mpeg', NULL, NULL, NULL, 'PUBLISHED', 'DRAFT', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP);
INSERT INTO work_recording (work_id, media_item_id) VALUES (CAST('77772000-0000-4000-8000-000000000004' AS UUID), CAST('77773000-0000-4000-8000-000000000004' AS UUID));
INSERT INTO media_credit (id, media_item_id, creator_id, credit_role) VALUES (CAST('77776000-0000-4000-8000-000000000007' AS UUID), CAST('77773000-0000-4000-8000-000000000004' AS UUID), (SELECT id FROM creator WHERE lower(replace(display_name, ' ', '')) = lower(replace('Adam Mickiewicz', ' ', '')) ORDER BY created_at, id LIMIT 1), 'POET');
INSERT INTO media_credit (id, media_item_id, creator_id, credit_role) VALUES (CAST('77776000-0000-4000-8000-000000000008' AS UUID), CAST('77773000-0000-4000-8000-000000000004' AS UUID), (SELECT id FROM creator WHERE lower(replace(display_name, ' ', '')) = lower(replace('Piotr Nater', ' ', '')) ORDER BY created_at, id LIMIT 1), 'ARTIST');
INSERT INTO transcript (id, media_item_id, language_code, full_text, created_at, updated_at, start_offset_ms)
VALUES (CAST('77774000-0000-4000-8000-000000000004' AS UUID), CAST('77773000-0000-4000-8000-000000000004' AS UUID), 'pl', 'Jedzą, piją, lulki palą,
Tańce, hulanka, swawola;
Ledwie karczmy nie rozwalą,
Ha, ha! Hi, hi! hejże! hola!
Twardowski siadł w końcu stoła,
Podparł się w boki jak basza:
„Hulaj dusza! hulaj!” woła,
Śmieszy, tumani, przestrasza.
Żołnierzowi, co grał zucha,
Wszystkich łaje i potrąca,
Świsnął szablą koło ucha:
Już z żołnierza masz zająca.
Na patrona z trybunału,
Co milczkiem wypróżniał rondel,
Zadzwonił kieską, pomału:
Z patrona robi się kondel.
Szewcu w nos wyciął trzy szczutki,
Do łba przymknął trzy rureczki,
Cmoknął: cmok! i gdańskiej wódki
Wytoczył ze łba pół beczki.
Wtem, gdy wódkę pił z kielicha,
Kielich zaświstał, zazgrzytał;
Patrzy na dno: — „Co u licha?
Po coś tu, kumie, zawitał?”
Diablik to był w wódce na dnie:
Istny Niemiec, sztuczka kusa;
Skłonił się gościom układnie,
Zdjął kapelusz i dał susa.
Z kielicha aż na podłogę
Pada, rośnie na dwa łokcie,
Nos jak haczyk, kurzą nogę,
I krogulcze ma paznokcie.
„A, Twardowski… witam bracie!”
To mówiąc, bieży obcesem:
„Cóż to, czyliż mię nie znacie?
Jestem Mefistofelesem.
Wszak ze mnąś na Łysej Górze
Robił o duszę zapisy:
Cyrograf na byczej skórze
Podpisałeś ty i bisy.
Miały słuchać twego rymu;
Ty, jak dwa lata przebiegą,
Miałeś pojechać do Rzymu,
By cię tam porwać jak swego.
Już i siedem lat uciekło,
Cyrograf nadal nie służy:
Ty, czarami dręcząc piekło,
Ani myślisz o podróży.
Ale zemsta, choć leniwa,
Nagnała cię w nasze sieci:
Ta karczma Rzym się nazywa…
Kładę areszt na waszeci”.
Twardowski ku drzwiom się kwapił
Na takie dictum acerbum;
Diabeł za kontusz ułapił:
„A gdzie jest nobile verbum?”
Co tu począć? kusa rada,
Przyjdzie już nałożyć głową…
Twardowski na koncept wpada
I zadaje trudność nową.
„Patrz w kontrakt, Mefistofilu,
Tam warunki takie stoją:
Po latach tylu a tylu,
Gdy przyjdziesz brać duszę moją,
Będę miał prawo trzy razy
Zaprząc ciebie do roboty,
A ty najtwardsze rozkazy
Musisz spełnić co do joty.
Patrz, oto jest karczmy godło,
Koń malowany na płótnie;
Ja chcę mu wskoczyć na siodło,
A koń niech z kopyta utnie.
Skręć mi przy tym biczyk z piasku,
Żebym miał czym konia chłostać;
I wymuruj gmach w tym lasku,
Bym miał gdzie na popas zostać.
Gmach będzie z ziarnek orzecha,
Wysoki pod szczyt Krępaku,
Z bród żydowskich ma być strzecha,
Pobita nasieniem z maku.
Patrz, oto na miarę ćwieczek,
Cal gruby, długi trzy cale:
W każde z makowych ziareczek
Wbij mnie takie trzy bretnale”.
Mefistofil duchem skoczy,
Konia czyści, karmi, poi,
Potem bicz z piasku utoczy,
I już w gotowości stoi.
Twardowski dosiadł biegusa,
Probuje podskoków, zwrotów,
Stępa, galopuje, kłusa —
Patrzy, aż i gmach już gotów.
„No! wygrałeś, panie bisie,
Lecz druga rzecz nieskończona:
Trzeba skąpać się w tej misie —
A to jest woda święcona”.
Diabeł kurczy się i krztusi,
Aż zimny pot na nim bije:
Lecz pan każe, sługa musi,
Skąpał się biedak po szyję.
Wyleciał potem jak z procy,
Otrząsł się, dbrum! parsknął raźnie:
„Teraz jużeś w naszej mocy,
Najgorętsząm odbył łaźnię”.
„Jeszcze jedno, będzie kwita:
Zaraz pęknie moc czartowska! —
Patrzaj, oto jest kobiéta,
Moja żoneczka, Twardowska.
Ja na rok u Belzebuba
Przyjmę za ciebie mieszkanie;
Niech przez ten rok moja luba
Z tobą jak z mężem zostanie.
Przysiąż jej miłość, szacunek
I posłuszeństwo bez granic;
Złamiesz choć jeden warunek,
Już cała ugoda na nic”.
Diabeł do niego pół ucha,
Pół oka zwrócił do samki,
Niby patrzy, niby słucha —
Tymczasem już blisko klamki.
Gdy mu Twardowski dokucza,
Od drzwi, od okien odpycha,
Czmychnąwszy dziurką od klucza,
Dotąd, jak czmycha, tak czmycha.', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP, 8000);
INSERT INTO transcript_segment (id, transcript_id, sequence_number, segment_text, start_ms, end_ms)
VALUES (CAST('77775000-0000-4000-8000-000000000099' AS UUID), CAST('77774000-0000-4000-8000-000000000004' AS UUID), 0, 'Jedzą, piją, lulki palą,', NULL, NULL);
INSERT INTO transcript_segment (id, transcript_id, sequence_number, segment_text, start_ms, end_ms)
VALUES (CAST('77775000-0000-4000-8000-000000000100' AS UUID), CAST('77774000-0000-4000-8000-000000000004' AS UUID), 1, 'Tańce, hulanka, swawola;', NULL, NULL);
INSERT INTO transcript_segment (id, transcript_id, sequence_number, segment_text, start_ms, end_ms)
VALUES (CAST('77775000-0000-4000-8000-000000000101' AS UUID), CAST('77774000-0000-4000-8000-000000000004' AS UUID), 2, 'Ledwie karczmy nie rozwalą,', NULL, NULL);
INSERT INTO transcript_segment (id, transcript_id, sequence_number, segment_text, start_ms, end_ms)
VALUES (CAST('77775000-0000-4000-8000-000000000102' AS UUID), CAST('77774000-0000-4000-8000-000000000004' AS UUID), 3, 'Ha, ha! Hi, hi! hejże! hola!', NULL, NULL);
INSERT INTO transcript_segment (id, transcript_id, sequence_number, segment_text, start_ms, end_ms)
VALUES (CAST('77775000-0000-4000-8000-000000000103' AS UUID), CAST('77774000-0000-4000-8000-000000000004' AS UUID), 4, 'Twardowski siadł w końcu stoła,', NULL, NULL);
INSERT INTO transcript_segment (id, transcript_id, sequence_number, segment_text, start_ms, end_ms)
VALUES (CAST('77775000-0000-4000-8000-000000000104' AS UUID), CAST('77774000-0000-4000-8000-000000000004' AS UUID), 5, 'Podparł się w boki jak basza:', NULL, NULL);
INSERT INTO transcript_segment (id, transcript_id, sequence_number, segment_text, start_ms, end_ms)
VALUES (CAST('77775000-0000-4000-8000-000000000105' AS UUID), CAST('77774000-0000-4000-8000-000000000004' AS UUID), 6, '„Hulaj dusza! hulaj!” woła,', NULL, NULL);
INSERT INTO transcript_segment (id, transcript_id, sequence_number, segment_text, start_ms, end_ms)
VALUES (CAST('77775000-0000-4000-8000-000000000106' AS UUID), CAST('77774000-0000-4000-8000-000000000004' AS UUID), 7, 'Śmieszy, tumani, przestrasza.', NULL, NULL);
INSERT INTO transcript_segment (id, transcript_id, sequence_number, segment_text, start_ms, end_ms)
VALUES (CAST('77775000-0000-4000-8000-000000000107' AS UUID), CAST('77774000-0000-4000-8000-000000000004' AS UUID), 8, 'Żołnierzowi, co grał zucha,', NULL, NULL);
INSERT INTO transcript_segment (id, transcript_id, sequence_number, segment_text, start_ms, end_ms)
VALUES (CAST('77775000-0000-4000-8000-000000000108' AS UUID), CAST('77774000-0000-4000-8000-000000000004' AS UUID), 9, 'Wszystkich łaje i potrąca,', NULL, NULL);
INSERT INTO transcript_segment (id, transcript_id, sequence_number, segment_text, start_ms, end_ms)
VALUES (CAST('77775000-0000-4000-8000-000000000109' AS UUID), CAST('77774000-0000-4000-8000-000000000004' AS UUID), 10, 'Świsnął szablą koło ucha:', NULL, NULL);
INSERT INTO transcript_segment (id, transcript_id, sequence_number, segment_text, start_ms, end_ms)
VALUES (CAST('77775000-0000-4000-8000-000000000110' AS UUID), CAST('77774000-0000-4000-8000-000000000004' AS UUID), 11, 'Już z żołnierza masz zająca.', NULL, NULL);
INSERT INTO transcript_segment (id, transcript_id, sequence_number, segment_text, start_ms, end_ms)
VALUES (CAST('77775000-0000-4000-8000-000000000111' AS UUID), CAST('77774000-0000-4000-8000-000000000004' AS UUID), 12, 'Na patrona z trybunału,', NULL, NULL);
INSERT INTO transcript_segment (id, transcript_id, sequence_number, segment_text, start_ms, end_ms)
VALUES (CAST('77775000-0000-4000-8000-000000000112' AS UUID), CAST('77774000-0000-4000-8000-000000000004' AS UUID), 13, 'Co milczkiem wypróżniał rondel,', NULL, NULL);
INSERT INTO transcript_segment (id, transcript_id, sequence_number, segment_text, start_ms, end_ms)
VALUES (CAST('77775000-0000-4000-8000-000000000113' AS UUID), CAST('77774000-0000-4000-8000-000000000004' AS UUID), 14, 'Zadzwonił kieską, pomału:', NULL, NULL);
INSERT INTO transcript_segment (id, transcript_id, sequence_number, segment_text, start_ms, end_ms)
VALUES (CAST('77775000-0000-4000-8000-000000000114' AS UUID), CAST('77774000-0000-4000-8000-000000000004' AS UUID), 15, 'Z patrona robi się kondel.', NULL, NULL);
INSERT INTO transcript_segment (id, transcript_id, sequence_number, segment_text, start_ms, end_ms)
VALUES (CAST('77775000-0000-4000-8000-000000000115' AS UUID), CAST('77774000-0000-4000-8000-000000000004' AS UUID), 16, 'Szewcu w nos wyciął trzy szczutki,', NULL, NULL);
INSERT INTO transcript_segment (id, transcript_id, sequence_number, segment_text, start_ms, end_ms)
VALUES (CAST('77775000-0000-4000-8000-000000000116' AS UUID), CAST('77774000-0000-4000-8000-000000000004' AS UUID), 17, 'Do łba przymknął trzy rureczki,', NULL, NULL);
INSERT INTO transcript_segment (id, transcript_id, sequence_number, segment_text, start_ms, end_ms)
VALUES (CAST('77775000-0000-4000-8000-000000000117' AS UUID), CAST('77774000-0000-4000-8000-000000000004' AS UUID), 18, 'Cmoknął: cmok! i gdańskiej wódki', NULL, NULL);
INSERT INTO transcript_segment (id, transcript_id, sequence_number, segment_text, start_ms, end_ms)
VALUES (CAST('77775000-0000-4000-8000-000000000118' AS UUID), CAST('77774000-0000-4000-8000-000000000004' AS UUID), 19, 'Wytoczył ze łba pół beczki.', NULL, NULL);
INSERT INTO transcript_segment (id, transcript_id, sequence_number, segment_text, start_ms, end_ms)
VALUES (CAST('77775000-0000-4000-8000-000000000119' AS UUID), CAST('77774000-0000-4000-8000-000000000004' AS UUID), 20, 'Wtem, gdy wódkę pił z kielicha,', NULL, NULL);
INSERT INTO transcript_segment (id, transcript_id, sequence_number, segment_text, start_ms, end_ms)
VALUES (CAST('77775000-0000-4000-8000-000000000120' AS UUID), CAST('77774000-0000-4000-8000-000000000004' AS UUID), 21, 'Kielich zaświstał, zazgrzytał;', NULL, NULL);
INSERT INTO transcript_segment (id, transcript_id, sequence_number, segment_text, start_ms, end_ms)
VALUES (CAST('77775000-0000-4000-8000-000000000121' AS UUID), CAST('77774000-0000-4000-8000-000000000004' AS UUID), 22, 'Patrzy na dno: — „Co u licha?', NULL, NULL);
INSERT INTO transcript_segment (id, transcript_id, sequence_number, segment_text, start_ms, end_ms)
VALUES (CAST('77775000-0000-4000-8000-000000000122' AS UUID), CAST('77774000-0000-4000-8000-000000000004' AS UUID), 23, 'Po coś tu, kumie, zawitał?”', NULL, NULL);
INSERT INTO transcript_segment (id, transcript_id, sequence_number, segment_text, start_ms, end_ms)
VALUES (CAST('77775000-0000-4000-8000-000000000123' AS UUID), CAST('77774000-0000-4000-8000-000000000004' AS UUID), 24, 'Diablik to był w wódce na dnie:', NULL, NULL);
INSERT INTO transcript_segment (id, transcript_id, sequence_number, segment_text, start_ms, end_ms)
VALUES (CAST('77775000-0000-4000-8000-000000000124' AS UUID), CAST('77774000-0000-4000-8000-000000000004' AS UUID), 25, 'Istny Niemiec, sztuczka kusa;', NULL, NULL);
INSERT INTO transcript_segment (id, transcript_id, sequence_number, segment_text, start_ms, end_ms)
VALUES (CAST('77775000-0000-4000-8000-000000000125' AS UUID), CAST('77774000-0000-4000-8000-000000000004' AS UUID), 26, 'Skłonił się gościom układnie,', NULL, NULL);
INSERT INTO transcript_segment (id, transcript_id, sequence_number, segment_text, start_ms, end_ms)
VALUES (CAST('77775000-0000-4000-8000-000000000126' AS UUID), CAST('77774000-0000-4000-8000-000000000004' AS UUID), 27, 'Zdjął kapelusz i dał susa.', NULL, NULL);
INSERT INTO transcript_segment (id, transcript_id, sequence_number, segment_text, start_ms, end_ms)
VALUES (CAST('77775000-0000-4000-8000-000000000127' AS UUID), CAST('77774000-0000-4000-8000-000000000004' AS UUID), 28, 'Z kielicha aż na podłogę', NULL, NULL);
INSERT INTO transcript_segment (id, transcript_id, sequence_number, segment_text, start_ms, end_ms)
VALUES (CAST('77775000-0000-4000-8000-000000000128' AS UUID), CAST('77774000-0000-4000-8000-000000000004' AS UUID), 29, 'Pada, rośnie na dwa łokcie,', NULL, NULL);
INSERT INTO transcript_segment (id, transcript_id, sequence_number, segment_text, start_ms, end_ms)
VALUES (CAST('77775000-0000-4000-8000-000000000129' AS UUID), CAST('77774000-0000-4000-8000-000000000004' AS UUID), 30, 'Nos jak haczyk, kurzą nogę,', NULL, NULL);
INSERT INTO transcript_segment (id, transcript_id, sequence_number, segment_text, start_ms, end_ms)
VALUES (CAST('77775000-0000-4000-8000-000000000130' AS UUID), CAST('77774000-0000-4000-8000-000000000004' AS UUID), 31, 'I krogulcze ma paznokcie.', NULL, NULL);
INSERT INTO transcript_segment (id, transcript_id, sequence_number, segment_text, start_ms, end_ms)
VALUES (CAST('77775000-0000-4000-8000-000000000131' AS UUID), CAST('77774000-0000-4000-8000-000000000004' AS UUID), 32, '„A, Twardowski… witam bracie!”', NULL, NULL);
INSERT INTO transcript_segment (id, transcript_id, sequence_number, segment_text, start_ms, end_ms)
VALUES (CAST('77775000-0000-4000-8000-000000000132' AS UUID), CAST('77774000-0000-4000-8000-000000000004' AS UUID), 33, 'To mówiąc, bieży obcesem:', NULL, NULL);
INSERT INTO transcript_segment (id, transcript_id, sequence_number, segment_text, start_ms, end_ms)
VALUES (CAST('77775000-0000-4000-8000-000000000133' AS UUID), CAST('77774000-0000-4000-8000-000000000004' AS UUID), 34, '„Cóż to, czyliż mię nie znacie?', NULL, NULL);
INSERT INTO transcript_segment (id, transcript_id, sequence_number, segment_text, start_ms, end_ms)
VALUES (CAST('77775000-0000-4000-8000-000000000134' AS UUID), CAST('77774000-0000-4000-8000-000000000004' AS UUID), 35, 'Jestem Mefistofelesem.', NULL, NULL);
INSERT INTO transcript_segment (id, transcript_id, sequence_number, segment_text, start_ms, end_ms)
VALUES (CAST('77775000-0000-4000-8000-000000000135' AS UUID), CAST('77774000-0000-4000-8000-000000000004' AS UUID), 36, 'Wszak ze mnąś na Łysej Górze', NULL, NULL);
INSERT INTO transcript_segment (id, transcript_id, sequence_number, segment_text, start_ms, end_ms)
VALUES (CAST('77775000-0000-4000-8000-000000000136' AS UUID), CAST('77774000-0000-4000-8000-000000000004' AS UUID), 37, 'Robił o duszę zapisy:', NULL, NULL);
INSERT INTO transcript_segment (id, transcript_id, sequence_number, segment_text, start_ms, end_ms)
VALUES (CAST('77775000-0000-4000-8000-000000000137' AS UUID), CAST('77774000-0000-4000-8000-000000000004' AS UUID), 38, 'Cyrograf na byczej skórze', NULL, NULL);
INSERT INTO transcript_segment (id, transcript_id, sequence_number, segment_text, start_ms, end_ms)
VALUES (CAST('77775000-0000-4000-8000-000000000138' AS UUID), CAST('77774000-0000-4000-8000-000000000004' AS UUID), 39, 'Podpisałeś ty i bisy.', NULL, NULL);
INSERT INTO transcript_segment (id, transcript_id, sequence_number, segment_text, start_ms, end_ms)
VALUES (CAST('77775000-0000-4000-8000-000000000139' AS UUID), CAST('77774000-0000-4000-8000-000000000004' AS UUID), 40, 'Miały słuchać twego rymu;', NULL, NULL);
INSERT INTO transcript_segment (id, transcript_id, sequence_number, segment_text, start_ms, end_ms)
VALUES (CAST('77775000-0000-4000-8000-000000000140' AS UUID), CAST('77774000-0000-4000-8000-000000000004' AS UUID), 41, 'Ty, jak dwa lata przebiegą,', NULL, NULL);
INSERT INTO transcript_segment (id, transcript_id, sequence_number, segment_text, start_ms, end_ms)
VALUES (CAST('77775000-0000-4000-8000-000000000141' AS UUID), CAST('77774000-0000-4000-8000-000000000004' AS UUID), 42, 'Miałeś pojechać do Rzymu,', NULL, NULL);
INSERT INTO transcript_segment (id, transcript_id, sequence_number, segment_text, start_ms, end_ms)
VALUES (CAST('77775000-0000-4000-8000-000000000142' AS UUID), CAST('77774000-0000-4000-8000-000000000004' AS UUID), 43, 'By cię tam porwać jak swego.', NULL, NULL);
INSERT INTO transcript_segment (id, transcript_id, sequence_number, segment_text, start_ms, end_ms)
VALUES (CAST('77775000-0000-4000-8000-000000000143' AS UUID), CAST('77774000-0000-4000-8000-000000000004' AS UUID), 44, 'Już i siedem lat uciekło,', NULL, NULL);
INSERT INTO transcript_segment (id, transcript_id, sequence_number, segment_text, start_ms, end_ms)
VALUES (CAST('77775000-0000-4000-8000-000000000144' AS UUID), CAST('77774000-0000-4000-8000-000000000004' AS UUID), 45, 'Cyrograf nadal nie służy:', NULL, NULL);
INSERT INTO transcript_segment (id, transcript_id, sequence_number, segment_text, start_ms, end_ms)
VALUES (CAST('77775000-0000-4000-8000-000000000145' AS UUID), CAST('77774000-0000-4000-8000-000000000004' AS UUID), 46, 'Ty, czarami dręcząc piekło,', NULL, NULL);
INSERT INTO transcript_segment (id, transcript_id, sequence_number, segment_text, start_ms, end_ms)
VALUES (CAST('77775000-0000-4000-8000-000000000146' AS UUID), CAST('77774000-0000-4000-8000-000000000004' AS UUID), 47, 'Ani myślisz o podróży.', NULL, NULL);
INSERT INTO transcript_segment (id, transcript_id, sequence_number, segment_text, start_ms, end_ms)
VALUES (CAST('77775000-0000-4000-8000-000000000147' AS UUID), CAST('77774000-0000-4000-8000-000000000004' AS UUID), 48, 'Ale zemsta, choć leniwa,', NULL, NULL);
INSERT INTO transcript_segment (id, transcript_id, sequence_number, segment_text, start_ms, end_ms)
VALUES (CAST('77775000-0000-4000-8000-000000000148' AS UUID), CAST('77774000-0000-4000-8000-000000000004' AS UUID), 49, 'Nagnała cię w nasze sieci:', NULL, NULL);
INSERT INTO transcript_segment (id, transcript_id, sequence_number, segment_text, start_ms, end_ms)
VALUES (CAST('77775000-0000-4000-8000-000000000149' AS UUID), CAST('77774000-0000-4000-8000-000000000004' AS UUID), 50, 'Ta karczma Rzym się nazywa…', NULL, NULL);
INSERT INTO transcript_segment (id, transcript_id, sequence_number, segment_text, start_ms, end_ms)
VALUES (CAST('77775000-0000-4000-8000-000000000150' AS UUID), CAST('77774000-0000-4000-8000-000000000004' AS UUID), 51, 'Kładę areszt na waszeci”.', NULL, NULL);
INSERT INTO transcript_segment (id, transcript_id, sequence_number, segment_text, start_ms, end_ms)
VALUES (CAST('77775000-0000-4000-8000-000000000151' AS UUID), CAST('77774000-0000-4000-8000-000000000004' AS UUID), 52, 'Twardowski ku drzwiom się kwapił', NULL, NULL);
INSERT INTO transcript_segment (id, transcript_id, sequence_number, segment_text, start_ms, end_ms)
VALUES (CAST('77775000-0000-4000-8000-000000000152' AS UUID), CAST('77774000-0000-4000-8000-000000000004' AS UUID), 53, 'Na takie dictum acerbum;', NULL, NULL);
INSERT INTO transcript_segment (id, transcript_id, sequence_number, segment_text, start_ms, end_ms)
VALUES (CAST('77775000-0000-4000-8000-000000000153' AS UUID), CAST('77774000-0000-4000-8000-000000000004' AS UUID), 54, 'Diabeł za kontusz ułapił:', NULL, NULL);
INSERT INTO transcript_segment (id, transcript_id, sequence_number, segment_text, start_ms, end_ms)
VALUES (CAST('77775000-0000-4000-8000-000000000154' AS UUID), CAST('77774000-0000-4000-8000-000000000004' AS UUID), 55, '„A gdzie jest nobile verbum?”', NULL, NULL);
INSERT INTO transcript_segment (id, transcript_id, sequence_number, segment_text, start_ms, end_ms)
VALUES (CAST('77775000-0000-4000-8000-000000000155' AS UUID), CAST('77774000-0000-4000-8000-000000000004' AS UUID), 56, 'Co tu począć? kusa rada,', NULL, NULL);
INSERT INTO transcript_segment (id, transcript_id, sequence_number, segment_text, start_ms, end_ms)
VALUES (CAST('77775000-0000-4000-8000-000000000156' AS UUID), CAST('77774000-0000-4000-8000-000000000004' AS UUID), 57, 'Przyjdzie już nałożyć głową…', NULL, NULL);
INSERT INTO transcript_segment (id, transcript_id, sequence_number, segment_text, start_ms, end_ms)
VALUES (CAST('77775000-0000-4000-8000-000000000157' AS UUID), CAST('77774000-0000-4000-8000-000000000004' AS UUID), 58, 'Twardowski na koncept wpada', NULL, NULL);
INSERT INTO transcript_segment (id, transcript_id, sequence_number, segment_text, start_ms, end_ms)
VALUES (CAST('77775000-0000-4000-8000-000000000158' AS UUID), CAST('77774000-0000-4000-8000-000000000004' AS UUID), 59, 'I zadaje trudność nową.', NULL, NULL);
INSERT INTO transcript_segment (id, transcript_id, sequence_number, segment_text, start_ms, end_ms)
VALUES (CAST('77775000-0000-4000-8000-000000000159' AS UUID), CAST('77774000-0000-4000-8000-000000000004' AS UUID), 60, '„Patrz w kontrakt, Mefistofilu,', NULL, NULL);
INSERT INTO transcript_segment (id, transcript_id, sequence_number, segment_text, start_ms, end_ms)
VALUES (CAST('77775000-0000-4000-8000-000000000160' AS UUID), CAST('77774000-0000-4000-8000-000000000004' AS UUID), 61, 'Tam warunki takie stoją:', NULL, NULL);
INSERT INTO transcript_segment (id, transcript_id, sequence_number, segment_text, start_ms, end_ms)
VALUES (CAST('77775000-0000-4000-8000-000000000161' AS UUID), CAST('77774000-0000-4000-8000-000000000004' AS UUID), 62, 'Po latach tylu a tylu,', NULL, NULL);
INSERT INTO transcript_segment (id, transcript_id, sequence_number, segment_text, start_ms, end_ms)
VALUES (CAST('77775000-0000-4000-8000-000000000162' AS UUID), CAST('77774000-0000-4000-8000-000000000004' AS UUID), 63, 'Gdy przyjdziesz brać duszę moją,', NULL, NULL);
INSERT INTO transcript_segment (id, transcript_id, sequence_number, segment_text, start_ms, end_ms)
VALUES (CAST('77775000-0000-4000-8000-000000000163' AS UUID), CAST('77774000-0000-4000-8000-000000000004' AS UUID), 64, 'Będę miał prawo trzy razy', NULL, NULL);
INSERT INTO transcript_segment (id, transcript_id, sequence_number, segment_text, start_ms, end_ms)
VALUES (CAST('77775000-0000-4000-8000-000000000164' AS UUID), CAST('77774000-0000-4000-8000-000000000004' AS UUID), 65, 'Zaprząc ciebie do roboty,', NULL, NULL);
INSERT INTO transcript_segment (id, transcript_id, sequence_number, segment_text, start_ms, end_ms)
VALUES (CAST('77775000-0000-4000-8000-000000000165' AS UUID), CAST('77774000-0000-4000-8000-000000000004' AS UUID), 66, 'A ty najtwardsze rozkazy', NULL, NULL);
INSERT INTO transcript_segment (id, transcript_id, sequence_number, segment_text, start_ms, end_ms)
VALUES (CAST('77775000-0000-4000-8000-000000000166' AS UUID), CAST('77774000-0000-4000-8000-000000000004' AS UUID), 67, 'Musisz spełnić co do joty.', NULL, NULL);
INSERT INTO transcript_segment (id, transcript_id, sequence_number, segment_text, start_ms, end_ms)
VALUES (CAST('77775000-0000-4000-8000-000000000167' AS UUID), CAST('77774000-0000-4000-8000-000000000004' AS UUID), 68, 'Patrz, oto jest karczmy godło,', NULL, NULL);
INSERT INTO transcript_segment (id, transcript_id, sequence_number, segment_text, start_ms, end_ms)
VALUES (CAST('77775000-0000-4000-8000-000000000168' AS UUID), CAST('77774000-0000-4000-8000-000000000004' AS UUID), 69, 'Koń malowany na płótnie;', NULL, NULL);
INSERT INTO transcript_segment (id, transcript_id, sequence_number, segment_text, start_ms, end_ms)
VALUES (CAST('77775000-0000-4000-8000-000000000169' AS UUID), CAST('77774000-0000-4000-8000-000000000004' AS UUID), 70, 'Ja chcę mu wskoczyć na siodło,', NULL, NULL);
INSERT INTO transcript_segment (id, transcript_id, sequence_number, segment_text, start_ms, end_ms)
VALUES (CAST('77775000-0000-4000-8000-000000000170' AS UUID), CAST('77774000-0000-4000-8000-000000000004' AS UUID), 71, 'A koń niech z kopyta utnie.', NULL, NULL);
INSERT INTO transcript_segment (id, transcript_id, sequence_number, segment_text, start_ms, end_ms)
VALUES (CAST('77775000-0000-4000-8000-000000000171' AS UUID), CAST('77774000-0000-4000-8000-000000000004' AS UUID), 72, 'Skręć mi przy tym biczyk z piasku,', NULL, NULL);
INSERT INTO transcript_segment (id, transcript_id, sequence_number, segment_text, start_ms, end_ms)
VALUES (CAST('77775000-0000-4000-8000-000000000172' AS UUID), CAST('77774000-0000-4000-8000-000000000004' AS UUID), 73, 'Żebym miał czym konia chłostać;', NULL, NULL);
INSERT INTO transcript_segment (id, transcript_id, sequence_number, segment_text, start_ms, end_ms)
VALUES (CAST('77775000-0000-4000-8000-000000000173' AS UUID), CAST('77774000-0000-4000-8000-000000000004' AS UUID), 74, 'I wymuruj gmach w tym lasku,', NULL, NULL);
INSERT INTO transcript_segment (id, transcript_id, sequence_number, segment_text, start_ms, end_ms)
VALUES (CAST('77775000-0000-4000-8000-000000000174' AS UUID), CAST('77774000-0000-4000-8000-000000000004' AS UUID), 75, 'Bym miał gdzie na popas zostać.', NULL, NULL);
INSERT INTO transcript_segment (id, transcript_id, sequence_number, segment_text, start_ms, end_ms)
VALUES (CAST('77775000-0000-4000-8000-000000000175' AS UUID), CAST('77774000-0000-4000-8000-000000000004' AS UUID), 76, 'Gmach będzie z ziarnek orzecha,', NULL, NULL);
INSERT INTO transcript_segment (id, transcript_id, sequence_number, segment_text, start_ms, end_ms)
VALUES (CAST('77775000-0000-4000-8000-000000000176' AS UUID), CAST('77774000-0000-4000-8000-000000000004' AS UUID), 77, 'Wysoki pod szczyt Krępaku,', NULL, NULL);
INSERT INTO transcript_segment (id, transcript_id, sequence_number, segment_text, start_ms, end_ms)
VALUES (CAST('77775000-0000-4000-8000-000000000177' AS UUID), CAST('77774000-0000-4000-8000-000000000004' AS UUID), 78, 'Z bród żydowskich ma być strzecha,', NULL, NULL);
INSERT INTO transcript_segment (id, transcript_id, sequence_number, segment_text, start_ms, end_ms)
VALUES (CAST('77775000-0000-4000-8000-000000000178' AS UUID), CAST('77774000-0000-4000-8000-000000000004' AS UUID), 79, 'Pobita nasieniem z maku.', NULL, NULL);
INSERT INTO transcript_segment (id, transcript_id, sequence_number, segment_text, start_ms, end_ms)
VALUES (CAST('77775000-0000-4000-8000-000000000179' AS UUID), CAST('77774000-0000-4000-8000-000000000004' AS UUID), 80, 'Patrz, oto na miarę ćwieczek,', NULL, NULL);
INSERT INTO transcript_segment (id, transcript_id, sequence_number, segment_text, start_ms, end_ms)
VALUES (CAST('77775000-0000-4000-8000-000000000180' AS UUID), CAST('77774000-0000-4000-8000-000000000004' AS UUID), 81, 'Cal gruby, długi trzy cale:', NULL, NULL);
INSERT INTO transcript_segment (id, transcript_id, sequence_number, segment_text, start_ms, end_ms)
VALUES (CAST('77775000-0000-4000-8000-000000000181' AS UUID), CAST('77774000-0000-4000-8000-000000000004' AS UUID), 82, 'W każde z makowych ziareczek', NULL, NULL);
INSERT INTO transcript_segment (id, transcript_id, sequence_number, segment_text, start_ms, end_ms)
VALUES (CAST('77775000-0000-4000-8000-000000000182' AS UUID), CAST('77774000-0000-4000-8000-000000000004' AS UUID), 83, 'Wbij mnie takie trzy bretnale”.', NULL, NULL);
INSERT INTO transcript_segment (id, transcript_id, sequence_number, segment_text, start_ms, end_ms)
VALUES (CAST('77775000-0000-4000-8000-000000000183' AS UUID), CAST('77774000-0000-4000-8000-000000000004' AS UUID), 84, 'Mefistofil duchem skoczy,', NULL, NULL);
INSERT INTO transcript_segment (id, transcript_id, sequence_number, segment_text, start_ms, end_ms)
VALUES (CAST('77775000-0000-4000-8000-000000000184' AS UUID), CAST('77774000-0000-4000-8000-000000000004' AS UUID), 85, 'Konia czyści, karmi, poi,', NULL, NULL);
INSERT INTO transcript_segment (id, transcript_id, sequence_number, segment_text, start_ms, end_ms)
VALUES (CAST('77775000-0000-4000-8000-000000000185' AS UUID), CAST('77774000-0000-4000-8000-000000000004' AS UUID), 86, 'Potem bicz z piasku utoczy,', NULL, NULL);
INSERT INTO transcript_segment (id, transcript_id, sequence_number, segment_text, start_ms, end_ms)
VALUES (CAST('77775000-0000-4000-8000-000000000186' AS UUID), CAST('77774000-0000-4000-8000-000000000004' AS UUID), 87, 'I już w gotowości stoi.', NULL, NULL);
INSERT INTO transcript_segment (id, transcript_id, sequence_number, segment_text, start_ms, end_ms)
VALUES (CAST('77775000-0000-4000-8000-000000000187' AS UUID), CAST('77774000-0000-4000-8000-000000000004' AS UUID), 88, 'Twardowski dosiadł biegusa,', NULL, NULL);
INSERT INTO transcript_segment (id, transcript_id, sequence_number, segment_text, start_ms, end_ms)
VALUES (CAST('77775000-0000-4000-8000-000000000188' AS UUID), CAST('77774000-0000-4000-8000-000000000004' AS UUID), 89, 'Probuje podskoków, zwrotów,', NULL, NULL);
INSERT INTO transcript_segment (id, transcript_id, sequence_number, segment_text, start_ms, end_ms)
VALUES (CAST('77775000-0000-4000-8000-000000000189' AS UUID), CAST('77774000-0000-4000-8000-000000000004' AS UUID), 90, 'Stępa, galopuje, kłusa —', NULL, NULL);
INSERT INTO transcript_segment (id, transcript_id, sequence_number, segment_text, start_ms, end_ms)
VALUES (CAST('77775000-0000-4000-8000-000000000190' AS UUID), CAST('77774000-0000-4000-8000-000000000004' AS UUID), 91, 'Patrzy, aż i gmach już gotów.', NULL, NULL);
INSERT INTO transcript_segment (id, transcript_id, sequence_number, segment_text, start_ms, end_ms)
VALUES (CAST('77775000-0000-4000-8000-000000000191' AS UUID), CAST('77774000-0000-4000-8000-000000000004' AS UUID), 92, '„No! wygrałeś, panie bisie,', NULL, NULL);
INSERT INTO transcript_segment (id, transcript_id, sequence_number, segment_text, start_ms, end_ms)
VALUES (CAST('77775000-0000-4000-8000-000000000192' AS UUID), CAST('77774000-0000-4000-8000-000000000004' AS UUID), 93, 'Lecz druga rzecz nieskończona:', NULL, NULL);
INSERT INTO transcript_segment (id, transcript_id, sequence_number, segment_text, start_ms, end_ms)
VALUES (CAST('77775000-0000-4000-8000-000000000193' AS UUID), CAST('77774000-0000-4000-8000-000000000004' AS UUID), 94, 'Trzeba skąpać się w tej misie —', NULL, NULL);
INSERT INTO transcript_segment (id, transcript_id, sequence_number, segment_text, start_ms, end_ms)
VALUES (CAST('77775000-0000-4000-8000-000000000194' AS UUID), CAST('77774000-0000-4000-8000-000000000004' AS UUID), 95, 'A to jest woda święcona”.', NULL, NULL);
INSERT INTO transcript_segment (id, transcript_id, sequence_number, segment_text, start_ms, end_ms)
VALUES (CAST('77775000-0000-4000-8000-000000000195' AS UUID), CAST('77774000-0000-4000-8000-000000000004' AS UUID), 96, 'Diabeł kurczy się i krztusi,', NULL, NULL);
INSERT INTO transcript_segment (id, transcript_id, sequence_number, segment_text, start_ms, end_ms)
VALUES (CAST('77775000-0000-4000-8000-000000000196' AS UUID), CAST('77774000-0000-4000-8000-000000000004' AS UUID), 97, 'Aż zimny pot na nim bije:', NULL, NULL);
INSERT INTO transcript_segment (id, transcript_id, sequence_number, segment_text, start_ms, end_ms)
VALUES (CAST('77775000-0000-4000-8000-000000000197' AS UUID), CAST('77774000-0000-4000-8000-000000000004' AS UUID), 98, 'Lecz pan każe, sługa musi,', NULL, NULL);
INSERT INTO transcript_segment (id, transcript_id, sequence_number, segment_text, start_ms, end_ms)
VALUES (CAST('77775000-0000-4000-8000-000000000198' AS UUID), CAST('77774000-0000-4000-8000-000000000004' AS UUID), 99, 'Skąpał się biedak po szyję.', NULL, NULL);
INSERT INTO transcript_segment (id, transcript_id, sequence_number, segment_text, start_ms, end_ms)
VALUES (CAST('77775000-0000-4000-8000-000000000199' AS UUID), CAST('77774000-0000-4000-8000-000000000004' AS UUID), 100, 'Wyleciał potem jak z procy,', NULL, NULL);
INSERT INTO transcript_segment (id, transcript_id, sequence_number, segment_text, start_ms, end_ms)
VALUES (CAST('77775000-0000-4000-8000-000000000200' AS UUID), CAST('77774000-0000-4000-8000-000000000004' AS UUID), 101, 'Otrząsł się, dbrum! parsknął raźnie:', NULL, NULL);
INSERT INTO transcript_segment (id, transcript_id, sequence_number, segment_text, start_ms, end_ms)
VALUES (CAST('77775000-0000-4000-8000-000000000201' AS UUID), CAST('77774000-0000-4000-8000-000000000004' AS UUID), 102, '„Teraz jużeś w naszej mocy,', NULL, NULL);
INSERT INTO transcript_segment (id, transcript_id, sequence_number, segment_text, start_ms, end_ms)
VALUES (CAST('77775000-0000-4000-8000-000000000202' AS UUID), CAST('77774000-0000-4000-8000-000000000004' AS UUID), 103, 'Najgorętsząm odbył łaźnię”.', NULL, NULL);
INSERT INTO transcript_segment (id, transcript_id, sequence_number, segment_text, start_ms, end_ms)
VALUES (CAST('77775000-0000-4000-8000-000000000203' AS UUID), CAST('77774000-0000-4000-8000-000000000004' AS UUID), 104, '„Jeszcze jedno, będzie kwita:', NULL, NULL);
INSERT INTO transcript_segment (id, transcript_id, sequence_number, segment_text, start_ms, end_ms)
VALUES (CAST('77775000-0000-4000-8000-000000000204' AS UUID), CAST('77774000-0000-4000-8000-000000000004' AS UUID), 105, 'Zaraz pęknie moc czartowska! —', NULL, NULL);
INSERT INTO transcript_segment (id, transcript_id, sequence_number, segment_text, start_ms, end_ms)
VALUES (CAST('77775000-0000-4000-8000-000000000205' AS UUID), CAST('77774000-0000-4000-8000-000000000004' AS UUID), 106, 'Patrzaj, oto jest kobiéta,', NULL, NULL);
INSERT INTO transcript_segment (id, transcript_id, sequence_number, segment_text, start_ms, end_ms)
VALUES (CAST('77775000-0000-4000-8000-000000000206' AS UUID), CAST('77774000-0000-4000-8000-000000000004' AS UUID), 107, 'Moja żoneczka, Twardowska.', NULL, NULL);
INSERT INTO transcript_segment (id, transcript_id, sequence_number, segment_text, start_ms, end_ms)
VALUES (CAST('77775000-0000-4000-8000-000000000207' AS UUID), CAST('77774000-0000-4000-8000-000000000004' AS UUID), 108, 'Ja na rok u Belzebuba', NULL, NULL);
INSERT INTO transcript_segment (id, transcript_id, sequence_number, segment_text, start_ms, end_ms)
VALUES (CAST('77775000-0000-4000-8000-000000000208' AS UUID), CAST('77774000-0000-4000-8000-000000000004' AS UUID), 109, 'Przyjmę za ciebie mieszkanie;', NULL, NULL);
INSERT INTO transcript_segment (id, transcript_id, sequence_number, segment_text, start_ms, end_ms)
VALUES (CAST('77775000-0000-4000-8000-000000000209' AS UUID), CAST('77774000-0000-4000-8000-000000000004' AS UUID), 110, 'Niech przez ten rok moja luba', NULL, NULL);
INSERT INTO transcript_segment (id, transcript_id, sequence_number, segment_text, start_ms, end_ms)
VALUES (CAST('77775000-0000-4000-8000-000000000210' AS UUID), CAST('77774000-0000-4000-8000-000000000004' AS UUID), 111, 'Z tobą jak z mężem zostanie.', NULL, NULL);
INSERT INTO transcript_segment (id, transcript_id, sequence_number, segment_text, start_ms, end_ms)
VALUES (CAST('77775000-0000-4000-8000-000000000211' AS UUID), CAST('77774000-0000-4000-8000-000000000004' AS UUID), 112, 'Przysiąż jej miłość, szacunek', NULL, NULL);
INSERT INTO transcript_segment (id, transcript_id, sequence_number, segment_text, start_ms, end_ms)
VALUES (CAST('77775000-0000-4000-8000-000000000212' AS UUID), CAST('77774000-0000-4000-8000-000000000004' AS UUID), 113, 'I posłuszeństwo bez granic;', NULL, NULL);
INSERT INTO transcript_segment (id, transcript_id, sequence_number, segment_text, start_ms, end_ms)
VALUES (CAST('77775000-0000-4000-8000-000000000213' AS UUID), CAST('77774000-0000-4000-8000-000000000004' AS UUID), 114, 'Złamiesz choć jeden warunek,', NULL, NULL);
INSERT INTO transcript_segment (id, transcript_id, sequence_number, segment_text, start_ms, end_ms)
VALUES (CAST('77775000-0000-4000-8000-000000000214' AS UUID), CAST('77774000-0000-4000-8000-000000000004' AS UUID), 115, 'Już cała ugoda na nic”.', NULL, NULL);
INSERT INTO transcript_segment (id, transcript_id, sequence_number, segment_text, start_ms, end_ms)
VALUES (CAST('77775000-0000-4000-8000-000000000215' AS UUID), CAST('77774000-0000-4000-8000-000000000004' AS UUID), 116, 'Diabeł do niego pół ucha,', NULL, NULL);
INSERT INTO transcript_segment (id, transcript_id, sequence_number, segment_text, start_ms, end_ms)
VALUES (CAST('77775000-0000-4000-8000-000000000216' AS UUID), CAST('77774000-0000-4000-8000-000000000004' AS UUID), 117, 'Pół oka zwrócił do samki,', NULL, NULL);
INSERT INTO transcript_segment (id, transcript_id, sequence_number, segment_text, start_ms, end_ms)
VALUES (CAST('77775000-0000-4000-8000-000000000217' AS UUID), CAST('77774000-0000-4000-8000-000000000004' AS UUID), 118, 'Niby patrzy, niby słucha —', NULL, NULL);
INSERT INTO transcript_segment (id, transcript_id, sequence_number, segment_text, start_ms, end_ms)
VALUES (CAST('77775000-0000-4000-8000-000000000218' AS UUID), CAST('77774000-0000-4000-8000-000000000004' AS UUID), 119, 'Tymczasem już blisko klamki.', NULL, NULL);
INSERT INTO transcript_segment (id, transcript_id, sequence_number, segment_text, start_ms, end_ms)
VALUES (CAST('77775000-0000-4000-8000-000000000219' AS UUID), CAST('77774000-0000-4000-8000-000000000004' AS UUID), 120, 'Gdy mu Twardowski dokucza,', NULL, NULL);
INSERT INTO transcript_segment (id, transcript_id, sequence_number, segment_text, start_ms, end_ms)
VALUES (CAST('77775000-0000-4000-8000-000000000220' AS UUID), CAST('77774000-0000-4000-8000-000000000004' AS UUID), 121, 'Od drzwi, od okien odpycha,', NULL, NULL);
INSERT INTO transcript_segment (id, transcript_id, sequence_number, segment_text, start_ms, end_ms)
VALUES (CAST('77775000-0000-4000-8000-000000000221' AS UUID), CAST('77774000-0000-4000-8000-000000000004' AS UUID), 122, 'Czmychnąwszy dziurką od klucza,', NULL, NULL);
INSERT INTO transcript_segment (id, transcript_id, sequence_number, segment_text, start_ms, end_ms)
VALUES (CAST('77775000-0000-4000-8000-000000000222' AS UUID), CAST('77774000-0000-4000-8000-000000000004' AS UUID), 123, 'Dotąd, jak czmycha, tak czmycha.', NULL, NULL);

-- Dom na modrzewiu: 32 ordered lines, 10s initial offset, no exact cue timings.
INSERT INTO media_item (id, title, media_type, source_type, source_url, original_filename, storage_key, mime_type, file_size_bytes, sha256, duration_ms, publication_status, transcript_status, created_at, published_at)
VALUES (CAST('77773000-0000-4000-8000-000000000005' AS UUID), 'Dom na modrzewiu', 'AUDIO', 'EXTERNAL_AUDIO', 'https://archive.org/download/msw040_2601_librivox/msw040_08_domnamodrzewiu_mariapawlikowskajasnorzewska_pn81_128kb.mp3', NULL, NULL, 'audio/mpeg', NULL, NULL, NULL, 'PUBLISHED', 'DRAFT', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP);
INSERT INTO work_recording (work_id, media_item_id) VALUES (CAST('77772000-0000-4000-8000-000000000005' AS UUID), CAST('77773000-0000-4000-8000-000000000005' AS UUID));
INSERT INTO media_credit (id, media_item_id, creator_id, credit_role) VALUES (CAST('77776000-0000-4000-8000-000000000009' AS UUID), CAST('77773000-0000-4000-8000-000000000005' AS UUID), (SELECT id FROM creator WHERE lower(replace(display_name, ' ', '')) = lower(replace('Maria Pawlikowska-Jasnorzewska', ' ', '')) ORDER BY created_at, id LIMIT 1), 'POET');
INSERT INTO media_credit (id, media_item_id, creator_id, credit_role) VALUES (CAST('77776000-0000-4000-8000-000000000010' AS UUID), CAST('77773000-0000-4000-8000-000000000005' AS UUID), (SELECT id FROM creator WHERE lower(replace(display_name, ' ', '')) = lower(replace('Piotr Nater', ' ', '')) ORDER BY created_at, id LIMIT 1), 'ARTIST');
INSERT INTO transcript (id, media_item_id, language_code, full_text, created_at, updated_at, start_offset_ms)
VALUES (CAST('77774000-0000-4000-8000-000000000005' AS UUID), CAST('77773000-0000-4000-8000-000000000005' AS UUID), 'pl', 'Na niebotycznym modrzewiu,
modrzewiu o lekkich włosach,
który się w światła zarzewiu
kołysze i w złotych rosach,
wisi ptaszęce gniazdko —
gniazdko, skorupka orzecha —
domek, nad drzwiami strzecha,
strzecha ze słońca gwiazdką.
Wysoko, wysoko, wyżej,
wyżej, niż sięgnie drabina,
niż człowiek sam się wyspina,
czerni się domek w mgle ryżej.
Z wierzchołkiem cofa się, stoi,
wraca, kołuje w niebiosach —
w niebiosach skąd blask się roi
i plącze w modrzewia włosach.
Był modrzew rosą opity —
nie wiedząc poco i czemu
włożono ciężar młodemu
i wyniósł ciężar w błękity. —
Tam! tam wysoko na drzewie
w poszumach zamieszkać chcę!
Chcę! w mym żałosnym gniewie
pod złoto skryć się i rdzę!
I w domku pod chmur koroną
przekrzywić na bok głowę,
głowę, zatulnie wtuloną
w piórka czerwone i płowe.
I płowe... I nic nie żądać
lecz w bezpieczeństwie głębokiem,
głupio, o głupio spoglądać
na ziemię, w dół, jednem okiem. —', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP, 10000);
INSERT INTO transcript_segment (id, transcript_id, sequence_number, segment_text, start_ms, end_ms)
VALUES (CAST('77775000-0000-4000-8000-000000000223' AS UUID), CAST('77774000-0000-4000-8000-000000000005' AS UUID), 0, 'Na niebotycznym modrzewiu,', NULL, NULL);
INSERT INTO transcript_segment (id, transcript_id, sequence_number, segment_text, start_ms, end_ms)
VALUES (CAST('77775000-0000-4000-8000-000000000224' AS UUID), CAST('77774000-0000-4000-8000-000000000005' AS UUID), 1, 'modrzewiu o lekkich włosach,', NULL, NULL);
INSERT INTO transcript_segment (id, transcript_id, sequence_number, segment_text, start_ms, end_ms)
VALUES (CAST('77775000-0000-4000-8000-000000000225' AS UUID), CAST('77774000-0000-4000-8000-000000000005' AS UUID), 2, 'który się w światła zarzewiu', NULL, NULL);
INSERT INTO transcript_segment (id, transcript_id, sequence_number, segment_text, start_ms, end_ms)
VALUES (CAST('77775000-0000-4000-8000-000000000226' AS UUID), CAST('77774000-0000-4000-8000-000000000005' AS UUID), 3, 'kołysze i w złotych rosach,', NULL, NULL);
INSERT INTO transcript_segment (id, transcript_id, sequence_number, segment_text, start_ms, end_ms)
VALUES (CAST('77775000-0000-4000-8000-000000000227' AS UUID), CAST('77774000-0000-4000-8000-000000000005' AS UUID), 4, 'wisi ptaszęce gniazdko —', NULL, NULL);
INSERT INTO transcript_segment (id, transcript_id, sequence_number, segment_text, start_ms, end_ms)
VALUES (CAST('77775000-0000-4000-8000-000000000228' AS UUID), CAST('77774000-0000-4000-8000-000000000005' AS UUID), 5, 'gniazdko, skorupka orzecha —', NULL, NULL);
INSERT INTO transcript_segment (id, transcript_id, sequence_number, segment_text, start_ms, end_ms)
VALUES (CAST('77775000-0000-4000-8000-000000000229' AS UUID), CAST('77774000-0000-4000-8000-000000000005' AS UUID), 6, 'domek, nad drzwiami strzecha,', NULL, NULL);
INSERT INTO transcript_segment (id, transcript_id, sequence_number, segment_text, start_ms, end_ms)
VALUES (CAST('77775000-0000-4000-8000-000000000230' AS UUID), CAST('77774000-0000-4000-8000-000000000005' AS UUID), 7, 'strzecha ze słońca gwiazdką.', NULL, NULL);
INSERT INTO transcript_segment (id, transcript_id, sequence_number, segment_text, start_ms, end_ms)
VALUES (CAST('77775000-0000-4000-8000-000000000231' AS UUID), CAST('77774000-0000-4000-8000-000000000005' AS UUID), 8, 'Wysoko, wysoko, wyżej,', NULL, NULL);
INSERT INTO transcript_segment (id, transcript_id, sequence_number, segment_text, start_ms, end_ms)
VALUES (CAST('77775000-0000-4000-8000-000000000232' AS UUID), CAST('77774000-0000-4000-8000-000000000005' AS UUID), 9, 'wyżej, niż sięgnie drabina,', NULL, NULL);
INSERT INTO transcript_segment (id, transcript_id, sequence_number, segment_text, start_ms, end_ms)
VALUES (CAST('77775000-0000-4000-8000-000000000233' AS UUID), CAST('77774000-0000-4000-8000-000000000005' AS UUID), 10, 'niż człowiek sam się wyspina,', NULL, NULL);
INSERT INTO transcript_segment (id, transcript_id, sequence_number, segment_text, start_ms, end_ms)
VALUES (CAST('77775000-0000-4000-8000-000000000234' AS UUID), CAST('77774000-0000-4000-8000-000000000005' AS UUID), 11, 'czerni się domek w mgle ryżej.', NULL, NULL);
INSERT INTO transcript_segment (id, transcript_id, sequence_number, segment_text, start_ms, end_ms)
VALUES (CAST('77775000-0000-4000-8000-000000000235' AS UUID), CAST('77774000-0000-4000-8000-000000000005' AS UUID), 12, 'Z wierzchołkiem cofa się, stoi,', NULL, NULL);
INSERT INTO transcript_segment (id, transcript_id, sequence_number, segment_text, start_ms, end_ms)
VALUES (CAST('77775000-0000-4000-8000-000000000236' AS UUID), CAST('77774000-0000-4000-8000-000000000005' AS UUID), 13, 'wraca, kołuje w niebiosach —', NULL, NULL);
INSERT INTO transcript_segment (id, transcript_id, sequence_number, segment_text, start_ms, end_ms)
VALUES (CAST('77775000-0000-4000-8000-000000000237' AS UUID), CAST('77774000-0000-4000-8000-000000000005' AS UUID), 14, 'w niebiosach skąd blask się roi', NULL, NULL);
INSERT INTO transcript_segment (id, transcript_id, sequence_number, segment_text, start_ms, end_ms)
VALUES (CAST('77775000-0000-4000-8000-000000000238' AS UUID), CAST('77774000-0000-4000-8000-000000000005' AS UUID), 15, 'i plącze w modrzewia włosach.', NULL, NULL);
INSERT INTO transcript_segment (id, transcript_id, sequence_number, segment_text, start_ms, end_ms)
VALUES (CAST('77775000-0000-4000-8000-000000000239' AS UUID), CAST('77774000-0000-4000-8000-000000000005' AS UUID), 16, 'Był modrzew rosą opity —', NULL, NULL);
INSERT INTO transcript_segment (id, transcript_id, sequence_number, segment_text, start_ms, end_ms)
VALUES (CAST('77775000-0000-4000-8000-000000000240' AS UUID), CAST('77774000-0000-4000-8000-000000000005' AS UUID), 17, 'nie wiedząc poco i czemu', NULL, NULL);
INSERT INTO transcript_segment (id, transcript_id, sequence_number, segment_text, start_ms, end_ms)
VALUES (CAST('77775000-0000-4000-8000-000000000241' AS UUID), CAST('77774000-0000-4000-8000-000000000005' AS UUID), 18, 'włożono ciężar młodemu', NULL, NULL);
INSERT INTO transcript_segment (id, transcript_id, sequence_number, segment_text, start_ms, end_ms)
VALUES (CAST('77775000-0000-4000-8000-000000000242' AS UUID), CAST('77774000-0000-4000-8000-000000000005' AS UUID), 19, 'i wyniósł ciężar w błękity. —', NULL, NULL);
INSERT INTO transcript_segment (id, transcript_id, sequence_number, segment_text, start_ms, end_ms)
VALUES (CAST('77775000-0000-4000-8000-000000000243' AS UUID), CAST('77774000-0000-4000-8000-000000000005' AS UUID), 20, 'Tam! tam wysoko na drzewie', NULL, NULL);
INSERT INTO transcript_segment (id, transcript_id, sequence_number, segment_text, start_ms, end_ms)
VALUES (CAST('77775000-0000-4000-8000-000000000244' AS UUID), CAST('77774000-0000-4000-8000-000000000005' AS UUID), 21, 'w poszumach zamieszkać chcę!', NULL, NULL);
INSERT INTO transcript_segment (id, transcript_id, sequence_number, segment_text, start_ms, end_ms)
VALUES (CAST('77775000-0000-4000-8000-000000000245' AS UUID), CAST('77774000-0000-4000-8000-000000000005' AS UUID), 22, 'Chcę! w mym żałosnym gniewie', NULL, NULL);
INSERT INTO transcript_segment (id, transcript_id, sequence_number, segment_text, start_ms, end_ms)
VALUES (CAST('77775000-0000-4000-8000-000000000246' AS UUID), CAST('77774000-0000-4000-8000-000000000005' AS UUID), 23, 'pod złoto skryć się i rdzę!', NULL, NULL);
INSERT INTO transcript_segment (id, transcript_id, sequence_number, segment_text, start_ms, end_ms)
VALUES (CAST('77775000-0000-4000-8000-000000000247' AS UUID), CAST('77774000-0000-4000-8000-000000000005' AS UUID), 24, 'I w domku pod chmur koroną', NULL, NULL);
INSERT INTO transcript_segment (id, transcript_id, sequence_number, segment_text, start_ms, end_ms)
VALUES (CAST('77775000-0000-4000-8000-000000000248' AS UUID), CAST('77774000-0000-4000-8000-000000000005' AS UUID), 25, 'przekrzywić na bok głowę,', NULL, NULL);
INSERT INTO transcript_segment (id, transcript_id, sequence_number, segment_text, start_ms, end_ms)
VALUES (CAST('77775000-0000-4000-8000-000000000249' AS UUID), CAST('77774000-0000-4000-8000-000000000005' AS UUID), 26, 'głowę, zatulnie wtuloną', NULL, NULL);
INSERT INTO transcript_segment (id, transcript_id, sequence_number, segment_text, start_ms, end_ms)
VALUES (CAST('77775000-0000-4000-8000-000000000250' AS UUID), CAST('77774000-0000-4000-8000-000000000005' AS UUID), 27, 'w piórka czerwone i płowe.', NULL, NULL);
INSERT INTO transcript_segment (id, transcript_id, sequence_number, segment_text, start_ms, end_ms)
VALUES (CAST('77775000-0000-4000-8000-000000000251' AS UUID), CAST('77774000-0000-4000-8000-000000000005' AS UUID), 28, 'I płowe... I nic nie żądać', NULL, NULL);
INSERT INTO transcript_segment (id, transcript_id, sequence_number, segment_text, start_ms, end_ms)
VALUES (CAST('77775000-0000-4000-8000-000000000252' AS UUID), CAST('77774000-0000-4000-8000-000000000005' AS UUID), 29, 'lecz w bezpieczeństwie głębokiem,', NULL, NULL);
INSERT INTO transcript_segment (id, transcript_id, sequence_number, segment_text, start_ms, end_ms)
VALUES (CAST('77775000-0000-4000-8000-000000000253' AS UUID), CAST('77774000-0000-4000-8000-000000000005' AS UUID), 30, 'głupio, o głupio spoglądać', NULL, NULL);
INSERT INTO transcript_segment (id, transcript_id, sequence_number, segment_text, start_ms, end_ms)
VALUES (CAST('77775000-0000-4000-8000-000000000254' AS UUID), CAST('77774000-0000-4000-8000-000000000005' AS UUID), 31, 'na ziemię, w dół, jednem okiem. —', NULL, NULL);

